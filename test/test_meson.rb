require 'minitest/autorun'
require 'json'
require 'meson-junit'

class MesonTest < MiniTest::Test
  # sample JSON
  MOCK_JSON = '{
    "name": "test-something",
    "stdout": "",
    "result": "OK",
    "duration": 0.017489910125732422,
    "returncode": 0,
    "command": [
      "/path/to/tests/test-something"
    ], 
    "env": {
      "FOO": "some foo data",
      "BAR": "some bar data",
      "BAZ": "some baz data"
    }
  }'.freeze

  def test_meson_test_new
    data = ::JSON.parse(MOCK_JSON)
    t = ::MesonJunit::Meson::Test.new(data)
    assert_instance_of ::MesonJunit::Meson::Test, t
  end

  # path to sample testlog.json
  TESTLOG_PATH = File.join(__dir__, 'data', 'testlog.json').freeze

  # expected sums
  EXPECTED_SUMS = {
    all: 5,
    OK: 2,
    FAIL: 3,
  }

  def test_meson_testlog_new
    # parse sample testlog.json
    log = File.open(TESTLOG_PATH) do |fh|
      ::MesonJunit::Meson::TestLog.new(fh)
    end

    # verify that it parsed as a test log
    assert_instance_of ::MesonJunit::Meson::TestLog, log

    sums = log.tests.reduce(Hash.new { |h, k| h[k] = 0 }) do |r, test|
      r[:all] += 1
      r[test.result] += 1
      r
    end

    # verify test counts
    EXPECTED_SUMS.each do |key, sum|
      assert_equal sum, sums[key]
    end
  end
end
