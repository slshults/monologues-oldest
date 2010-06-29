# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.time_zone = 'UTC'

end

class Logger
  def format_message(severity, timestamp, progname, msg)
    "[#{timestamp.strftime("%Y-%m-%d %H:%M:%S")}] #{severity} #{msg}\n"
  end
end

APPLOG = Logger.new("#{RAILS_ROOT}/log/monologues.log")
APPLOG.level = Logger::DEBUG

####
## load some unchanging data
##
## classifications
#COMEDIES = Play.find_all_by_classification('Comedy')
#HISTORIES = Play.find_all_by_classification('History')
#TRAGEDIES = Play.find_all_by_classification('Tragedy')
#
## map gender name and id object
#GENDER = Hash.new
#Gender.all.map{|g| GENDER[g.name] = g}
#Gender.all.map{|g| GENDER[g.id] = g}
#Gender.all.map{|g| GENDER[g.id.to_s] = g}
