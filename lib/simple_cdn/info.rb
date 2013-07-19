module SimpleCDN
  module Info #:nodoc:
    class << self
      def app_name; 'SimpleCDN' end
      def url; 'https://github.com/nicolas-brousse/simple-cdn-server/' end
      def help_url; 'https://github.com/nicolas-brousse/simple-cdn-server/wiki' end
      def versioned_name; "#{app_name} #{Invoicer::VERSION}" end

      def environment
        s = "Environment:\n"
        s << [
          ["SimpleCDN version", Invoicer::VERSION],
          ["Ruby version", "#{RUBY_VERSION} (#{RUBY_PLATFORM})"],
          ["Rails version", Rails::VERSION::STRING],
          ["Environment", Rails.env],
          ["Database adapter", ActiveRecord::Base.connection.adapter_name]
        ].map {|info| "  %-40s %s" % info}.join("\n")
      end
    end
  end
end