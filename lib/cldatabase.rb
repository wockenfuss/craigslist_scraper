require 'posting'
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

  def read_rows(search_url)
    posting_objects = []
    search_result_row = @database.execute("SELECT * FROM search_results WHERE url = #{search_url}")
    #search_object = { search_term: "#{search_result_row[0][1]}", url: "#{search_result_row[0][2]}", search_date: "#{search_result_row[0][3]}" }
    postings = @database.execute("SELECT * FROM postings WHERE track_search_result = #{search_result_row[0][0]}")
    postings.each do |posting|
      posting_objects << { title: "#{posting[1]}", url: "#{posting[2]}", price: "#{posting[3]}", location: "#{posting[4]}", category: "#{posting[5]}" }
    end
    #return search_object, posting_objects
    return posting_objects
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