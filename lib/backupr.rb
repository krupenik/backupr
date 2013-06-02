require "backupr/version"
require "backupr/cleaner"
require "backupr/host"
require "backupr/actor"

module Backupr
  DirFormat = "%F-%H%M%S"
  StateFilename = "backupr.state"
  ProgressMark = "inProgress"
  Commands = %w(backup).freeze

  Error = Class.new StandardError
  DuplicateEntryError = Class.new Error

  class Config
    attr_accessor :root
  end

  @hosts = {}
  @config = Config.new

  class << self
    # we don't simply give away the storage
    def hosts
      @hosts.dup
    end

    def config
      @config.dup
    end

    def clear
      @hosts.clear
    end

    def configure
      yield @config if block_given?
    end

    def host address, &block
      self.add_host(Backupr::Host.new(address, &block))
    end

    def add_host host
      # we raise an exception instead of silently replacing to keep config files clean
      raise Backupr::DuplicateEntryError if @hosts.has_key?(host.address)

      @hosts[host.address] = host
    end

    def backup
      @hosts.each { |_, h| h.backup }
    end

    def load_config(config)
      files = File.directory?(config) ? Dir['**/*.conf'] : Dir[config]
      abort "No files could be found (search path: #{config})" if files.empty?
      files.each do |f|
        unless load_file(f)
          abort "File '#{f}' could not be loaded"
        end
      end
    end

    def load_file(f)
      load File.expand_path(f)
      true
    rescue Exception => e
      if e.instance_of?(SystemExit)
        raise
      else
        puts "There was an error in #{f}"
        puts "\t" + e.message
        puts "\t" + e.backtrace.join("\n\t")
        false
      end
    end
  end
end
