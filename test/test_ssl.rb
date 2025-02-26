require 'rack/ssl_facebook'

require 'test/unit'
require 'rack/test'

class TestSSL < Test::Unit::TestCase
  include Rack::Test::Methods

  def default_app
    lambda { |env|
      headers = {'Content-Type' => "text/html"}
      headers['Set-Cookie'] = "id=1; path=/\ntoken=abc; path=/; secure; HttpOnly"
      [200, headers, ["OK"]]
    }
  end

  def app
    @app ||= Rack::SSLFacebook.new(default_app)
  end
  attr_writer :app

  def test_allows_https_url
    get "https://example.org/path?key=value"
    assert last_response.ok?
  end

  def test_allows_https_proxy_header_url
    get "http://example.org/", {}, 'HTTP_X_FORWARDED_PROTO' => "https"
    assert last_response.ok?
  end

  def test_redirects_http_to_https
    get "http://example.org/path?key=value"
    assert last_response.redirect?
    assert_equal "https://example.org/path?key=value",
      last_response.headers['Location']
  end

  def test_exclude_from_redirect
    self.app = Rack::SSLFacebook.new(default_app, :exclude => lambda { |env| true })
    get "http://example.org/"
    assert last_response.ok?
  end

  def test_hsts_header_by_default
    get "https://example.org/"
    assert_equal "max-age=31536000",
      last_response.headers['Strict-Transport-Security']
  end

  def test_hsts_header
    self.app = Rack::SSLFacebook.new(default_app, :hsts => true)
    get "https://example.org/"
    assert_equal "max-age=31536000",
      last_response.headers['Strict-Transport-Security']
  end

  def test_disable_hsts_header
    self.app = Rack::SSLFacebook.new(default_app, :hsts => false)
    get "https://example.org/"
    assert !last_response.headers['Strict-Transport-Security']
  end

  def test_hsts_expires
    self.app = Rack::SSLFacebook.new(default_app, :hsts => { :expires => 500 })
    get "https://example.org/"
    assert_equal "max-age=500",
      last_response.headers['Strict-Transport-Security']
  end

  def test_hsts_include_subdomains
    self.app = Rack::SSLFacebook.new(default_app, :hsts => { :subdomains => true })
    get "https://example.org/"
    assert_equal "max-age=31536000; includeSubDomains",
      last_response.headers['Strict-Transport-Security']
  end

  def test_flag_cookies_as_secure
    get "https://example.org/"
    assert_equal ["id=1; path=/; secure", "token=abc; path=/; secure; HttpOnly" ],
      last_response.headers['Set-Cookie'].split("\n")
  end

  def test_flag_cookies_as_secure_at_end_of_line
    self.app = Rack::SSLFacebook.new(lambda { |env|
      headers = {
        'Content-Type' => "text/html",
        'Set-Cookie' => "problem=def; path=/; HttpOnly; secure"
      }
      [200, headers, ["OK"]]
    })

    get "https://example.org/"
    assert_equal ["problem=def; path=/; HttpOnly; secure"],
      last_response.headers['Set-Cookie'].split("\n")
  end

  def test_legacy_array_headers
    self.app = Rack::SSLFacebook.new(lambda { |env|
      headers = {
        'Content-Type' => "text/html",
        'Set-Cookie' => ["id=1; path=/", "token=abc; path=/; HttpOnly"]
      }
      [200, headers, ["OK"]]
    })

    get "https://example.org/"
    assert_equal ["id=1; path=/; secure", "token=abc; path=/; HttpOnly; secure"],
      last_response.headers['Set-Cookie'].split("\n")
  end

  def test_no_cookies
    self.app = Rack::SSLFacebook.new(lambda { |env|
      [200, {'Content-Type' => "text/html"}, ["OK"]]
    })
    get "https://example.org/"
    assert !last_response.headers['Set-Cookie']
  end

  def test_redirect_to_host
    self.app = Rack::SSLFacebook.new(default_app, :host => "ssl.example.org")
    get "http://example.org/path?key=value"
    assert_equal "https://ssl.example.org/path?key=value",
      last_response.headers['Location']
  end

  def test_redirect_to_port
    self.app = Rack::SSLFacebook.new(default_app, :port => 8443)
    get "http://example.org/path?key=value"
    assert_equal "https://example.org:8443/path?key=value",
      last_response.headers['Location']
  end

  def test_redirect_to_host_and_port
    self.app = Rack::SSLFacebook.new(default_app, :host => "ssl.example.org", :port => 8443)
    get "http://example.org/path?key=value"
    assert_equal "https://ssl.example.org:8443/path?key=value",
      last_response.headers['Location']
  end

  def test_redirect_to_secure_host_when_on_subdomain
    self.app = Rack::SSLFacebook.new(default_app, :host => "ssl.example.org")
    get "http://ssl.example.org/path?key=value"
    assert_equal "https://ssl.example.org/path?key=value",
      last_response.headers['Location']
  end

  def test_redirect_to_secure_subdomain_when_on_deep_subdomain
    self.app = Rack::SSLFacebook.new(default_app, :host => "example.co.uk")
    get "http://double.rainbow.what.does.it.mean.example.co.uk/path?key=value"
    assert_equal "https://example.co.uk/path?key=value",
      last_response.headers['Location']
  end

  def test_redirect_with_signed_request
    self.app = Rack::SSLFacebook.new(default_app, :host => "ssl.example.org")
    post "http://example.org/path", {:signed_request => '1234'}
    assert_equal "https://ssl.example.org/path?signed_request=1234",
      last_response.headers['Location']
  end

  def test_redirect_with_signed_request_multi_params
    self.app = Rack::SSLFacebook.new(default_app, :host => "ssl.example.org")
    post "http://example.org/path?key=value", {:signed_request => '1234'}
    assert_equal "https://ssl.example.org/path?key=value&signed_request=1234",
      last_response.headers['Location']
  end
  
end
