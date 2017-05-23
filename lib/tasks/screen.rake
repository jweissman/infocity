require_relative '../infocity/client'

require_relative '../swearing/ui'
require_relative '../infocity/screen'

task :screen => :environment do
  screen = Infocity::Screen.new
  screen.launch!
end
