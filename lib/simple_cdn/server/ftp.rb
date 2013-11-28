module SimpleCDN
  class Server::Ftp

    include Ftpd::InsecureCertificate

    def self.run
      self.new.run
    end

    def initialize
      # @args = Arguments.new(argv)
      @settings = SimpleCDN::Settings.server.ftp
      @args = @settings
      # @data_dir = Ftpd::TempDir.make
      @data_dir = "#{Rails.root}/data/cdn_repositories"
      # create_files
      @driver = SimpleCDN::Server::Ftp::Driver.new(@data_dir)
      @server = Ftpd::FtpServer.new(@driver)
      @server.interface = @args.interface
      @server.port      = @args.port
      @server.tls       = @args.tls
      @server.certfile_path = insecure_certfile_path
      if @args.eplf
        @server.list_formatter = Ftpd::ListFormat::Eplf
      end
      @server.auth_level      = auth_level
      @server.session_timeout = @args.session_timeout
      @server.log             = make_log
      @server.server_name     = "SimpleCDNServer"
      @server.server_version  = SimpleCDN::VERSION
      @server.start

      display_connection_info
      # create_connection_script
    end

    def run
      wait_until_stopped
    end

  private

    HOST = 'localhost'

    def auth_level
      Ftpd.const_get("AUTH_#{@args.auth_level.upcase}")
    end

    def create_files
      create_file 'README',
      "This file, and the directory it is in, will go away\n"
      "When this example exits.\n"
    end

    # def create_file(path, contents)
    #   full_path = File.expand_path(path, @data_dir)
    #   FileUtils.mkdir_p File.dirname(full_path)
    #   File.open(full_path, 'w') do |file|
    #     file.write contents
    #   end
    # end

    def display_connection_info
      puts "Interface: #{@server.interface}"
      puts "Port: #{@server.bound_port}"
      puts "User: #{user.inspect}"
      puts "Pass: #{password.inspect}" if auth_level >= Ftpd::AUTH_PASSWORD
      puts "Account: #{account.inspect}" if auth_level >= Ftpd::AUTH_ACCOUNT
      puts "TLS: #{@args.tls}"
      puts "Directory: #{@data_dir}"
      puts "URI: ftp://#{HOST}:#{@server.bound_port}"
      puts "PID: #{$$}"
    end

    def create_connection_script
      command_path = '/tmp/connect-to-example-ftp-server.sh'
      File.open(command_path, 'w') do |file|
        file.puts "#!/bin/bash"
        file.puts "ftp $FTP_ARGS #{HOST} #{@server.bound_port}"
      end
      system("chmod +x #{command_path}")
      puts "Connection script written to #{command_path}"
    end

    def wait_until_stopped
      puts "FTP server started.  Press ENTER or c-C to stop it"
      $stdout.flush
      begin
        gets
      rescue Interrupt
        puts "Interrupt"
      end
    end

    def user
      @args.user
    end

    def password
      @args.password
    end

    def account
      @args.account
    end

    def make_log
      @args.debug && Logger.new($stdout)
    end

  end
end

# module Example

#   # Command-line option parser

#   class Arguments

#     attr_reader :account
#     attr_reader :auth_level
#     attr_reader :debug
#     attr_reader :eplf
#     attr_reader :interface
#     attr_reader :password
#     attr_reader :port
#     attr_reader :read_only
#     attr_reader :session_timeout
#     attr_reader :tls
#     attr_reader :user

#     def initialize(argv)
#       @interface = 'localhost'
#       @tls = :explicit
#       @port = 0
#       @auth_level = 'password'
#       @user = ENV['LOGNAME']
#       @password = ''
#       @account = ''
#       @session_timeout = default_session_timeout
#       @log = nil
#       op = option_parser
#       op.parse!(argv)
#     rescue OptionParser::ParseError => e
#       $stderr.puts e
#       exit(1)
#     end

#     private

#     def option_parser
#       op = OptionParser.new do |op|
#         op.on('-p', '--port N', Integer, 'Bind to a specific port') do |t|
#           @port = t
#         end
#         op.on('-i', '--interface IP', 'Bind to a specific interface') do |t|
#           @interface = t
#         end
#         op.on('--tls [TYPE]', [:off, :explicit, :implicit],
#               'Select TLS support (off, explicit, implicit)',
#               'default = off') do |t|
#           @tls = t
#         end
#         op.on('--eplf', 'LIST uses EPLF format') do |t|
#           @eplf = t
#         end
#         op.on('--read-only', 'Prohibit put, delete, rmdir, etc.') do |t|
#           @read_only = t
#         end
#         op.on('--auth [LEVEL]', [:user, :password, :account],
#               'Set authorization level (user, password, account)',
#               'default = password') do |t|
#           @auth_level = t
#         end
#         op.on('-U', '--user NAME', 'User for authentication',
#               'defaults to current user') do |t|
#           @user = t
#         end
#         op.on('-P', '--password PW', 'Password for authentication',
#               'defaults to empty string') do |t|
#           @password = t
#         end
#         op.on('-A', '--account PW', 'Account for authentication',
#               'defaults to empty string') do |t|
#           @account = t
#         end
#         op.on('--timeout SEC', Integer, 'Session idle timeout',
#               "defaults to #{default_session_timeout}") do |t|
#           @session_timeout = t
#         end
#         op.on('-d', '--debug', 'Write server debug log to stdout') do |t|
#           @debug = t
#         end
#       end
#     end

#     def default_session_timeout
#       Ftpd::FtpServer::DEFAULT_SESSION_TIMEOUT
#     end

#   end
# end
