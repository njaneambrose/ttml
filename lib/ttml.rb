require "ttml/version"
require "ttml/shortcut"
require "erb"
#= TTML(Taxi To Markup Language) 
#===file extension: (*.ttml)
#
#TTML is a lighweight language that complies to Markup, TTML helps produce markup in a faster, simpler and cleaner way, 
#basically you write the skeleton of  markup and it converts it into the actual markup that you had desired on the fly
#
#TTML supports erb templates so you can use it here but you have to enable erb during execution so that it can be processed
#check TTML::Route.new
#because erb is disabled by default
#
#TTML comes with some additional features that can be used  for Web projects like shortcuts and imports
#to make your work simpler and  projects move faster
#== Simple Syntax 
#The following example shows a simple syntax for TTML then the converted HTML(for this example below), 
#the => sign is not part of the syntax it is used to show you how it works 
#
#visit https://github.com/njaneambrose/ttml/blob/master/docs/documentation.html to see more  examples
#== HTML example
#Go through this simple code line by line to understand the concept easily
#    doc5  =><!DOCTYPE html>
#        ht{     =><html>
#           hd{  =><head>   
#              --t hello world      =><title>hello world</title> or you can use tt{hello world} or title{hello world}
#              --d a simple TTM example  =><meta name="description" content="a simple TTML example"/>
#              utf8   =><meta charset="UTF-8"/> or --ch UTF-8 produces the same result
#              view1  =><meta name="viewport" content="width=device-width,initial scale=1.0"/>" #or --vp 1.0 also produces the same result
 #             }  =></head>
#           bd{   =><body> or body{ choose what works for you
#               sp !lead!{Using class}     =><span class="lead">Using class</span> or you can write span class="lead"{Using class}
#               =>between the ! and ! you ccan declare some common attributes eg class,id,href and src
#               sp !#lead!{}     =><span id="lead"></span>
#               sp !@https://github.com!{}  =><span href="https://github.com"></span>
#               ifr !>one.mp3!    =><iframe src="one.mp3">
#               a !lead,gold,@google.com,#real!{}   =><a href="google.com" class="lead gold" id="real"></a>
#              p{
#               #this is a single line<br>     =>you can now insert html/erb/ejs code after the #sign
#               #<!--- a comment -->           =>using a comment
#               #<span class="insert"><?php echo "hello world"?></span>
#               }
#             ft{ =><footer>
#                 &footer  =>this imports the footer.ttml file into your file during execution 
#              }  =></footer>
#         } =></body>
#       scp{  =><script>
#          % =>this % indicates that you do not want this to be executed until the closing %
#           window.onload = function(){
#              alert("This is TTML")
#           } 
#          &assets/js/jquery.js =>this imports jquery file
#          %  =>import all non-TTML files or non-TTML code between the two sings or after a #(not imports but code for the Hash sign)
#        } =></script>
#      } =></html>
#=XHTML
#For xhtml do either of the following to ensure all tags are closed
#  ad !>one.mp3! controls/     => <audio src="one.mp3" controls/>
#  ad !>one.mp3! controls{}     => <audio src="one.mp3" controls></audio>
#The syntax is simple p{} this is a simple one line tag and text goes between the braces
#
#The other syntax is div{ and close this brace where you want this element to end }
module TTML
  ##
#= Usage
#The TTML module provides you with four ways of running your TTML code 
#the following is a quick review of the methods
#
#The general syntax is TTML::Route.new(input,output,erb=true/default{false},shortcut=default{true}/false)
#==1. The test method
#This method is provides some kind of REPL environment to play with TTML code check below:
 # require 'ttml' 
 # include TTML #load this module to avoid using TTML::
#  a =<<_ #this is a simple here document you want to pass into the interpreter
#   body{
#     div class="container"{
#       p{Hello i am just testing the waters}
#   }
#  }
#  _
 # T = Route.new(a)#we call the Route class with parameter a(our string with TTML code)
 # puts T.test #prints output
 # #everything you can do using an actual file you can do it here even imports
 #== 2. The prototype method
 #This method can be used to test the output of a file without writing the output to another file
 # require 'ttml' 
 # include TTML #load this module to avoid using TTML::
 # T = Route.new("test.ttml") #we call the Route class with parameter the file test.ttml
