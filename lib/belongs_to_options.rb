require_relative 'assoc_options'

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] ? options[:foreign_key] : "#{name}_id".to_sym
    @primary_key = options[:primary_key] ? options[:primary_key] : :id
    @class_name = options[:class_name] ? options[:class_name] : name.to_s.camelcase.singularize
  end
end
