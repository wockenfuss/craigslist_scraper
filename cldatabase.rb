require 'sqlite3'
require './posting.rb'

class CLDatabase
  attr_reader :database

  def initialize(file_name)
    @database = SQLite3::Database.new(file_name)
  end

  def add_row(table_name, params)
    #p params
    return false if @database.execute("SELECT url FROM #{table_name}").any? { |url|  url[0] == params[:s_url][1..-2] }
    field_names = params.keys.map{|k| k.to_s[2..-1]}.join(', ')
    value_names = params.map{|k,v| (k.to_s.split(//)[0] == 's') ? "'" + v.to_s + "'" : v }.join(', ')
    insert_info = "INSERT INTO #{table_name} (#{field_names}) VALUES(#{value_names});"
    begin 
      @database.execute(insert_info)
    #p insert_info
    #begin @database.execute("INSERT INTO ? \n (?) \n VALUES(?);", table_name, field_names, value_names) 
    rescue
      #puts "error"
    end
    @database.last_insert_row_id
  end

  def read_rows(search_url)
    posting_objects = []
    
    search_result_row = @database.execute("SELECT * FROM search_results WHERE url = ?", search_url)
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
     CREATE TABLE IF NOT EXISTS search_results (id INTEGER PRIMARY KEY AUTOINCREMENT,
          search_term VARCHAR NOT NULL,
          url VARCHAR NOT NULL,
          search_date VARCHAR NOT NULL);
          eos
     @database.execute(create_table)

     create_table = <<-eos
     CREATE TABLE IF NOT EXISTS postings (id INTEGER PRIMARY KEY AUTOINCREMENT,
         title VARCHAR NOT NULL,
         url VARCHAR NOT NULL,
         price VARCHAR,
         location VARCHAR NOT NULL,
         category VARCHAR NOT NULL,
         track_search_result INTEGER,
         FOREIGN KEY (track_search_result) REFERENCES search_results(id));
         eos
     @database.execute(create_table)
  end




end