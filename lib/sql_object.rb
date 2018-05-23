# require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'
require 'active_support/inflector'
require 'byebug'

# require 'sqlite3'
# CATS_DB_FILE = File.join(ROOT_FOLDER, 'cats.db')

class SQLObject
  # giving class of SQLObject access to the methods in these modules
  extend Searchable
  extend Associatable

  def self.columns
    return @columns if @columns

    res = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    # db = SQLite3::Database.new(CATS_DB_FILE)
    # res = db.execute2(<<-SQL)
    #   SELECT
    #     *
    #   FROM
    #     #{self.table_name}
    # SQL
    # table name can not be replaced with a placeholder
    # returns each row in a array by default instead of a hash

    @columns = res.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |column_name|
      define_method(column_name) do
        attributes[column_name]
      end

      define_method("#{column_name}=") do |new_value|
        attributes[column_name] = new_value
      end
    end
  end

  # def self.finalize!
  #   self.columns.each do |column_name|
  #     define_method(column_name) do
  #       @attributes[column_name]
  #     end
  #
  #     define_method("#{column_name}=") do |new_value|
  #       @attributes[column_name] = new_value
  #     end
  #   end
  # end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ? @table_name : self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name};
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result)}
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL

    result.empty? ? nil : parse_all(result)[0]
  end

  def initialize(params = {})
    # @attributes = {}
    attr_names = self.class.columns
    params.each do |attr_name, attr_value|
      raise("unknown attribute '#{attr_name}'") unless attr_names.include?(attr_name.to_sym)
      self.send("#{attr_name}=", attr_value)
    end
  end

  def attributes
    # debugger
    @attributes ||= {}

  end

  def attribute_values
    attributes.values
  end

  def save
    id ? update : insert
  end

  private

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{self.class.columns.drop(1).join(',')})
      VALUES
        (#{(["?"] * self.attributes.length).join(',')});
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    DBConnection.execute(<<-SQL, *attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{self.class.columns.map {|col| "#{col} = ?"}.join(',')}
      WHERE
        id = #{self.id}
    SQL
  end

end
