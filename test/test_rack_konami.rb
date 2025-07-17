require 'helper'
require 'rack/mock'

class TestRackKonami < Test::Unit::TestCase
  context "Embedding Rack::Konami" do
    should "place the konami code at the end of an HTML request" do
      assert_match EXPECTED_CODE, request.body
    end
    
    should "place the konami code at the end of an XHTML request" do
      assert_match EXPECTED_CODE, request(:content_type => 'application/xhtml+xml').body
    end
    
      should "not place the konami code in a non HTML request" do
        assert_no_match EXPECTED_CODE, request(:content_type => 'application/xml', :body => [XML]).body
      end

      should "update the Content-Length header when present" do
        res = request(:content_length => true)
        assert_equal res.body.bytesize.to_s, res["Content-Length"]
      end
    end
  
  context "Passing Options to Rack::Konami" do
    should "use the HTML you specified when using the app " do
      assert_match HTML_INCLUDED, request(:html => "<img src='/images/rails.png'>").body
    end
    
    should "use the DELAY you specified when using the app" do
      assert_match DELAY_INCLUDED, request(:delay => 500).body
    end
    
    should "use the defaults if you don't specifiy options" do
      assert_match DELAY_DEFAULT, request.body
      assert_match HTML_DEFAULT, request.body
    end
  end
  
  
  private
  
  EXPECTED_CODE = /<div\sid=.rack_konami.+konami\.load/m
  HTML_INCLUDED = /images\/rails.png/
  HTML_DEFAULT = /<!-- Konami Code -->/
  DELAY_INCLUDED = /\.delay\(500\)/
  DELAY_DEFAULT = /\.delay\(1000\)/
  
  EMBED_HTML = "<img src='/images/rails.png'>"
  
  HTML = <<-EOHTML
  <html>
    <head>
      <title>Sample Page</title>
    </head>
    <body>
      <h2>Rack::Konami Test</h2>
      <p>This is more test html</p>
    </body>
  </html>
  EOHTML
  
  XML = <<-EOXML
  <?xml version="1.0" encoding="ISO-8859-1"?>
  <user>
    <name>Mark Turner</name>
    <age>Unknown</age>
  </user>
  EOXML
  
  def request(options={})
    @app = app(options)
    request = Rack::MockRequest.new(@app).get('/')
    yield(@app, request) if block_given?
    request
  end
  
  def app(options={})
    options = options.clone
    options[:content_type] ||= "text/html"
    options[:body]         ||= [HTML]
    length_header = options.delete(:content_length)
    options[:html]         || nil
    options[:delay]        || nil
    headers = { 'Content-Type' => options.delete(:content_type) }
    body    = options.delete(:body)
    headers['Content-Length'] = body.join.bytesize.to_s if length_header
    rack_app = lambda { |env| [200, headers, body] }
    Rack::Konami.new(rack_app, :html => options[:html], :delay => options[:delay])
  end
  
end
