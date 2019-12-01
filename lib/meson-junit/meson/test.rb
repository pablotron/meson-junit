#
# Single Meson test result.
#
class MesonJunit::Meson::Test
  #
  # Parsed JSON data.
  #
  attr :data

  #
  # Test name.
  #
  attr :name

  #
  # Duration of test run, in seconds.
  #
  attr :duration

  #
  # Test result (either :OK or :FAIL).
  #
  attr :result

  #
  # Create a test case from parsed Meson JSON data.
  #
  def initialize(data)
    @data = data.freeze
    @name = @data['name']
    @duration = @data['duration'] || 0
    @result = @data['result'].intern
  end

  #
  # Did this test succeed?
  #
  def ok?
    @result == :OK
  end

  #
  # Did this test fail?
  #
  def failed?
    @result == :FAIL
  end
end
