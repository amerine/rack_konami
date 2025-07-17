require "rack_konami/version"

module Rack
  class Konami
    KONAMI_CODE = <<-EOTC 
    <div id="rack_konami" style="display:none;position:fixed;top:20%;right:50%;">
      {{HTML}}
    </div>
    <script type="text/javascript">
    var Konami=function(){var a={addEvent:function(b,c,d,e){if(b.addEventListener)b.addEventListener(c,d,false);else if(b.attachEvent){b["e"+c+d]=d;b[c+d]=function(){b["e"+c+d](window.event,e)};b.attachEvent("on"+c,b[c+d])}},input:"",pattern:"3838404037393739666513",load:function(b){this.addEvent(document,"keydown",function(c,d){if(d)a=d;a.input+=c?c.keyCode:event.keyCode;if(a.input.length>a.pattern.length)a.input=a.input.substr(a.input.length-a.pattern.length);if(a.input==a.pattern){a.code(b);a.input=
    ""}},this);this.iphone.load(b)},code:function(b){window.location=b},iphone:{start_x:0,start_y:0,stop_x:0,stop_y:0,tap:false,capture:false,orig_keys:"",keys:["UP","UP","DOWN","DOWN","LEFT","RIGHT","LEFT","RIGHT","TAP","TAP","TAP"],code:function(b){a.code(b)},load:function(b){orig_keys=this.keys;a.addEvent(document,"touchmove",function(c){if(c.touches.length==1&&a.iphone.capture==true){c=c.touches[0];a.iphone.stop_x=c.pageX;a.iphone.stop_y=c.pageY;a.iphone.tap=false;a.iphone.capture=false;a.iphone.check_direction()}});
    a.addEvent(document,"touchend",function(){a.iphone.tap==true&&a.iphone.check_direction(b)},false);a.addEvent(document,"touchstart",function(c){a.iphone.start_x=c.changedTouches[0].pageX;a.iphone.start_y=c.changedTouches[0].pageY;a.iphone.tap=true;a.iphone.capture=true})},check_direction:function(b){x_magnitude=Math.abs(this.start_x-this.stop_x);y_magnitude=Math.abs(this.start_y-this.stop_y);x=this.start_x-this.stop_x<0?"RIGHT":"LEFT";y=this.start_y-this.stop_y<0?"DOWN":"UP";result=x_magnitude>y_magnitude?
    x:y;result=this.tap==true?"TAP":result;if(result==this.keys[0])this.keys=this.keys.slice(1,this.keys.length);if(this.keys.length==0){this.keys=this.orig_keys;this.code(b)}}}};return a};
    </script>
    <script type="text/javascript">
    	konami = new Konami()
    	konami.code = function() {
        $('#rack_konami').fadeIn('slow').delay({{DELAY}}).fadeOut('slow');
      }
    	konami.load()
    </script>
    EOTC

    def initialize(app, options={})
      @app = app
      @html = options[:html] || "<!-- Konami Code -->"
      @delay = sanitize_delay(options[:delay])
    end

    def call env
      dup._call env
    end

    def _call env
      status, headers, response = @app.call env

      if should_inject_konami_code? status, headers, response
        response = inject_konami_code response
        fix_content_length(headers, response)
      end

      [status, headers, response]
    end

    def should_inject_konami_code? status, headers, response
      content_type = headers["Content-Type"] || headers["content-type"]

      status == 200 &&
      content_type &&
      (content_type.include?("text/html") || content_type.include?("application/xhtml"))
    end

    def inject_konami_code response, body=""
      response.each { |s| body << s.to_s }
      body.gsub(/<\/body>/, "#{substitute_vars}\n</body>")
    end

    def fix_content_length headers, response
      key = if headers.key?('Content-Length')
              'Content-Length'
            elsif headers.key?('content-length')
              'content-length'
            end

      return unless key

      length = 0
      Array(response).each { |part| length += part.to_s.bytesize }
      headers[key] = length.to_s
    end

    def substitute_vars
      code = KONAMI_CODE.gsub(/\{\{HTML\}\}/, @html.to_s)
      code.gsub(/\{\{DELAY\}\}/, @delay.to_s)
    end
    private :substitute_vars

    def sanitize_delay(value)
      value = 1000 if value.nil?
      Integer(value)
    rescue ArgumentError, TypeError
      1000
    end
    private :sanitize_delay
  end
end
