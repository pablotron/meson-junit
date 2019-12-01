#
# Meson parsing namespace.
#
module MesonJunit::Meson
  autoload :Test, File.join(__dir__, 'meson', 'test.rb')
  autoload :TestLog, File.join(__dir__, 'meson', 'test-log.rb')
end
