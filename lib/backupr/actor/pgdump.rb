require "backupr/actor/base"

module Backupr
  module Actor
    class Pgdump < Base
      SystemDatabases = %w(template0 template1).freeze
      PgdumpOptions = %w().freeze
      PsqlOptions = %w(--tuples-only).freeze

      def act
        setup_destination

        if :all == @options[:databases].to_sym
          @options[:databases] = all_databases
        end

        @options[:databases].map do |database|
          dump database, @source
        end.all?
      end

      private

      def setup_destination
        destination = File.expand_path(self.name, @destination)
        FileUtils.mkdir_p destination
        Dir.chdir destination
      end

      def all_databases
        open("| ssh -C #{@source} 'psql #{psql_options.join(' ')} template1 --command=\"select datname from pg_database\"'").map(&:strip).reject(&:empty?) - SystemDatabases
      end

      def dump database, source
        system "ssh -C #{@source} 'pg_dump #{pg_dump_options.join(' ')} #{database}' | gzip - - > #{database}.sql.gz"
      end

      def pg_dump_options
        pg_dump_options = PgdumpOptions.dup

        pg_dump_options << user_option(@options[:user])

        pg_dump_options.compact
      end

      def psql_options
        psql_options = PsqlOptions.dup

        psql_options << user_option(@options[:user])

        psql_options.compact
      end

      def user_option user
        "--user #{user}" if user
      end
    end
  end
end
