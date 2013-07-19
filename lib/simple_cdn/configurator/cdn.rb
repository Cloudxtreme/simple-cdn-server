module SimpleCDN
  class Configurator::CDN

    def self.create access
      cdn = self.new(access)
      cdn.init_cdn
    end

    def self.update access
      cdn = self.new(access)
    end

    def init_cdn
      return true if File.directory? cdn_dirname
      FileUtils.mkdir_p "#{Rails.root}/data/cdn_repositories/#{@access.identifier}"
    end

  private

    def initialize access
      @access = access
    end

    def cdn_dirname
      "#{Rails.root}/data/cdn_repositories/#{@access.identifier}"
    end
  end
end
