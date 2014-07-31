module Stack
  module Scripts
    class Uninstaller

      def initialize( stack )
        @stack = stack
        @computer = Stack::Brain::Computer.new
        @command_factory = Stack::Brain::Command

        preload

      end

      def preload
        commands = []
        commands << @command_factory.create("Deleting Database #{@stack.database.name}") do
          if @stack.database.exists?
            @stack.database.destroy
          end
        end
        commands << @command_factory.create("Deleting Cache #{@stack.cache.name}") do
          if @stack.cache.exists?
            @stack.cache.destroy
          end
        end

        @computer.register commands

        @stack.applications.each do |application|
          application.destroy.commands.each{ |command| @computer.register command }
        end

        commands = []
        commands << @command_factory.create("Deleting key pair") do
          if @stack.key_pair.exists?
            @stack.key_pair.destroy
          end
        end
        commands << @command_factory.create("Deleting Group #{@stack.group.name}") do
          if @stack.group.exists?
            @stack.group.destroy
          end
        end
        commands << @command_factory.create("Deleting Group #{@stack.db_group.name}") do
          if @stack.db_group.exists?
            @stack.db_group.destroy
          end
        end
        commands << @command_factory.create("Deleting Group #{@stack.cache_group.name}") do
          if @stack.cache_group.exists?
            @stack.cache_group.destroy
          end
        end
        @computer.register commands

      end

      def run
        @computer.execute
        p @computer.result
      end

    end
  end
end
