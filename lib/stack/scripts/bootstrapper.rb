module Stack
  module Scripts
    class Bootstrapper

      def initialize( stack )
        @stack = stack
        @computer = Stack::Brain::Computer.new
        @command_factory = Stack::Brain::Command

        preload

      end

      def preload

        commands=[]

        commands = @stack.applications.inject([]) do |cmds,app|
            cmds << @command_factory.create("Bootstrap application #{app.name} ") do
                        app.bootstrap()
                    end
            cmds
          end
        @computer.register commands

      end

      def commands
        @computer.commands
      end

      def run
        @computer.execute
        p @computer.result
      end

    end
  end
end
