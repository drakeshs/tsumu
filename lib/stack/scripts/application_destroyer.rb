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

        if @application.balanced?
          command = @command_factory.create("Delete load balancer for application #{@application.name}") do
                      if @application.load_balancer.exists?
                        @application.load_balancer.destroy
                      end
                    end
          @computer.register(command)
        end

        if @application.cdn?
          command = @command_factory.create("Delete CDN #{@application.cdn.name} for application #{@application.name} ") do
                      @application.cdn.destroy if @application.cdn.exists?
                    end
          @computer.register(command)
        end

        commands = @application.servers.inject([]) do |cmds,server|
          cmds << @command_factory.create("Delete Server #{server.name} for application #{@application.name} ") do
                    if server.exists?
                      server.destroy
                    end
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
