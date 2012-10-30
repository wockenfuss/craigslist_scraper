require 'sqlite3'

class CLDatabase
  attr_reader :database

  def initialize(file_name)
    @database = SQLite3::Database.new(file_name)
  end

  def add_row(table_name, params)
puts "here"
    puts field_names = params.keys.join(', ')
    puts value_names = params.values.join(', ')
    insert_info = <<-eos
     INSERT INTO #{table_name}(#{field_names})
     VALUES(#{value_names});
     eos
     @database.execute(insert_info)
  end



end