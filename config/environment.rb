require 'bundler'
Bundler.require :default, ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :development

require './lib/netid_syncinator'
NetIDSyncinator.initialize!
