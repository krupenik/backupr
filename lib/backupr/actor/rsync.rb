require 'fileutils'
require 'pathname'
require 'backupr/actor/base'

module Backupr
  module Actor
    class Rsync < Base
      RsyncOptions = %w(--archive --compress --delete-during --quiet).freeze

      def act
        @options[:paths].map do |path|
          rsync [@source, path].compact.join(':'), File.expand_path(File.join(self.name, File.dirname(path)), @destination)
        end.all?
      end

      private

      def rsync source, destination
        FileUtils.mkdir_p destination
        system "rsync #{rsync_options(destination).join(' ')} #{source} #{destination}"
      end

      def rsync_options destination=nil
        rsync_options = RsyncOptions.dup

        rsync_options << link_dest_option(destination)
        rsync_options << filter_options

        rsync_options.compact
      end

      def link_dest_option destination_path
        "--link-dest #{File.expand_path(File.join("Latest", Pathname(destination_path).relative_path_from(Pathname(@destination)).to_s), File.dirname(@destination))}"
      end

      def filter_options
        Array(@options[:filters]).map { |f| "--filter '#{f}'" }
      end
    end
  end
end
