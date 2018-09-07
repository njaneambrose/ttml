# TTML
TTML is a lightweight language that compiles to almost any form of markup from XML,HTML and many more just name them.

The ttml gem allows you to just write the skeleton of Markup then converts it to actual markup on the fly eg:

    --HTML--
    
     span{Hello World!} => <span>Hello World!</span>
     d !container!{}    => <div class="container"></div>
     a !@https://github.com!{Github page} => <a href="https://github.com">Github page</a>
    
     
     scp{ => <script>
     %
       //your javascript code goes here
     %
     }  </script> 
     
     stl{ => <style>
     %
       //your css goes here
     %
     } => </style>
     
     --k music,billboard,hot100   => <meta name="keywords" content="music,billboard,hot100"/>
     --d a music webpage          => <meta name="description" content="a music webpage"/>
     --sp assets/application.js   => <script src="assets/application.js"></script>
     --st assets/application.css  => <link rel="stylesheet" href="assets/application.css/>
     --s author = njaneambrose    => <meta name="author" content="njaneamrose"/>
     --p x = y                    => <meta property="x" content="y"/>
     
     doc5  => <!DOCTYPE html>
     xml   => <?xml version="1.0" encoding="UTF-8"/>
     utf8  => <meta charset="UTF-8"/>
     view1 => <meta name="viewport" content="width=device-width,initial-scale=1.0"?/>
     
     --XML--
     
        data{                 => <data>
           sub name="y"{}     =>   <sub name="y"></sub>
           sub name="x"{}     =>   <sub name="x"></sub>
        }                     => </data>
   
You see it can never get easier and this is just a tip of the iceberg

TTML can be used for any project whether to generate XML files or even Webpages.

[Check more examples here](https://github.com/njaneambrose/ttml/blob/master/docs/Documentation.html)

You can also clone this repo, go to the /docs file you will see the file ServerBT.rb run this file with your ruby interpreter(it only works if you have already installed the ttml gem), 
go to your browser and type http://localhost:1776/trynow this will open a simple IDE where you can try some ttml or erb code.

You can check documentation at http://localhost:1776/documentation and usage at http://localhost:1776/use
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ttml'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ttml

## Usage

The gem gives you diffrent modes of using including some form of REPL,

[Click here to see more details](https://github.com/njaneambrose/ttml/blob/master/docs/use.html)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/njaneambrose/ttml.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
