module SimpleCDN
  class Configurator::Nginx

    def self.create access
      cdn = self.new(access)

      cdn.create_vhost_file
      cdn.reload_configuration!
    end

    def self.update access
      cdn = self.new(access)

      cdn.create_vhost_file # Replace if domain change (but domain is changeable?)
      cdn.reload_configuration!
    end

    def create_vhost_file
      return true  if vhost_file_exists?
      return false unless @access.try(:identifier)

      # template 'admin_user.rb.erb', "#{vhost_filename}/app/admin/simple_cdn_#{@access.identifier}"
    end

    def reload_configuration!
      line = Cocaine::CommandLine.new("/etc/init.d/nginx", "reload")
      begin
        line.run
      rescue Cocaine::CommandNotFoundError => e
      rescue Cocaine::ExitStatusError => e
        # => You never get here!
      end
    end

  private

    def initialize access
      @access = access
    end

    def vhost_file_exists?
      File.exists? vhost_filename
    end

    def vhost_filename
      path_to_nginx = '/etc/nginx/'
      "#{path_to_nginx}/app/admin/simple_cdn_#{@access.identifier}"
    end
  end
end
