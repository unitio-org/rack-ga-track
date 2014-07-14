# encoding: utf-8
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rack-ga-track"
  gem.homepage = "http://github.com/T1D/rack-ga-track"
  gem.license = "MIT"
  gem.summary = %Q{Tracks referrals via Google Analytics Campaign links.}
  gem.description = %Q{If the user visits via a Google Analytics Campaign link,
  this middleware will track utm_source, utm_content, utm_term, utm_medium, utm_campaign, and time.}
  gem.email = "dnolan@t1dexchange.org"
  gem.authors = ["Daniel Nolan"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:spec) do |test|
  test.libs << 'lib' << 'spec'
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end

task :default => :spec
