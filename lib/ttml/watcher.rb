#= Watcher
#This is a simple file watcher that automatically complies your TTML code when the file chages
#
#Just pass your normal parameters and it will automatically compile your files to the desired output,
#This requires the ttml gem to be already installed in your computer

require 'ttml'
include TTML

class Watcher
  def initilaize(infile,erb=false,outfile,shortcut=true)
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
			File.open("#{@infile}",{|e| before << e.read})
			if !(before.eql? after)
			  x = Route.new(@infile,@erb,@outfile,@shortcut)
				x.start
			end
			after.replace before
      sleep(t)
		end
	end
end