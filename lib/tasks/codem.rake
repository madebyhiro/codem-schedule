namespace :codem do

  namespace :install do
    
    desc "Create the database and run migrations"
    task :install_db => [:'db:create', :'db:migrate'] do
      puts "Created codem database and ran migrations."
      puts ""
    end

    desc "Setup a Transcoder instance"
    task :setup_transcoder => :environment do
      puts "If you already installed one or more Codem Transcoder instances, we can add it to the Scheduler for you."
      puts ""

      puts "Enter the url to the Codem Transcoder instance, or press <Enter> to skip:"
      url = STDIN.gets.chomp
      if url != ''
        if Host.create(:name => url, :url => url)
          puts "Host '#{url}' has been added"
        else
          puts "There was an error adding host '#{url}', please add it manually."
        end
      end
    end

    desc "Configure the Codem mailer"
    task :configure_mailer do
      puts "To send email notifications, the Codem mailer needs to be set up."
      puts "You can do this manually in config/initializers/action_mailer.rb"
      puts "Do you want to setup the mailer now? (y/n)"

      if ['y', 'yes'].include?(STDIN.gets.chomp)
        puts "Enter the default From: address for the mailer:"
        from = STDIN.gets.chomp
        puts "Enter the url (eg http://myhost.com/) under which the Codem Transcoder will be set up:"
        host = STDIN.gets.chomp
        
        File.open(File.join(Rails.root, 'config', 'initializers', 'action_mailer.rb'), 'w') do |file|
          file.write("ActionMailer::Base.default :from => \"#{from}\"\n")
          file.write("ActionMailer::Base.default_url_options[:host] = \"#{host}\"\n")
        end
      end
      puts ""
    end
    
    desc "Install the Codem Transcoder"
    task :install => :environment do
      puts "Creating database and running migrations...."
      Rake::Task["codem:install:install_db"].invoke
      
      Rake::Task["codem:install:setup_transcoder"].invoke
      
      Rake::Task["codem:install:configure_mailer"].invoke
      
      puts "The Codem scheduler setup is complete!"
      puts ""
      puts "Start the server by running 'rails server' and visit http://localhost:3000 in your browser."
      puts ""
    end
    
  end
  
  desc "Install the Codem Transcoder"
  task :install => ['install:install']
  
end