# puts T.prototype #prints output
#
#== 3. The pipe method
#This is like test method only that the output is written to a file
#  require 'ttml' 
#  include TTML #load this module to avoid using TTML::
#  a =<<_ #this is a simple here document you want to pass into the interpreter
#   body{
#       div class="container"{
#          p{Hello i am just testing the waters}
#    }
#  }
#  _
# T = Route.new(a,"test.html") #we call the Route class with parameter a(our String) and test.html where the output is written
# T.pipe #we call the method the file is created if not existing and overwritten if existing
#== 4. The start method
#This method is used to run a TTML file and  write the output to a file
#    require 'ttml'
#    include TTML #load this module to avoid using TTML::
#    T = Route.new("test.ttml","test.html") #we call the Route class with two parameters, the test.tml file and where to write output to
#    T.start #we call the method
#    #you may supply different files as your desired output eg: xml,xhtml,html,... files
#
#You can use Watcher to compile your files here check Watcher
#
#== 5. Using erb
#Just add true to your options
#   T = Route.new(a,String.new,true) #for test method
#   T = Route.new("test.ttml",String.new,true) #for prototype method
#   T = Route.new(a,"test.html",true) #for pipe method
#   T = Route.new("test.ttml","test.html",true) #for the start method
#
#==5. Disabling Shortcuts
#The TTML module also allows you to run your TTML code without shortcuts check the syntax below:
# #for the test method
# T = Route.new(a,String.new,false,false)
#  T.test
#  #for prototype method
# T = Route.new("test.ttml",String.new,false,false)
# T.prototype
# #for pipe method
# T = Route.new(a,"pipe.xml",false,false)
# T.pipe
# #for start method
# T = Route.new("data.ttml","data.xml",false,false)
# T.start
#
#==Copyright
#by Ambrose Njane(njaneambrose@gmail.com)
#--
class Route
#call the method with your parameters this depends whether you want shortcuts or not and also configure erb
	def initialize(infile,outfile=String.new,erb=false,shortcut=true)
	   @tag_array = Array.new 
	   @exec = true 
	   @infile = infile 
	   @outfile = outfile 
	   @array = Array.new 
	   @shortcut = shortcut
	   @erb = erb
	   @join = false
	end
#Used to process a file then write output to another file      
	def start
		if File::exists?("#{@infile}") 
		  if @infile[/.ttml$/] 
			   input = File.open("#{@infile}")
			   input.each{|ot| @array << ot if !ot.empty?}
			   output = File.open("#{@outfile}", "w")
			   @outfile = String.new
			   converter(@array, @outfile)
				if @erb
				  erb = ERB.new(@outfile)
				  @outfile.replace erb.result
				end  
				output << @outfile
				output.close
				@array.clear
			else
				raise StandardError, "Please enter a valid TTML file (*.ttml)"
		  end
		else
			raise StandardError, "Please check input parameter: ensure #{@infile} file exists" 
		end
	end
#Used to work with TTML without interacting with files
	def test
		@infile.split(/\n/).each{|e| @array << e}
		converter(@array, @outfile)
		if @erb
		  erb = ERB.new(@outfile)
		  @outfile.replace erb.result
		end  
		return @outfile
	end
#Used to write output from a string to a file     
 def pipe
		@infile.split(/\n/).each{|e| @array << e} 
		topipe = File.open("#{@outfile}", "w")
		@outfile = String.new
		converter(@array, @outfile)
		if @erb
			erb = ERB.new(@outfile)
			@outfile.replace erb.result
		end  
		topipe << @outfile
		topipe.close
		@array.clear    
 end
#Used to test output from files without writing to another file    
  def prototype
	   if File::exists?("#{@infile}") 
			if @infile[/.ttml$/]
			   input = File.open("#{@infile}")
			   input.each{|ot| @array << ot if !ot.empty?}
			   converter(@array, @outfile)
				if @erb
				  erb = ERB.new(@outfile)
				  @outfile.replace erb.result
				end  
			 input.close
			else
			   raise StandardError, "Please enter a valid TTML file (*.ttml)" #makes sure it is a TTML file
		   end
		else
		   raise StandardError, "Please check input parameter: ensure #{@infile} file exists" 
		end
	  return @outfile
	  @array.clear
 end
