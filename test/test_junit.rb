require 'minitest/autorun'
require 'meson-junit'

class JunitTest < MiniTest::Test
  def test_junit_xmlbuilder_new
    builder = ::MesonJunit::Junit::XMLBuilder.new
    assert_instance_of ::MesonJunit::Junit::XMLBuilder, builder
  end

  TESTLOG_PATH = File.join(__dir__, 'data', 'testlog.json')

  def test_junit_xmlbuilder_build
    # parse sample testlog.json
    log = File.open(TESTLOG_PATH) do |fh|
      # parse input file as a Meson::TestLog
      ::MesonJunit::Meson::TestLog.new(fh)
    end

    # build junit xml
    xml = ::MesonJunit::Junit::XMLBuilder.build(log)

    assert_instance_of String, xml
  end
end
