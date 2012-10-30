require './lib/cldatabase.rb'


describe CLDatabase do

  before(:all) do
     @database = SQLite3::Database.new("craigslist.db")

     @database.execute("DROP TABLE IF EXISTS search_results;")
     create_table = <<-eos
     CREATE TABLE search_results (id INTEGER PRIMARY KEY AUTOINCREMENT,
          search_term VARCHAR NOT NULL,
          search_url VARCHAR NOT NULL,
          search_date TEXT NOT NULL);
          eos
     @database.execute(create_table)
     @database.execute("DROP TABLE IF EXISTS postings;")
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

     insert_info = <<-eos
     INSERT INTO postings(title, url, price, location, category)
     VALUES("Bike for sale", "www.google.com", 150, "San Jose", "Bikes");
     eos
     @database.execute(insert_info)

     @cldata = CLDatabase.new('craigslist.db')
  end
  after(:each) do
      @database.execute("DELETE FROM postings;")
      @database.execute("DELETE FROM search_results;")
  end #clear tables


    context '#initialize' do


      it 'connects to an existing DB' do
        @cldata.database.execute("SELECT * FROM postings").length.should eq(1)
      end

      it "creates a new database if none exists" do
        @cldata2 = CLDatabase.new('testdata.db')

        @cldata2.database.execute("DROP TABLE IF EXISTS search_results;")
         create_table = <<-eos
         CREATE TABLE search_results (id INTEGER PRIMARY KEY AUTOINCREMENT,
              search_term VARCHAR NOT NULL,
              search_url VARCHAR NOT NULL,
              search_date TEXT NOT NULL);
              eos
         @cldata2.database.execute(create_table)

        @cldata2.database.execute("SELECT * FROM search_results").should eq([])
        File.delete('testdata.db')
      end

      it "creates a search_results table the first time it's run"

      it "creates a postings table the first time it's run"

    end

    context "#add_row" do
      it "adds a row to the appropriate table" do
        @cldata.add_row("postings", { title: '"Bike for sale"', url: '"www.google.com"', price: 150,
                                              location: '"San Jose"', category: '"Bikes"' })
        @cldata.database.execute("SELECT * FROM postings")[0][1].should eq("Bike for sale")
      end

    end






end

