require_relative 'searchable'
require_relative 'belongs_to_options'
require_relative 'has_many_options'
require 'active_support/inflector'

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do
      model_class = options.model_class
      self_foreign_id = self.send(options.foreign_key)
      options_id = options.primary_key
      model_class.where(options_id => self_foreign_id).first
    end

  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    define_method(name) do
      # debugger
      model_class = options.model_class
      options_foreign_id = options.foreign_key
      self_id = self.send(options.primary_key)
      model_class.where(options_foreign_id => self_id)
    end
  end

  # if name = house, through_name = human, source_name = house
  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name] # human options, class_name: 'Human', foreign_key: :owner_id
      source_options = through_options.model_class.assoc_options[source_name] # house options, class_name: 'House', foreign_key: :house_id
      mid_model_class = through_options.model_class # SQLObject of House
      # debugger
      through_table = through_options.table_name
      through_primary_key = through_options.primary_key
      through_foreign_key = through_options.foreign_key
      # debugger
      source_table = source_options.table_name
      source_primary_key = source_options.primary_key
      source_foreign_key = source_options.foreign_key

      through_id = self.send(through_foreign_key)
      results = DBConnection.execute(<<-SQL, through_id)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table} ON #{source_table}.#{source_primary_key} = #{through_table}.#{source_foreign_key}
        WHERE
          #{through_table}.#{through_primary_key} = ?;
      SQL

      source_options.model_class.parse_all(results).first
    end
  end

  private

  def assoc_options
    @assoc_options ||= {}
  end
end

# class SQLObject
#   extend Associatable
# end
