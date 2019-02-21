require 'ttml'
include TTML

class Watcher
#=Watcher
#This is a simple file watcher that automatically complies your TTML code when the file changes
#
#Use watcher to automatically converts use this Watcher works with files only not the other methods
#
#This requires the ttml gem to be already installed in your computer
#  
#==Usage
#  require 'ttml/watcher'
#  x = Watcher.new("test.ttml","test.html",false,false) #Watcher.new(input,output,erb=true/false,shortcut=true/false)
#  x.start(8) #after what duration to compile again  {default = 5} seconds  

  def initialize(infile,outfile,erb=false,shortcut=true)
	  @infile = infile
		@outfile = outfile
		@erb = erb
		@shortcut = shortcut
	end
	def start(t = 5)
	  before = ""
		after = ""
	  loop do
		  before.replace ""
			File.open("#{@infile}"){|e| before << e.read}
			if !(before.eql? after)
			  x = Route.new(@infile,@outfile,@erb,@shortcut)
				x.start
				puts "#{Time.now} : compiled #{@infile} to #{@outfile}"
			end
			after.replace before
      sleep(t)
		end
	end
end