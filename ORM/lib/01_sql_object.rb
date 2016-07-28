require 'byebug'
require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
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
      #TODO -> make it so user doesn't have to call #finalize!
      # at end of subclass creation!!! (and delete it from the bottom)
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
    # ...
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
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end

  # self.finalize!
end
