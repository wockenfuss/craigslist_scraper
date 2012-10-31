require 'sqlite3'

class CLDatabase
  attr_reader :database

  def initialize(file_name)
    @database = SQLite3::Database.new(file_name)
  end

  def add_row(table_name, params)
    return false if @database.execute("SELECT url FROM #{table_name}").any? { |url|  url[0] == params[:url][1..-2] }
    field_names = params.keys.join(', ')
    value_names = params.values.join(', ')
    insert_info = <<-eos
    INSERT INTO #{table_name}(#{field_names})
    VALUES(#{value_names});
    eos
    @database.execute(insert_info)
    @database.last_insert_row_id
  end

  def create_tables
    create_table = <<-eos
     CREATE TABLE search_results (id INTEGER PRIMARY KEY AUTOINCREMENT,
          search_term VARCHAR NOT NULL,
          url VARCHAR NOT NULL,
          search_date TEXT NOT NULL);
          eos
     @database.execute(create_table)

     create_table = <<-eos
     CREATE TABLE postings (id INTEGER PRIMARY KEY AUTOINCREMENT,
         title VARCHAR NOT NULL,
         url VARCHAR NOT NULL,
         price INTEGER,
         location TEXT NOT NULL,
         category TEXT NOT NULL,
         track_search_result INTEGER,
         FOREIGN KEY (track_search_result) REFERENCES search_results(id));
         eos
     @database.execute(create_table)
  end




end