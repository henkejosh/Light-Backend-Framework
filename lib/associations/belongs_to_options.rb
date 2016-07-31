require_relative 'assoc_options'

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
