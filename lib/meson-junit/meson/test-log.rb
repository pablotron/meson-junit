#
# Single Meson test result.
#
class MesonJunit::Meson::TestLog
  #
  # Individual Meson test results.
  #
  attr :tests

  #
  # Parse a testlog.json file.
  #
  def initialize(io)
    @tests = io.readlines.map do |line| 
      ::MesonJunit::Meson::Test.new(::JSON.parse(line)) 
    end
  end
end
