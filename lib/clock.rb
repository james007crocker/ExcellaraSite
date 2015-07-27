require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

handler do |job|
  puts "Running #{job}"
end

every( 10.seconds, 'Initiating the MATCH'){
  puts "Hello World July 27th"
}
every(1.hour, 'hourly.job')