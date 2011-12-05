require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name              = "rack-ssl-facebook"
    gem.summary           = "Force SSL/TLS in your app, preserving facebook's signed_request."
    gem.description       = "Rack middleware to force SSL/TLS, preserving facebook's signed_request."
    gem.email             = "mail@recursive-design.com"
    gem.homepage          = "https://github.com/recurser/rack-ssl-facebook"
    gem.authors           = ["Dave Perrett"]
    gem.rubyforge_project = 'nowarning'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
task :default => :test
Rake::TestTask.new do |t|
  t.warning = true
end

def version
  File.exist?('VERSION') ? File.read('VERSION') : ""
end

namespace :gem do  

  desc 'Clean build products'
  task :clean do
    rm_f 'pkg'
  end

  desc 'Build the gem'
  task :build => :clean do
    system 'rake gemspec'
    system 'rake build'
  end

  desc 'Push the gem to rubygems'
  task :publish => [:clean, :build] do
    system "gem push pkg/rack-ssl-facebook-#{version}.gem"
  end
  
end