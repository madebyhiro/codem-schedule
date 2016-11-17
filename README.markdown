[![Build Status](https://secure.travis-ci.org/madebyhiro/codem-schedule.png)](http://travis-ci.org/madebyhiro/codem-schedule)
[![Dependency Status](https://gemnasium.com/madebyhiro/codem-schedule.png)](https://gemnasium.com/madebyhiro/codem-schedule)
[![Code Climate](https://codeclimate.com/github/madebyhiro/codem-schedule.png)](https://codeclimate.com/github/madebyhiro/codem-schedule)

Codem Scheduler
===============

The Codem Scheduler is part of the Codem open source video transcoder platform. This application manages the scheduling and handling of jobs via a webfrontend and an API.

For documentation and general info, see <http://transcodem.com/>

Install instructions
--------------------
You'll need a Ruby on Rails installation, served by the webserver of your choice. Please note: Ruby 1.9.3 or greater is required, Ruby 2.0 is preferred.
See <http://rubyonrails.org/download> for installation instructions.

### Database
The preferred database backend for the Scheduler is either MySQL or SQLite. One of these should be available to
the Scheduler. If you're using MySQL, you can enter your connection details in `config/database.yml`.

If you want to use SQLite, you need to perform some changes. In `Gemfile`, change `mysql2` to `sqlite3` and run `bundle install`. In `config/database.yml`,
remove the username and password, and specify the location of your database. The preferred location is `db/codem_schedule_#{environment}.db`.

1 Either clone the git repository or download a packaged archive.

    $ git clone git://github.com/madebyhiro/codem-schedule.git
    or
    visit https://github.com/madebyhiro/codem-schedule/archives/master
  
2 Install the required gems.
  
    $ gem install bundler
    $ bundle install
    
3 Run the installer rake task, which will setup the application.

    $ bundle exec rake codem:install
 
4 Use cron or a similar tool to trigger the status update task. For example, to run the task every 2 minutes, use:

    */2 * * * * curl -s http://localhost:3000/api/schedule
   
5 Start the server, and you're ready to go!

    $ bundle exec rails server

Update instructions
-------------------
To update the Scheduler to the latest version, just run:

    $ bundle exec rake codem:update


API documentation
-----------------
View the API documentation at <http://rubydoc.info/github/madebyhiro/codem-schedule/master/frames>

Tests
-----
Tests are written in rspec and can be run with

    $ bundle exec rspec

## License

Codem-transcode is released under the MIT license, see `LICENSE.txt`.
