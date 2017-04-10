# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-ga-track/version'

Gem::Specification.new do |s|
  s.name = "rack-ga-track"
  s.version = Rack::GaTrack::VERSION

  s.require_paths = ["lib"]
  s.authors = ["Daniel Nolan"]
  s.date = "2014-08-21"
  s.description = "If the user visits via a Google Analytics Campaign link,\n  this middleware will track utm_source, utm_content, utm_term, utm_medium, utm_campaign, and time."
  s.email = "dnolan@t1dexchange.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/rack-ga-track.rb",
    "rack-ga-track.gemspec",
    "spec/helper.rb",
    "spec/rack_ga_track_spec.rb"
  ]
  s.homepage = "http://github.com/unitio-org/rack-ga-track"
  s.metadata["allowed_push_host"] = "https://rubygems.org"
  s.licenses = ["MIT"]
  s.summary = "Tracks referrals via Google Analytics Campaign links."

  s.add_runtime_dependency(%q<rack>, ["> 1", "< 3"])
  s.add_development_dependency(%q<bundler>, [">= 1.14.6", "~> 1.14"])
  s.add_development_dependency(%q<simplecov>, [">= 0.14", "~> 0.14"])
  s.add_development_dependency(%q<rack-test>, [">= 0.6.2", "~> 0.6"])
  s.add_development_dependency(%q<minitest>, [">= 5.10.1", "~> 5.10"])
  s.add_development_dependency(%q<timecop>, [">= 0.7.1", "~> 0.7"])
end

