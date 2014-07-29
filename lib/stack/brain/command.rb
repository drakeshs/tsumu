module Stack
  module Brain
    class Command

      attr_reader :instruction

      def initialize
        @instruction = Proc.new{}
        @error = Proc.new{}
      end

      def load(&block)
        @instruction = block
      end

      def execute
        @instruction.call()
      end

      def register_error(&block)
        @error = block
      end

      def on_error
        @error.call()
      end

      def self.create(&block)
        command = new
        command.load(&block)
        command
      end

    end
  end
end
