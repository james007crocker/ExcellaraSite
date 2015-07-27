require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork


every( 10.seconds, 'Initiating the MATCH', :at => '23:00'){
  puts "Hello World July 27th"
}