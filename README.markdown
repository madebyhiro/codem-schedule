[![Build Status](https://secure.travis-ci.org/madebyhiro/codem-schedule.png)](http://travis-ci.org/madebyhiro/codem-schedule)

Codem Scheduler
===============

The Codem Scheduler is part of the Codem open source video transcoder platform. This application manages the scheduling and handling of jobs via a webfrontend and an API.

For documentation and general info, see <http://transcodem.com/>

Install instructions
--------------------
You'll need a Ruby on Rails installation, served by the webserver of your choice. Please note: Ruby 1.9.2 or greater is required.
See <http://rubyonrails.org/download> for installation instructions.

1 Either clone the git repository or download a packaged archive.

    $ git clone git://github.com/madebyhiro/codem-schedule.git
    or
    visit https://github.com/madebyhiro/codem-schedule/archives/master
  
2 Install the required gems.
  
    $ bundle install
    
3 Run the installer rake task, which will setup the application.

    $ rake codem:install
 
4 Use cron or a similar tool to trigger the status update task. For example, to run the task every 2 minutes, use:

    */2 * * * * curl -s http://localhost:3000/api/schedule
   
5 Start the server, and you're ready to go!

    $ rails server

Update instructions
-------------------
To update the Scheduler to the latest version, just run:

    $ rake codem:update


API documentation
-----------------
View the API documentation at <http://rubydoc.info/github/madebyhiro/codem-schedule/master/frames>

Tests
-----
Tests are written in rspec and can be run with

    $ rspec documentation spec

## License

Codem-transcode is released under the MIT license, see `LICENSE.txt`.
