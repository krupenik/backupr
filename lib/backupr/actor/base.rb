module Backupr
  module Actor
    class Base
      def initialize source, destination, options={}
        @source = source
        @destination = destination
        @options = options
      end

      def act
        true
      end

      protected

      def name
        self.class.to_s.split(/::/).last.downcase
      end
    end
  end
end
