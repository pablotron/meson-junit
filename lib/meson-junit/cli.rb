# 
# Command-line interface.
# 
module MesonJunit::CLI
  #
  # Allow command-line invocation.
  #
  def self.run(app, args)
    # TODO: parse command-line arguments

    # parse meson test log json from standard input
    log = MesonJunit::Meson::TestLog.new(STDIN)

    # build junit xml from meson testlog
    xml = MesonJunit::Junit::XMLBuilder.build(log)

    # write xml to standard output
    puts xml
  end
end
