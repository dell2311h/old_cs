namespace :cs do
  desc "Populate DB by fake data"
  namespace :fake_data do
    DEFAULT_COUNT = 25
    
    desc "Populate DB by fake places (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :places => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
      records_number.times do
        Factory.create :place
      end
      puts "#{records_number} places were added to DB"
    end
    
    desc "Populate DB by fake events (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :events => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
      records_number.times do
        Factory.create :event
      end
      puts "#{records_number} events were added to DB"
    end
  end  
end