#This is the core of operation that handles all lines and dispatches them for processing
 def converter(a, b)
		a.each{|line| line.replace line.rstrip
		   if [/\t/] == "  " then line = line.gsub "\t", "  "
			 elsif [/\t/] == "    " then line = line.gsub "\t", "    "
			 else line = line.gsub "\t", "  " end
		   bf=String.new;line = line.to_s;bf<<line;bf.strip!;
		   if @exec
			   if !bf[/^%/] and !bf[/^#/] and !bf[/}/] and !bf[/{/] and !bf.empty? and !bf[/^&/] and !bf[/^--/] and !bf[/^<%/] and !bf[/^!/]
					out = machine1(line)
					b << out
			   elsif bf[/^--j/]
					if @join 
					   @join = false 
					else
					   @join = true
					end
			   elsif bf[/^<%/]
					b << line.strip         
			   elsif bf[/^#/]
					out = machine2(line)
					if @join then out.strip! end
					b << out
				elsif bf[/{/] and bf[/}/] and !bf[/^--/]
					out = machine3(line)
					if @join then out.strip! end
					b << out
				elsif bf[/^%/]
					out = machine4(line)
					@exec = false 
				elsif bf[/{$/] and !bf[/^--/]
					out = machine5(line)
					if @join then out.strip! end
					b << out
				elsif bf[/^}/]
					out = machine6(line)
					if @join then out.strip! end
					b << out
				elsif bf[/^&/]
					filemachine(line)
				elsif bf[/^--/] and !bf[/^--j/]
					out = promote(line)
					if @join then out.strip! end
					b << out
				end
		 else
				if bf[/^%/]
					@exec= true 
					line.clear
				elsif bf[/^&/]
					filemachine(line)
				elsif bf[/^<%/]
					b << line.strip
				elsif bf[/^--j/]
					if @join 
					   @join = false 
					else
					   @join = true
					end    
				else
				   x = line.size
				   line.insert x, "\n"
				   if @join then line.strip! end
				   b << line
				end
		  end
		}
 end
#Handles single lines that do not have text or children e.g: ad !real! controls  => <audio class="real" controls>   
	def machine1(line)
		fst=line[/[ ]*/].size;sz=line.size;ln=line[fst..sz]
		arr = ln.split(/ /)
		tag = arr[0]
		if line[/!(.*?)!/]
			at = line[/!(.*?)!/]
			att = attribute(at)
			line[at] = att
		end
		if @shortcut 
			tg = Shortcut::Shortcut.get_short(tag)
			size = line.size+1
			line.insert fst, "<"
			line.insert size,">\n"
			line[tag] = tg
		else
			size = line.size+1
			line.insert fst, "<"
			line.insert size,">\n"
		end
		if @join then line.strip! end
		return line     
	end
#Handles files that start with # e,g: #<span>hello</span> to <span>hello</span>     
	def machine2(line)
		fst=line[/[ ]*/].size
		line[fst]=""
		x = line.size
		line.insert x, "\n"
		return line     
	end
#Handles single line elements e.g: sp{hello} to <span>hello</span>    
	def machine3(line)
		fs=line[/[^\W]/];fst=line.index("#{fs}");sz=line.index('{');
		txt = line[fst..sz-1]
		all = txt.split(/ /)
		tg = all[0]
		line[sz]=">"
		line.insert fst, "<"
		if line[/!(.*?)!/]
		   at = line[/!(.*?)!/]
		   att = attribute(at)
		   line[at] = att
		end
		sz = line.size
		if @shortcut
		  tag =Shortcut::Shortcut.get_short(tg)
		  line[sz-1]="</#{tag}>\n"
		  line[tg] = tag
		else
		  line[sz-1]="</#{tg}>\n"
		end
		return line
	end
#Handles the lines that start with %  and stops execution until the next % at the beginning of a line    
	def machine4(line)
		line = line.gsub "%", ""
		return line
	end
#Handles multi-line elements e.g d !#container!{ to <div id="container">
	def machine5(line)
		fst=line[/[ ]*/].size;sz=line.size;ln=line[fst..sz]
		art = ln.split(/ /)
		tt = art[0].delete "{"
		if line[/!(.*?)!/]
		  at = line[/!(.*?)!/]
		  att = attribute(at)
		  line[at] = att
		end
		if @shortcut
			trt = Shortcut::Shortcut.get_short(tt)
			@tag_array << trt
			line.insert fst, '<'
			ind=line.index('{')
			line[ind] = ">\n"
			line[tt] = trt
		else
			@tag_array << tt
			ind=line.index('{')
			line.insert fst, '<'
			line[ind+1]=">\n"
	   end
	   return line
	end
#Working hand in hand with machine5 it can determine the closing tag e.g: } to </div>    
	def machine6(line)
		 a = @tag_array.pop
		 line["}"]="</#{a}>\n"
		 return line
	end
#This handles imports to during interpretation e.g: &go => it returns the file go.ttml   
	def filemachine(line)
		out_array = Array.new
		asd = String.new
		line.strip!
		line[0] = ''
		line.strip!
		if File.extname(line).empty? then line.replace line+".ttml" end
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
#This handles another genre of shortcuts that start with -- e.g --ch UTF-8 to <meta charset="UTF-8"/>   
	def promote(line)
		answer = Shortcut::Shortcut.get_short(line)
		if @join then answer.strip! end
		return answer
	end
#This function handles  attributes that lie between the ! and ! e.g:
#
#sp !real,#red,@rubylang.org,>ruby.rb!{} to <span class="real" id="red" href="rubylang.org" src="ruby.rb"></span> 
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
		 if full[-1] == " "
			full.chop!
		 end    
	  return full
	end
  end
end
