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
        commands << @command_factory.create do
          unless @stack.key_pair.exists?
            p "Creating key pair"
            @stack.key_pair.create
            p "Key pair created"
          end
        end
        commands << @command_factory.create do
          unless @stack.group.exists?
            p "Creating Group #{@stack.group.name}"
            @stack.group.create
            p "Group #{@stack.group.name} created"
          end
        end
        commands << @command_factory.create do
          unless @stack.db_group.exists?
            p "Creating Group #{@stack.db_group.name}"
            @stack.db_group.create
            p "Group #{@stack.db_group.name} created"
          end
        end
        commands << @command_factory.create do
          unless @stack.cache_group.exists?
            p "Creating Group #{@stack.cache_group.name}"
            @stack.cache_group.create
            p "Group #{@stack.cache_group.name} created"
          end
        end
        @computer.register commands

        commands = []
        commands << @command_factory.create do
          unless @stack.database.exists?
            p "Creating Database #{@stack.database.name}"
            @stack.database.create
            p "Database #{@stack.database.name} created"
          end
        end
        commands << @command_factory.create do
          unless @stack.cache.exists?
            p "Creating Cache #{@stack.cache.name}"
            @stack.cache.create
            p "Cache #{@stack.cache.name} created"
          end
        end

        @stack.applications.each do |application|
          commands + application.build.commands
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
