require "time"

module Backupr
  class Cleaner
    Cutoffs = [
      [86400, "%F-%H"],   # hourly
      [31 * 86400, "%F"], # daily
      [nil, "%Y-W%V"],    # weekly
    ]
    
    def self.clean(path)
      now = Time.now.utc
      Dir.chdir path

      data = Dir["*"].map { |i| Time.strptime(i, Backupr::DirFormat).utc }

      survivors = data.select { |i| i > now - Cutoffs[0][0] }      
      Cutoffs[0..-2].each do |interval, format|
        survivors += last_of_group(data.select { |i| i >= now - interval }) { |i| i.strftime(format) }
      end
      survivors += last_of_group(data.select { |i| i < now - Cutoffs[-2][0] }) { |i| i.strftime(Cutoffs[-1][1]) }
      survivors.uniq!

      (data - survivors).uniq.each { |i| FileUtils.rmtree(i.strftime(Backupr::DirFormat)) }
    end
    
    def self.last_of_group(data, &block)
      data.group_by(&block).map { |k, v| v.last }
    end
  end
end
