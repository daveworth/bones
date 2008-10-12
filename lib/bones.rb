
module Bones

  # :stopdoc:
  VERSION = '2.1.0'
  PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  WIN32 = %r/win32/ =~ RUBY_PLATFORM
  DEV_NULL = WIN32 ? 'NUL:' : '/dev/null'
  # :startdoc:

  # Returns the path for Mr Bones. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : File.join(PATH, args.flatten)
  end

  # call-seq:
  #    Bones.require_all_libs_relative_to( filename, directory = nil )
  #
  # Utility method used to rquire all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= File.basename(fname, '.*')
    search_me = File.expand_path(
        File.join(File.dirname(fname), dir, '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

  #
  #
  def self.setup
    local_setup = File.join(Dir.pwd, %w[tasks setup.rb])

    if test(?e, local_setup)
      load local_setup
      return
    end

    bones_setup = ::Bones.path %w[lib bones tasks setup.rb]
    load bones_setup

    rakefiles = Dir.glob(File.join(Dir.pwd, %w[tasks *.rake])).sort
    import(*rakefiles)
  end

  # TODO: fix file lists for Test::Unit and RSpec
  #       these guys are just grabbing whatever is there and not pulling
  #       the filenames from the manifest

end  # module Bones


Bones.require_all_libs_relative_to __FILE__

# EOF
