#!/usr/bin/env ruby
require 'redmine_plugin_support'

Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'chiliproject_invoice'
  plugin.default_task = [:test]
  plugin.tasks = [:doc, :release, :clean, :test, :db, :stats, :metrics]
  # TODO: gem not getting this automaticly
  plugin.redmine_root = File.expand_path(File.dirname(__FILE__) + '/../../../')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "chiliproject_invoice"
    s.summary = "ChiliProject plugin to create and manage invoices"
    s.email = "edavis@littlestreamsoftware.com"
    s.homepage = "https://projects.littlestreamsoftware.com/projects/chiliproject_invoice"
    s.description = "ChiliProject plugin to create and manage invoices"
    s.authors = ["Eric Davis"]
    s.files =  FileList[
                        "[A-Z]*",
                        "init.rb",
                        "rails/init.rb",
                        "{bin,generators,lib,test,app,assets,config,lang}/**/*",
                        'lib/jeweler/templates/.gitignore'
                       ]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
