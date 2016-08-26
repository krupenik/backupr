require "time"

module Backupr
  module Cleaner
    Cutoffs = [
      [3600, "%F-%H%M"],  # minutely
      [86400, "%F-%H"],   # hourly
      [30 * 86400, "%F"], # daily
      [nil, "%Y-W%V"],    # weekly
    ]

    def clean(path)
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

    def survivors(data, from, cutoffs)
      survivors = cutoffs.reduce([]) { |a, (interval, format)|
        a << data.select { |i| i >= from - interval }
        a
      }
    end

    def last_of_group(data, &block)
      data.group_by(&block).values.map(&:last)
    end
  end
end
