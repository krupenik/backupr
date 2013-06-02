require "backupr/actor/pgdump"
require "backupr/actor/rsync"

module Backupr
  module Actor
    def self.create type, source, destination, options={}
      case type.to_sym
      when :storage
        Rsync
      when :sqldump
        self.const_get(options[:type].capitalize)
      else
        raise "Unsupported actor type"
      end.new source, destination, options
    end
  end
end
