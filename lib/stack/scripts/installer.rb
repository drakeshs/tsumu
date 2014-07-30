module Stack
  module Scripts
    class Installer

      def initialize( stack )
        @stack = stack
        @computer = Stack::Brain::Computer.new
        @command_factory = Stack::Brain::Command

        preload

      end

      def preload
        commands = []
        commands << @command_factory.create("Creating key pair") do
          unless @stack.key_pair.exists?
            @stack.key_pair.create
          end
        end
        commands << @command_factory.create("Creating Group #{@stack.group.name}") do
          unless @stack.group.exists?
            @stack.group.create
          end
        end
        commands << @command_factory.create("Creating Group #{@stack.db_group.name}") do
          unless @stack.db_group.exists?
            @stack.db_group.create
          end
        end
        commands << @command_factory.create("Creating Group #{@stack.cache_group.name}") do
          unless @stack.cache_group.exists?
            @stack.cache_group.create
          end
        end
        @computer.register commands

        commands = []
        commands << @command_factory.create("Creating Database #{@stack.database.name}") do
          unless @stack.database.exists?
            @stack.database.create
          end
        end
        commands << @command_factory.create("Creating Cache #{@stack.cache.name}") do
          unless @stack.cache.exists?
            @stack.cache.create
          end
        end

        @computer.register commands

        @stack.applications.each do |application|
          application.build.run
        end

      end

      def run
        @computer.execute
        p @computer.result
      end

    end
  end
end
