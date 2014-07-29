module Stack
  module Scripts
    class ApplicationDestroyer

      def initialize( application )
        @application = application
        @computer = Stack::Brain::Computer.new
        @command_factory = Stack::Brain::Command

        preload

      end

      def preload
        @computer.register @command_factory.create do
          if @application.load_balancer.exists?
            p "Deleting load balancer for application #{@application.name} "
            @application.load_balancer.destroy
            p "Load Balancer for application #{@application.name} deleted"
          end
        end
        commands = @application.servers.inject([]) do |cmds,server|
          cmds << @command_factory.create do
                    p "Deleting Server #{server.name} for application #{@application.name} "
                    if server.exists?
                      server.destroy
                    end
                    p "Server #{server.name} for application #{@application.name} deleted"
                  end
          cmds
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
