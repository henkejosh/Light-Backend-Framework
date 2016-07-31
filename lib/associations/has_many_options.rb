require_relative 'assoc_options'

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
