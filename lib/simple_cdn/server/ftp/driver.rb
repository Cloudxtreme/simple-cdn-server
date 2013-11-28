module SimpleCDN
  class Server::Ftp::Driver

    # Your driver's initialize method can be anything you need.  Ftpd
    # does not create an instance of your driver.
    def initialize(data_dir)
      @data_dir  = data_dir
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

      return @access.password == password
    end

    # Return the file system to use for a user.
    # @param user [String]
    # @return A file system driver that quacks like {Ftpd::DiskFileSystem}
    def file_system(user)
      Ftpd::DiskFileSystem.new("#{@data_dir}/#{@access.identifier}")
    end

  end
end
