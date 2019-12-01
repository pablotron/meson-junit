#
# Read parsed Meson test log and build JUnit-compatible XML.
#
class MesonJunit::Junit::XMLBuilder
  def self.build(log)
    new.build(log)
  end

  #
  # Build JUnit-compatible XML from parsed Meson test log.
  #
  def build(log)
    ::Nokogiri::XML::Builder.new do |xml|
      xml.testsuites(**testsuites_el_attrs(log)) do
        emit_testsuite_els(xml, log)
      end
    end.to_xml
  end

  private

  #
  # Convert Meson test log to a series of JUnit test suites.
  #
  # We map Meson tests to a series of JUnit test suites with a single
  # test case because that allows us to map the per-test attributes and
  # environment variables to JUnit test suite properties.
  #
  def emit_testsuite_els(xml, log)
    log.tests.each_with_index do |test, test_num|
      xml.testsuite(**testsuite_el_attrs(test, test_num)) do
        # emit testsuite properties
        emit_properties(xml, test)

        # emit testcase
        emit_testcase(xml, test)

        # emit standard output and standard error
        xml.send('system-out', test.data['stdout'])
        xml.send('system-err', test.data['stderr'])
      end
    end
  end

  #
  # Emit Meson test attributes as JUnit `testsuite` properties.
  #
  def emit_properties(xml, test)
    xml.properties do
      # convert all non-environment variable meson test attributes to
      # junit test suite properties
      test.data.each do |key, val|
        unless key == 'env'
          emit_property(xml, key, val)
        end
      end

      # convert meson test environment variables to junit test suite
      # properties
      (test.data['env'] || {}).each do |key, val|
        emit_property(xml, 'env.%s' % [key], val)
      end
    end
  end

  #
  # Emit details of Meson test as a JUnit `testcase` element.
  def emit_testcase(xml, test)
    xml.testcase(**testcase_el_attrs(test)) do
      if test.failed?
        # emit a `failure` element with a body that contains the
        # standard error output from the Meson test.
        xml.failure(test.data['stderr'], message: 'Test failed.')
      end

      # emit standard io elements
      emit_stdio(xml, test)
    end
  end

  #
  # Emit standard output and standard error from a Meson test case as
  # JUnit-compatible `system-out` and `system-err` elements.
  #
  def emit_stdio(xml, test)
    # emit standard output and standard error
    xml.send('system-out', test.data['stdout'])
    xml.send('system-err', test.data['stderr'])
  end

  #
  # Emit a Meson test attribute as a JUnit test suite property.
  #
  def emit_property(xml, key, val)
    case val
    when Array, Hash
      # serialize arrays and hashes as JSON
      xml.property(name: key, value: ::JSON.unparse(val))
    else
      xml.property(name: key, value: val)
    end
  end

  #
  # Get hash of attributes for root JUnit `testsuites` element.
  #
  def testsuites_el_attrs(log)
    {
      # total number of tests
      tests: log.tests.size,

      # total number of failed tests
      failures: log.tests.reduce(0) do |r, test|
        r + (test.failed? ? 1 : 0)
      end,

      # total amount of time across all tests
      time: log.tests.reduce(0) do |r, test|
        r + test.duration
      end,
    }
  end

  #
  # Get hash of attributes for JUnit `testsuite` element.
  #
  def testsuite_el_attrs(test, test_num)
    {
      # test number, starting from zero
      id: test_num,

      # junit-friendly class name
      name: safe_name(test.name),

      # total number of tests (always 1)
      tests: 1,

      # total number of errors (always either 0 or 1)
      errors: test.failed? ? 1 : 0,

      # total amount of time for this test
      time: test.duration,
    }
  end

  #
  # Get hash of attributes for JUnit `testcase` element.
  #
  def testcase_el_attrs(test)
    {
      # test case name
      name: 'main',

      # test case class name
      classname: safe_name(test.name),

      # time taken (in seconds) to execute test.
      time: test.duration,
    }
  end

  #
  # Invalid characters in JUnit class name.
  #
  BAD_CHARS = /[^a-z0-9_]+/

  #
  # Sanitize a Meson test name as a JUnit-friendly class name.
  #
  def safe_name(s)
    s.gsub(BAD_CHARS, '_')
  end
end
