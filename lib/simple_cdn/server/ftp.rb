require 'fileutils'

module SimpleCDN
  class Server::Ftp

    include Ftpd::InsecureCertificate

    PID_FILENAME = Rails.root.join('tmp', 'pids', 'ftpd.pid').to_s

    def self.run
      self.new.run
    end

    def self.is_running
      return false unless File.file?(PID_FILENAME)

      pid = File.open(PID_FILENAME) {|f| f.readline}.to_i
      begin
        Process.kill(0, pid)
        return true
      # rescue Errno::EPERM                     # changed uid
      #   puts "No permission to query #{pid}!";
      # rescue Errno::ESRCH
      #   puts "#{pid} is NOT running.";      # or zombied
      rescue
        # puts "Unable to determine status for #{pid} : #{$!}"
        return false
      end
    end

    def initialize
      @settings = SimpleCDN::Settings.server.ftp

      @data_dir = Rails.root.join('data', 'cdn_repositories')

      FileUtils.mkdir_p(Rails.root.join('tmp', 'pids'))

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
      File.open(PID_FILENAME, 'w+') {|f| f.write(pid) }
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
        File.delete(PID_FILENAME)
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
