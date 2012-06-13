namespace :cs do
  desc "Populate DB by fake data"
  namespace :fake_data do
    DEFAULT_COUNT = 25

    desc "Populate all instances"
    task :all => :environment do
      Rake::Task['cs:fake_data:places'].execute
      Rake::Task['cs:fake_data:events'].execute
      Rake::Task['cs:fake_data:comments'].execute
      Rake::Task['cs:fake_data:videos'].execute
      Rake::Task['cs:fake_data:songs'].execute
      Rake::Task['cs:fake_data:performers'].execute

    end

    desc "Populate DB by fake places (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :places => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
      records_number.times do
        Factory.create :place
        print '.'
      end
      puts "\n#{records_number} places were added to DB"
    end
    
    desc "Populate DB by fake events (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :events => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
      records_number.times do
        Factory.create :event
        print '.'
      end
      puts "\n#{records_number} events were added to DB"
    end
    
    COUNT = 5 # Amount of objects for which comments, videos and songs will be created
    
    desc "Populate DB by fake comments (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :comments => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
        records_number.times do
          Factory.create :comment
          print '.'
        end
      puts "\n#{count} comments were added to DB"
    end

    desc "Populate DB by fake videos (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :videos => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
      count = COUNT * records_number
      Event.limit(COUNT).each do |event|      
        records_number.times do
          Factory.create :video, :event => event
          print '.'
        end
      end  
      puts "\n#{count} videos were added to DB"
    end
    
    desc "Populate DB by fake songs (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :songs => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
      count = COUNT * records_number
      Video.limit(COUNT).each do |video|      
        records_number.times do
          Factory.create :song, :videos => [video]
          print '.'
        end
      end  
      puts "\n#{count} songs were added to DB"
    end

    desc "Populate DB by fake performers (Amount can be specified by NUM_RECORDS env variable. Default is #{DEFAULT_COUNT})"
    task :performers => :environment do
      records_number = ENV['NUM_RECORDS'] ? ENV['NUM_RECORDS'].to_i : DEFAULT_COUNT
        events = Event.limit(COUNT)
        records_number.times do
          performer = Factory.create :performer, :events => events
          print '.'
        end
      puts "\n#{records_number} performers were added to DB"
    end

  end  
end

