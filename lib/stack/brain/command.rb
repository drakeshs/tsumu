module Stack
  module Brain
    class Command

      attr_reader :instruction, :name

      def initialize(name)
        @name = name
        @instruction = Proc.new{}
        @error = Proc.new{}
      end

      def load(&block)
        @instruction = block
        raise "Check your instruction" if @instruction.nil?
      end

      def execute
        p @name
        result = @instruction.call()
        p "#{@name} :: Done"
        result
      end

      def register_error(&block)
        @error = block
      end

      def on_error
        @error.call()
      end

      def self.create(name, &block)
        command = new(name)
        command.load(&block)
        command
      end

    end
  end
end
