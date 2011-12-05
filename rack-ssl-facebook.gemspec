# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rack-ssl-facebook"
  s.version = "1.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dave Perrett"]
  s.date = "2011-12-05"
  s.description = "Rack middleware to force SSL/TLS, preserving facebook's signed_request."
  s.email = "mail@recursive-design.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/rack/ssl_facebook.rb",
    "rack-ssl-facebook.gemspec",
    "test/test_ssl.rb"
  ]
  s.homepage = "https://github.com/recurser/rack-ssl-facebook"
  s.require_paths = ["lib"]
  s.rubyforge_project = "nowarning"
  s.rubygems_version = "1.8.11"
  s.summary = "Force SSL/TLS in your app, preserving facebook's signed_request."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
  end
end

