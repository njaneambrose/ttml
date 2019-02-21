#= Shorcut module
#This is the shortcut store for Taxi it contains shortened tags that promote faster development of projects.
#It provides flexibility in writing of projects with very minimal tags to represent long sentences
#==Example
#This is just a sample of them visit http://github.com/njaneambrose/taxi/docs/documentation.html#short to see more
# sp      => span
# doc5    => <!DOCTYPE html>
# utf8    => <meta charset="UTF-8"/>
# --d description         => <meta name="description" content="description"/>
# --st /assets/style.css  => <link rel="stylesheet" href="/assets/style.css"/>
module Shortcut
    #This module is optional during execution but true by default
    class Shortcut
       class << self
        #This is the main shorcut generator it recieves the shortcut and returns markup      
        def get_short(val)#nodoc
	    if val == "d" then val = "div"
	    elsif val == "sp" then val = "span"
	    elsif val == "ad" then val = "audio"
	    elsif val == "vd" then val = "video"
	    elsif val == "bq" then val = "blockquote"
	    elsif val == "tt" then val = "title"
	    elsif val == "ht" then val = "html"
	    elsif val == "bd" then val = "body"
	    elsif val == "fm" then val = "form"
	    elsif val == "in" then val = "input"
	    elsif val == "txt" then val = "textarea"
	    elsif val == "can" then val = "canvas"
	    elsif val == "hd" then val = "head"
	    elsif val == "hdr" then val = "header"
	    elsif val == "ft" then val = "footer"
	    elsif val == "asd" then val = "aside"
	    elsif val == "tbl" then val = "table"
	    elsif val == "ifr" then val = "iframe"
	    elsif val == "add" then val = "address"
	    elsif val == "emb" then val = "embed"
	    elsif val == "btn" then val = "button"
	    elsif val == "lk" then val = "link"
	    elsif val == "mt" then val = "meta"
	    elsif val == "stl" then val = "style"
	    elsif val == "scp" then val = "script"
	    elsif val == "sec" then val = "section"
            elsif val == "mq" then val = "marquee"
	    elsif val == "utf8" then val = 'meta charset="UTF-8"/'
	    elsif val == "view1" then val ='meta name="viewport" content="width=device-width,initial-scale=1.0"/'
	    elsif val == "doc5" then val = "!DOCTYPE html"
		elsif val == "xml" then val='?xml version="1.0" encoding="UTF-8"?'
		elsif val == "cd" then val="code"		
	    elsif val[/--t/]  
	      id=val.index('-')+1;sz = val.size;t=val.index('t');val=val=" "*id+"<title>#{val[t+2..sz]}</title>\n"
	    elsif val[/--d/] 
	      id=val.index('-')+1;sz = val.size;t=val.index('d');val=val=" "*id+'<meta name="description" content="'+val[t+2..sz]+'"/>'+"\n"
	    elsif val[/--ch/] 
	      id=val.index('-')+1;sz = val.size;t=val.index('ch');val=val=" "*id+'<meta charset="'+val[t+3..sz]+'"/>'+"\n"
            elsif val[/--vp/] 
	      id=val.index('-')+1;sz = val.size;t=val.index('vp');val=val=" "*id+'<meta name="viewport" content="width=device-width, initial-scale='+val[t+3..sz]+'"/>'+"\n"
            elsif val[/--st/] 
	      id=val.index('-')+1;sz = val.size;t=val.index('st');val=val=" "*id+'<link rel="stylesheet" href="'+val[t+3..sz]+'"/>'+"\n"	      
	     elsif val[/--sp/] 
	      id=val.index('-')+1;sz = val.size;t=val.index('sp');val=val=" "*id+'<script src="'+val[t+3..sz]+'"></script>'+"\n"
              elsif val[/--k/] 
	      id=val.index('-')+1;sz = val.size;t=val.index('k');val=" "*id+'<meta name="keywords" content="'+val[t+2..sz]+'"/>'+"\n"
             elsif val[/--ic/] 
	      id=val.index('-')+1;sz = val.size;t=val.index('ic');val=val=" "*id+'<link rel="icon" href="'+val[t+3..sz]+'"/>'+"\n"
		   elsif val[/--s/]
			   t=val.index('s');sz = val.size;
			   st = val[t+1..sz];
			   sd = st.split(/=/);sd.each{|t| t.strip!}
			id=val.index('-')+1;val=val=" "*id+'<meta name="'+sd[0]+'" content="'+sd[1]+'"/>'+"\n"
	      end  
	    return val
	  end
       end
    end
end