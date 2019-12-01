require_relative './lib/meson-junit'

Gem::Specification.new do |s|
  s.name        = 'meson-junit'
  s.version     = MesonJunit::VERSION
  s.date        = '2019-12-01'
  s.summary     = 'Convert Meson testlog JSON to JUnit XML.'
  s.description = '
    Command-line tool and library to convert Meson testlog JSOn files to
    Jenkins-compatible JUnit XML files.
  '

  s.authors     = ['Paul Duncan']
  s.email       = 'pabs@pablotron.org'
  s.homepage    = 'https://github.com/pablotron/meson-junit'
  s.license     = 'MIT'

  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/pablotron/meson-junit/issues',
    "documentation_uri" => 'https://pablotron.github.io/meson-junit/',
    "homepage_uri"      => 'https://github.com/pablotron/meson-junit',
    "source_code_uri"   => 'https://github.com/pablotron/meson-junit',
    "wiki_uri"          => 'https://github.com/pablotron/meson-junit/wiki',
  }

  s.bindir      = 'bin'
  s.executables = 'meson-junit'

  s.files       = Dir['{bin,lib,test}/**/*'] + %w{README.md Rakefile}

  s.add_dependency 'nokogiri'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-junit'
end
