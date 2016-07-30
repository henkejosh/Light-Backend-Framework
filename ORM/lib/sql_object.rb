require_relative 'db_connection'
require 'active_support/inflector'
require_relative 'searchable'
require_relative 'associatable'

#TODO 1 -> make it so user doesn't have to call #finalize!
# at end of subclass creation!!! (and delete it from the bottom)
# TODO 2 --> make insert/update methods private

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    unless @columns
      cols = DBConnection.execute2(<<-SQL)
        SELECT *
        FROM "#{self.table_name}"
        limit 1
      SQL
      @columns = cols.first.map(&:to_sym)
    end
    @columns
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        self.attributes[col]
      end

      define_method("#{col}=") do |item|
        self.attributes[col] = item
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    instances = DBConnection.execute(<<-SQL)
      select *
      from "#{self.table_name}"
    SQL
    self.parse_all(instances)
  end

  def self.parse_all(results)
    results.map do |entry|
      self.new(entry)
    end
  end

  def self.find(id)
    obj = DBConnection.execute(<<-SQL, id)
      select *
      from "#{self.table_name}"
      where id = ?
    SQL
    self.parse_all(obj).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      if self.class.columns.include?(attr_name.to_sym)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
    #TODO does this work??? do I need to calc based on calling attr
    # methods on each instance?
  end

  def insert
    columns = self.class.columns.dup
    columns.delete(:id)
    columns = columns.map(&:to_s).join(", ")

    vals = self.attribute_values

    qmarks = []
    vals.length.times { qmarks << "?" }
    qmarks = qmarks.join(", ")

    DBConnection.execute(<<-SQL, *vals)
      INSERT INTO
        #{self.class.table_name} (#{columns})
      VALUES
        (#{qmarks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    columns = self.class.columns.dup
    columns.delete(:id)

    vals = columns.map do |col|
      self.attributes[col]
    end

    columns = columns.map do |col|
      col.to_s << "= ?"
    end.join(", ")

    id = self.id

    DBConnection.execute(<<-SQL, *vals, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{columns}
      WHERE
        #{self.class.table_name}.id = ?
    SQL
  end

  def save
    self.id.nil? ? self.insert : self.update
  end

  # self.finalize!
end
