module SimpleCDN
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 1
    TINY  = 0
    PRE   = "beta"

    def self.revision
      revision = nil
      entries_path = "#{Rails.root}/.git/refs/heads/#{self.branch}"
      if File.readable?(entries_path)
        begin
          f = File.open(entries_path, 'r')
          entries = f.read
          revision = entries[0, 8]
        rescue
          # Could not find the current revision
        end
      end
      revision
    end

    def self.branch
      branch = nil
      entries_path = "#{Rails.root}/.git/HEAD"
      if File.readable?(entries_path)
        begin
          f = File.open(entries_path, 'r')
          entries = f.read
          if entries.match(%r{^ref: refs\/heads\/(.+)$})
            branch = $1.to_s
          end
        rescue
          # Could not find the current revision
        end
      end
      branch
    end

    REVISION = self.revision.freeze
    BRANCH   = self.branch.freeze
    ARRAY    = [MAJOR, MINOR, TINY, PRE, BRANCH, REVISION].compact.freeze

    LONG   = ARRAY.join('.').freeze
    MEDIUM   = [MAJOR, MINOR, TINY, PRE].join('.').freeze
    SHORT    = ARRAY[0, 2].join('.').freeze

    def self.to_a; ARRAY  end
    def self.to_s; MEDIUM end

    def self.short;  SHORT  end
    def self.medium; MEDIUM end
    def self.long;   LONG end
  end
end
