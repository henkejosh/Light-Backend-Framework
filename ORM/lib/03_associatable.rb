require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    if @class_name == "Human"
      return "humans"
    else
      @class_name.tableize
    end
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name}_id".to_sym,
      class_name: name.to_s.camelcase,
      primary_key: "id".to_sym
    }
    defaults.merge!(options)

    @foreign_key = defaults[:foreign_key]
    @class_name = defaults[:class_name]
    @primary_key = defaults[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name.downcase}_id".to_sym,
      class_name: "#{name.to_s.singularize.camelcase}",
      primary_key: "id".to_sym
    }
    defaults.merge!(options)

    @foreign_key = defaults[:foreign_key]
    @class_name = defaults[:class_name]
    @primary_key = defaults[:primary_key]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    define_method(name) do

      @options = BelongsToOptions.new(name, options)
      fk_val = self.send(@options.foreign_key)

      @options.model_class.where(@options.primary_key => fk_val).first
    end
  end

  def has_many(name, options = {})
    define_method(name) do
      @options = HasManyOptions.new(name, self.class.name, options)

      fk_val = self.send(@options.primary_key)

      @options.model_class.where(@options.foreign_key => fk_val)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end
