require 'byebug'
require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    keys = []
    vals = []
    params.each do |k, v|
      keys << "#{k} = ?"
      vals << v
    end
    keys = keys.join(" AND ")

    output = DBConnection.execute(<<-SQL, *vals)
      select *
      from
        #{self.table_name}
      where
        #{keys}
    SQL

    output.map! { |row| self.new(row) }
  end
end

class SQLObject
  extend Searchable
end
