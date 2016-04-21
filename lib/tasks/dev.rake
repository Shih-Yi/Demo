namespace :dev do

  task :ubike => :environment do

    url = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=ddb80380-f1b3-4f8e-8016-7ed9cba571d5"

    json_string = RestClient.get(url)

    data = JSON.parse( json_string )

    data["result"]["results"].each do |u|
      existing = Ubike.find_by_raw_id( u["_id"] )
      if existing
        # update
      else
        Ubike.create( :raw_id => u["_id"], :name => u["sna"])
        puts "create #{u["sna"]}"
      end
    end

  end

  task :rebuild => ["db:drop", "db:setup", :fake]
  # task :rebuild => ["db:drop", "db:create", "db:schema:load", "db:seed", :fake] #等於上一行

  task :fake => :environment do
    User.delete_all
    Event.delete_all
    Attendee.delete_all

    puts "Creating fake data!!"
    user = User.create!(:email=> "brvast@gmail.com", :password => "12345678", :role => "admin")

    50.times do |i|
      e = Event.create(:name => Faker::App.name)
      10.times do |j|
        e.attendees.create(:name => Faker::Name.name)
      end
    end

  end

  task :fake_products => :environment do
    Product.delete_all
    100.times do
      p = Product.create!(:name => Faker::Lorem.word, :description => Faker::Lorem.paragraph, :price => (rand(100) + 1) * 100)
      puts "creating product #{p.id}"
    end
  end

end
