module SimpleCDN
  class Server::Ftp

    include Ftpd::InsecureCertificate

    def self.run
      self.new.run
    end

    def initialize
      @settings = SimpleCDN::Settings.server.ftp

      @data_dir = "#{Rails.root}/data/cdn_repositories"

      @driver = SimpleCDN::Server::Ftp::Driver.new(@data_dir)
      @server = Ftpd::FtpServer.new(@driver)

      @server.interface     = @settings.interface
      @server.port          = @settings.port
      @server.tls           = @settings.tls
      @server.certfile_path = insecure_certfile_path

      @server.list_formatter = Ftpd::ListFormat::Eplf if @settings.eplf

      @server.auth_level      = auth_level
      @server.session_timeout = @settings.session_timeout
      @server.log             = make_log

      @server.server_name    = "SimpleCDNServer"
      @server.server_version = SimpleCDN::VERSION
      @server.start

      save_pid
      display_connection_info
    end

    def run
      wait_until_stopped
    end

  private

    HOST = 'localhost'

    def auth_level
      Ftpd.const_get("AUTH_PASSWORD")
    end

    def save_pid
      # TODO
    end

    def display_connection_info
      puts "Interface: #{@server.interface}"
      puts "Port: #{@server.bound_port}"
      puts "TLS: #{@settings.tls}"
      puts "Base directory: #{@data_dir}"
      puts "URI: ftp://#{HOST}:#{@server.bound_port}"
      puts "PID: #{pid}"
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

    def pid
      "#{$$}"
    end

    def make_log
      @settings.debug && Logger.new($stdout)
    end

  end
end
