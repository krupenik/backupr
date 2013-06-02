require 'fileutils'

module Backupr
  class Host
    attr_accessor :address, :storage, :sqldump

    def initialize address, &block
      @address = address
      yield self if block_given?
    end

    def backup
      complete = []

      backup_root = File.join(Backupr.config.root, self.address, Time.now.strftime(Backupr::DirFormat))
      backup_temp = "#{backup_root}.#{Backupr::ProgressMark}"

      if self.storage
        complete << Backupr::Actor.create(:storage, self.address, backup_temp, self.storage).act
      end

      if self.sqldump
        complete << Backupr::Actor.create(:sqldump, self.address, backup_temp, self.sqldump).act
      end

      if complete.any?
        latest_path = File.expand_path(File.join("..", "Latest"), backup_root)

        FileUtils.mv backup_temp, backup_root
        FileUtils.rm_f latest_path
        FileUtils.ln_sf File.basename(backup_root), latest_path
      else
        FileUtils.rm_rf backup_temp
      end
    end
  end
end
