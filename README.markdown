Codem Scheduler
===============

The Codem Scheduler is part of the Codem open source video transcoder platform. This application manages the scheduling and handling of jobs via a webfrontend and an API.

For documentation and general info, see <http://npo.github.com/codem/>

Install instructions
--------------------
You'll need a Ruby on Rails installation, served by the webserver of your choice.
See <http://rubyonrails.org/download> for installation instructions.

1 Either clone the git repository or download a packaged archive.

    $ git clone git://github.com/NPO/codem-schedule.git
    or
    visit https://github.com/NPO/codem-schedule/archives/master
  
2 Install the required gems
  
    $ bundle install
    
3 Run the installer rake task, which will setup the application.

    $ rake codem:install
    
4 Start the server, and you're ready to go!

    $ rails server

API documentation
-----------------
View the API documentation at <http://rubydoc.info/github/NPO/codem-schedule/master/frames>

Tests
-----
Tests are written in rspec and can be run with

    $ rspec -f documentation spec

## License

Codem-transcode is released under the MIT license, see `LICENSE.txt`.