require './lib/cldatabase.rb'


describe CLDatabase do

  before(:all) do
     @database = SQLite3::Database.new("craigslist.db")

     @database.execute("DROP TABLE IF EXISTS search_results;")
     create_table = <<-eos
     CREATE TABLE search_results (id INTEGER PRIMARY KEY AUTOINCREMENT,
          search_term VARCHAR NOT NULL,
          url VARCHAR NOT NULL,
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
      before(:each) { @cldata2 = CLDatabase.new('testdata.db') }
      after(:each) { File.delete('testdata.db') }

      it 'connects to an existing DB' do
        @cldata.database.execute("SELECT * FROM postings").length.should eq(1)
      end

      it "creates a new database if none exists" do
        @cldata2.database.execute("DROP TABLE IF EXISTS search_results;")
        create_table = <<-eos
        CREATE TABLE search_results (id INTEGER PRIMARY KEY AUTOINCREMENT,
            search_term VARCHAR NOT NULL,
            url VARCHAR NOT NULL,
            search_date TEXT NOT NULL);
            eos
        @cldata2.database.execute(create_table)

        @cldata2.database.execute("SELECT * FROM search_results").should eq([])

      end

      it "creates search_results and postings tables the first time it's run" do
        @cldata2.create_tables
        @cldata2.database.execute("SELECT * FROM search_results").should eq([])
        @cldata2.database.execute("SELECT * FROM postings").should eq([])
      end

      it "creates a postings table the first time it's run"

    end

    context "#add_row" do

      it "returns an error if the row already exists in the postings database" do
        @cldata.add_row("postings", { title: '"Bike for sale"', url: '"www.google.com"', price: 150,
                                                location: '"San Jose"', category: '"Bikes"', track_search_result: 1 })
        @cldata.add_row("postings", { title: '"Bike for sale"', url: '"www.google.com"', price: 150,
                                                location: '"San Jose"', category: '"Bikes"' })
        @cldata.database.execute("SELECT * FROM postings").length.should eq(1)
      end

      it "returns an error if the row already exists in the search_results database" do
        @cldata.add_row("search_results", { search_term: '"bike"', url: '"http://www.google.com"', search_date: '"#{Time.now }"'})
        @cldata.add_row("search_results", { search_term: '"bike"', url: '"http://www.google.com"', search_date: '"#{Time.now }"'})
        @cldata.database.execute("SELECT * FROM search_results").length.should eq(1)
      end

      it "adds a row to the postings table" do
        @cldata.add_row("postings", { title: '"Bike for sale"', url: '"www.google.com"', price: 150,
                                              location: '"San Jose"', category: '"Bikes"' })
        @cldata.database.execute("SELECT * FROM postings")[0][1].should eq("Bike for sale")
      end

      it "adds a row to the search_results table" do
        @cldata.add_row("search_results", { search_term: '"bike"', url: '"http://www.google.com"', search_date: '"#{Time.now }"'})
        @cldata.database.execute("SELECT * FROM search_results")[0][1].should eq("bike")
      end

      it "returns the row's primary key after adding the row" do
        @cldata.database.execute("DELETE FROM search_results;")
        temp = @cldata.add_row("search_results", { search_term: '"bike"', url: '"http://www.google.com"', search_date: '"#{Time.now }"'})
        @cldata.database.execute("SELECT id FROM search_results")[0][0].should eq(temp)
      end

    end

    context "#read_row" do
      it "creates a Posting object with "






end

