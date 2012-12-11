require "backupr/version"
require "backupr/cleaner"

module Backupr
  DirFormat = "%F-%H%M%S"
  
  class << self
    def host(name, &block)
      Backupr::Host.new(name, &block)
    end
  end
end
