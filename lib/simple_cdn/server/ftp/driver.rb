require 'fileutils'

module SimpleCDN
  class Server::Ftp::Driver

    # Your driver's initialize method can be anything you need.  Ftpd
    # does not create an instance of your driver.
    def initialize(base_dir)
      @base_dir   = base_dir
      @access_dir = '/dev/null'
    end

    # Return true if the user should be allowed to log in.
    # @param user [String]
    # @param password [String]
    # @param account [String]
    # @return [Boolean]
    #
    # Depending upon the server's auth_level, some of these parameters
    # may be nil.  A parameter with a nil value is not required for
    # authentication.  Here are the parameters that are non-nil for
    # each auth_level:
    # * :user (user)
    # * :password (user, password)
    # * :account (user, password, account)
    def authenticate(user, password, account)
      @access = Access.find_by_identifier(user)

      if @access.password == password
        @access_dir = "#{@base_dir}/#{@access.identifier}/"
        return true
      end

      return false
    end

    # Return the file system to use for a user.
    # @param user [String]
    # @return A file system driver that quacks like {Ftpd::DiskFileSystem}
    def file_system(user)
      unless File.directory?(@access_dir)
        init_access
      end

      Ftpd::DiskFileSystem.new(@access_dir)
    end

  private

    def init_access
      FileUtils.mkdir_p(@access_dir)

      create_files
    end

    def create_file path, contents
      full_path = File.expand_path(path, @access_dir)
      FileUtils.mkdir_p File.dirname(full_path)
      File.open(full_path, 'w') do |file|
        file.write contents
      end
    end

    def create_files
      create_file 'README',
      "This file, and the directory it is in, will go away\n"
      "When this example exits.\n"
    end
  end
end
