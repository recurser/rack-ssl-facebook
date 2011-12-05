Gem::Specification.new do |s|
  s.name      = 'rack-ssl-facebook'
  s.version   = '1.3.3'
  s.date      = '2011-12-05'

  s.homepage    = "https://github.com/recurser/rack-ssl-facebook"
  s.summary     = "Force SSL/TLS in your app, preserving facebook's signed_request."
  s.description = <<-EOS
    Rack middleware to force SSL/TLS, preserving facebook's signed_request.
  EOS

  s.files = [
    'lib/rack/ssl.rb',
    'LICENSE',
    'README.md'
  ]

  s.add_dependency 'rack'

  s.authors           = ["Joshua Peek", "Dave Perrett"]
  s.email             = "mail@recursive-design.com"
  s.rubyforge_project = 'rack-ssl-facebook'
end
