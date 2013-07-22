module SimpleCDN
  class Configurator::CDN

    def self.create access
      cdn = self.new(access)
      cdn.init_cdn
    end

    def self.update access
      cdn = self.new(access)
    end

    def self.is_empty? access
      cdn = self.new(access)
      cdn.is_empty?
    end

    def self.destroy! access
      cdn = self.new(access)
      cdn.destroy!
    end

    def self.calculate_size! access
      cdn  = self.new(access)
      size = cdn.calculate_size

      access.size = size
      access.save
    end

    def init_cdn
      return true if File.directory? cdn_dirname
      FileUtils.mkdir_p "#{Rails.root}/data/cdn_repositories/#{@access.identifier}"
    end

    def is_empty?
      return true unless File.directory?(cdn_dirname)
      return true if (Dir.entries(cdn_dirname) - %w{ . .. }).empty?
      return false
    end

    def destroy!
      FileUtils.rm_rf(cdn_dirname)
    end

    def calculate_size
      total_size = 0
      path       = cdn_dirname
      path << '/' unless path.end_with?('/')

      raise RuntimeError, "#{path} is not a directory" unless File.directory?(path)

      Dir["#{path}**/*"].each do |f|
        total_size += File.size(f) if File.file?(f) && File.size?(f)
      end
      total_size
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
