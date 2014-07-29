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
        commands << @command_factory.create do
          if @stack.key_pair.exists?
            p "Deleting key pair"
            @stack.key_pair.destroy
            p "Key pair deleted"
          end
        end
        commands << @command_factory.create do
          if @stack.group.exists?
            p "Deleting Group #{@stack.group.name}"
            @stack.group.destroy
            p "Group #{@stack.group.name} deleted"
          end
        end
        commands << @command_factory.create do
          if @stack.db_group.exists?
            p "Deleting Group #{@stack.db_group.name}"
            @stack.db_group.destroy
            p "Group #{@stack.db_group.name} deleted"
          end
        end
        commands << @command_factory.create do
          if @stack.cache_group.exists?
            p "Deleting Group #{@stack.cache_group.name}"
            @stack.cache_group.destroy
            p "Group #{@stack.cache_group.name} deleted"
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
