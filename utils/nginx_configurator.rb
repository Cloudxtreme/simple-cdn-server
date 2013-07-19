require 'cocaine'

class NginxConfigurator

  def create_vhost
    create_vhost_file
  end

  def update_vhost
  end

  def reload_configuration
    line = Cocaine::CommandLine.new("/etc/init.d/nginx", "reload")
    begin
      line.run
    rescue Cocaine::ExitStatusError => e
      # => You never get here!
    end
  end

private
  def create_vhost_file
    return true if vhost_file_exists?
  end

  def vhost_file_exists?
  end
end
