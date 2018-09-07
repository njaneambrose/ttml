require 'webrick'
require 'ttml'
require 'uri'
include WEBrick
include TTML

def start_webrick(config = {})
config.update(:Port => 1776)
server = HTTPServer.new(config)
mimeTypes = server.config[:MimeTypes] 
mimeTypes['ttml'] = 'text/plain'
yield server if block_given?
['INT', 'TERM'].each {|signal|
trap(signal) {server.shutdown}
}
server.start
end
class BreakT < HTTPServlet::AbstractServlet
 def do_GET(rq,rsp)
   if rq.query['q']
    e = URI.decode(rq.query['q'])
    erb = rq.query['erb'];
    cut = rq.query['cut'];
       if cut.empty?
            cut = false
        else
           cut = true
       end 
       if erb.empty?
            erb = false
         else
           erb = true
       end 
    e=e.gsub "$$","#";e=e.gsub "%%%",";"
    d = String.new
    last = String.new
          p= Route.new(e,erb,String.new,cut)
	   d << p.test
	   d = d.gsub "<", "&lt";d=d.gsub ">","&gt";d = d.gsub " ","&nbsp"
	   e = d.split(/\n/)
	   e.unshift("//Generated by TTML version 0.1.0")
	   e.each{|line| last<<line.to_s+"<br/>"}
      rsp['Content-Type'] = 'text/plain'
      rsp.body = last
    raise HTTPStatus::OK
   else
    raise HTTPStatus::ERROR
   end
 end
end
class Test < HTTPServlet::AbstractServlet
  def do_GET(rq,rsp)
    if rq.query['q']
	e = URI.decode(rq.query['q'])
    erb = rq.query['erb'];
    cut = rq.query['cut'];
       if cut.empty?
            cut = false
        else
           cut = true
       end 
       if erb.empty?
            erb = false
         else
           erb = true
       end 
    d = String.new
    last = String.new
       p= Route.new(e,erb,String.new,cut)
	   d << p.test
      rsp['Content-Type'] = 'text/html'
      rsp.body = d
    raise HTTPStatus::OK
   else
    raise HTTPStatus::ERROR  
	end
  end
end
start_webrick{|server|
server.mount("/try",BreakT)
server.mount("/test",Test)
server.mount("/documentation",HTTPServlet::DefaultFileHandler,'Documentation.html')
server.mount("/documentation/ttml",HTTPServlet::DefaultFileHandler,"documentation.ttml")
server.mount("/trynow",HTTPServlet::DefaultFileHandler,'Try.html')
server.mount("/trynow/ttml",HTTPServlet::DefaultFileHandler,"Try.ttml")
server.mount("/use",HTTPServlet::DefaultFileHandler,"Use.html")
server.mount("/use/ttml",HTTPServlet::DefaultFileHandler,"Use.ttml")
server.mount("/assets",HTTPServlet::FileHandler,"assets/")
server.mount("/fonts",HTTPServlet::FileHandler,"fonts/")
}