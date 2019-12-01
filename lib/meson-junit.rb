require 'json'
require 'nokogiri'

#
# Meson to JUnit test case generator.
#
module MesonJunit
  VERSION = '0.1.0'

  autoload :Meson, File.join(__dir__, 'meson-junit', 'meson.rb')
  autoload :Junit, File.join(__dir__, 'meson-junit', 'junit.rb')
  autoload :CLI, File.join(__dir__, 'meson-junit', 'cli.rb')
end
