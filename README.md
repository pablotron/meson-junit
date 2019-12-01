meson-junit
===========

Overview
--------
Command-line tool to convert [Meson][] test results to a
[Jenkins][]-compatible [JUnit][] [XML][].

Usage:

    #
    # This command does the following:
    #
    #   - Read Meson test results in JSON format from the file
    #     "meson-logs/testlog.json".
    #
    #   - Convert the input from JSON to Jenkins-friendly, JUnit XML.
    #
    #   - Write the generated XML to "junit.xml".
    #
    meson-junit < meson-logs/testlog.json > junit.xml

If you are running your [Meson][] tests via [Jenkins Pipeline][], you
would include `meson-junit` in your `steps` like this:

    steps {
      // run tests, generate output in build-dir/meson-logs/testlog.json
      sh 'cd build && meson test || true'

      // generate build/testlog.xml
      sh 'cd build && meson-junit < meson-logs/testlog.json > testlog.xml'

      // read junit results
      junit 'build/testlog.xml'
    }

Notes:

  * [Meson][] test results are converted to [JUnit][] `<testsuite>`
    elements, rather than `<testcase>` elements.  This is so we can expose
    the attributes of the [Meson][] test results (the test command,
    return code, environment variables, etc) as `<property>` elements.
  * The reference used to generate the [JUnit][] [XML][] is available here:
    [JUnit XML reporting file format][junit-ref].

Installation
------------
Install `meson-junit` via [RubyGems][], like so:

    # install meson-junit using rubygems
    gem install meson-junit

Documentation
-------------
You can generate the API documentation in the `docs/` directory via
[RDoc][], like so:

    # generate API documentation in docs/ directory
    rake docs

Tests
-----
You can run the [minitest][] test suite via [Rake][], like so:

    # run the test suite
    rake test

To generate a [JUnit][]-compatible XML report, install the
[minitest-junit][] gem and then do the following:

    # run the test suite and generate a junit-compatible report.xml
    rake test TESTOPTS=--junit

Author
------
Paul Duncan ([pabs@pablotron.org][me])<br/>
<https://pablotron.org/>

License
-------
Copyright 2019 Paul Duncan ([pabs@pablotron.org][me])

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[junit-ref]: https://llg.cubic.org/docs/junit/
[xml]: https://en.wikipedia.org/wiki/XML
[meson]: https://mesonbuild.com/
[jenkins]: https://jenkins-ci.org/
[jenkins pipeline]: https://jenkins.io/doc/book/pipeline/
[RubyGems]: https://rubygems.org/
[JUnit]: https://junit.org/
[me]: mailto:pabs@pablotron.org
[minitest]: https://github.com/seattlerb/minitest
[minitest-junit]: https://github.com/aespinosa/minitest-junit
[RDoc]: https://github.com/ruby/rdoc
[Rake]: https://github.com/ruby/rake
