#VERSION => BREAKTIME V 1.0.0
#AUTHOR  => AMBROSE NJANE
#COMMENT =>  A Markup generation engine
#DATE => 8-7-2018 <-> 13-7-2018
#DESCRIPTION => BreakTime is a lightweight ruby engine for producing MARKUP(XML,XHTML,HTML,....) on the fly
#RUBY_VERSION => 2.4.4
require "./shortcut"

module BreakTime
   class Doc
     def initialize(infile,outfile=String.new,shortcut=true)
      @tag_array = Array.new #important as it holds the closing tags
      @exec = true #execution is true for interpretation of lines
      @infile = infile #the BreakTime file to convert
       @outfile = outfile #The final output to be produced
       @array = Array.new #This is key for execution of the data
       @shortcut = shortcut#determines whether shorcuts are used or not
      end
      def start
        if File::exists?("#{@infile}") 
	  if @infile[/.ttml$/]
	   input = File.open("#{@infile}")
	   input.each{|ot| @array << ot if !ot.empty?}
	   output = File.open("#{@outfile}", "w")
	   @outfile = String.new
	   converter(@array, @outfile)
	   output << @outfile
	   output.close
	   @array.clear
	else
	  raise StandardError, "Please enter a valid Taxi file (*.tax)" #makes sure it is a Taxi file
	  end
	else
	 raise StandardError, "Please check input parameter: ensure #{@infile} file exists" 
	end
      end
      def test
         @infile.split(/\n/).each{|e| @array << e}
        converter(@array, @outfile)
	return @outfile
	@array.clear
      end
      def pipe
	@infile.split(/\n/).each{|e| @array << e} 
	topipe = File.open("#{@outfile}", "w")
	@outfile = String.new
	converter(@array, @outfile)
	topipe << @outfile
        topipe.close
	@array.clear
	end
	def prototype
	  if File::exists?("#{@infile}") 
	  if @infile[/.ttml$/]
	   input = File.open("#{@infile}")
	   input.each{|ot| @array << ot if !ot.empty?}
	   converter(@array, @outfile)
	   input.close
	else
	  raise StandardError, "Please enter a valid Taxi file (*.tax)" #makes sure it is a Taxi file
	  end
	else
	 raise StandardError, "Please check input parameter: ensure #{@infile} file exists" 
	end
	return @outfile
	 @array.clear
	end
      def converter(a, b)
	a.each{|line|
	 line.strip!
	  line = line.to_s
	  #when the execution of lines is working
	 if @exec == true
	 #this targets all lines
	   if !line[/^%/] and !line[/^#/] and !line[/}/] and !line[/{/] and !line.empty? and !line[/^&/] and !line[/^--/] and !line[/^<%/]
            out = machine1(line)
	    b << out
	    #targets all lines starting with # eg: #<!--comment-->
	  elsif line[/^#/]
              out = machine2(line)
	      b << out
	 #targets all p{hello} and span{hello}
	  elsif line[/{/] and line[/}/]
           out = machine3(line)
	   b << out
	   #targets % the begining of a multiline statment
	 elsif line[/^%/]
	   out = machine4(line)
           @exec = false #turns execution off
         elsif line[/{$/]#targets lines that span more than single line eg div{/n}
	 out = machine5(line)
	 b << out
	 elsif line[/^}/]#marks the last line for a multiline tag
	 out = machine6(line)
	 b << out
	  elsif line[/^&/]#The begining of targets to other files eg &one.xml
	 filemachine(line)
	  elsif line[/^--/]
             out = promote(line)
              b << out
	  end
	 else
	   if line[/^%/]#marks end of multilne statments
	  @exec= true #turns on execution again
	  line.clear
	  elsif line[/^&/]#The  targets to other files
	     filemachine(line)
          else
          x = line.size
          line.insert x, "\n"
         b << line
      end
      end
	}
     end
     # machine 1
     # conversion eg: image src="one.png" => <img src="one.png">  
    #just puts those < and >     
     def machine1(line)
      line.strip!
      arr = line.split(/ /)
      tag = arr[0]
      if line[/!(.*?)!/]
      at = line[/!(.*?)!/]
      att = attribute(at)
      line[at] = att
      end
      if @shortcut == true 
      tg = Shortcut::Shortcut.get_short(tag)
      size = line.size+1
      line.insert 0, "<"
      line.insert size,">\n"
      line[tag] = tg
      else
      size = line.size+1
      line.insert 0, "<"
      line.insert size,">\n"
      end
     return line     
     end
     #machine 2
     # conversion #<!--Commnet--> => <!--Comment-->
     #Just removes the (#) part of ignoring the line
     def machine2(line)
      line.strip!
      line[0] = ''
      x = line.size
      line.insert x, "\n"
     return line     
     end
     #machine3
     #targerts p{hello world} => <p>hello world</p>
     # span class="lead"{BreakTime} => <span class="lead">BreakTime</span>
     def machine3(line)
       line.strip!
       one = line.index("{")
        txt = line[0..one-1]
	all = txt.split(/ /)
        tg = all[0]
	line[one] = ">"
        line.insert 0, "<"
	 if line[/!(.*?)!/]
      at = line[/!(.*?)!/]
      att = attribute(at)
      line[at] = att
      end
	if(@shortcut == true)
	tag =Shortcut::Shortcut.get_short(tg)
        len = line.size-1
        line[len] = ''
       line.insert len, "</#{tag}>\n"
       line[tg] = tag
       else
	len = line.size-1
        line[len] = ''
        line.insert len, "</#{tg}>\n"
       end
       return line
     end
     #machine4
     #Just ignores the line and begins the multiline staments eg PHP code
     # --Example
     # % --> start
     #<?php
     #echo "hello world"
     #php?>
     #%--> end
     def machine4(line)
      line.strip!
      line[0] = ''
     return line
     end
     #machine 5 works with machine 6 to open and close multiline tags 
     # div{
      #   div class="home"{
      #  }
      #}
      # OUTPUT
      #<div>
      # <div class="home">
     #</div>
     #</div>
     def machine5(line)
        line.strip!
	art = line.split(/ /)
	rt = line
	tt = art[0].delete "{"
	 if line[/!(.*?)!/]
      at = line[/!(.*?)!/]
      att = attribute(at)
      line[at] = att
      end
	if @shortcut == true 
	trt = Shortcut::Shortcut.get_short(tt)
	@tag_array << trt
	line.insert 0, '<'
	d = line.size-1
	line[d] = ">\n"
	line[tt] = trt
	else
	@tag_array << tt
	line.insert 0, '<'
	d = line.size-1
	line[d] = ">\n"
	end
     return line
     end
     def machine6(line)
        line.strip!
	 a = @tag_array.pop #returns the last value in the array
	line.replace "</#{a}>\n"
	return line
     end
     #filemachine is used for loading all file dependencies into the main file
     #for example &one.xml => this loads this file into the current file
     def filemachine(line)
      out_array = Array.new
      asd = String.new
      line.strip!
       line[0] = ''
       line.strip!
        if File::exists?("#{line}") 
	   input = File.open("#{line}")
	   input.each{|ot| out_array << ot if !ot.empty?}
	   converter(out_array,@outfile)
	   input.close
	else
	 raise StandardError, "Please ensure #{line} file exists" 
	end
        out_array.clear
     end
     def promote(line)
        answer = Shortcut::Shortcut.get_short(line)
	return answer
     end
     def attribute(line)
     line = line.gsub "!", ''
     d = line.split(/,/)
     a = 'id=""';b = 'class=""';href ='href=""';src='src=""';id = String.new;c = String.new;hf=String.new;sc=String.new
     d.each{|e|
      if e[/^#/]
      e[0]='';e.strip!
      id = id + "#{e} "
      elsif e[/^@/]
      e[0]='';e.strip!
      hf = hf+ "#{e} "
      elsif e[/^>/]
      e[0]='';e.strip!
      sc = sc+ "#{e} "
     else
     c = c + "#{e} "
    end
     }
     full = String.new
     id.chop!;c.chop!;hf.chop!;sc.chop!
     if id.empty?
     a.clear
     else
    a.insert 4, id
    full << a+" ";id.clear
     end 
     if c.empty?
     b.clear
     else
     b.insert 7, c
     full << b+" ";c.clear
    end
    if hf.empty?
      href.clear
    else
      href.insert 6,hf
      full << href+" ";hf.clear 
    end
    if sc.empty?
      src.clear
    else
      src.insert 5, sc
      full << src+" ";sc.clear
     end
     if (full[-1] == " ")
        full.chop!
     end	
   return full
     end
    end
end