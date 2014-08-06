module Stack
  module Scripts
    class ApplicationBuilder

      def initialize( application )
        @application = application
        @computer = Stack::Brain::Computer.new
        @command_factory = Stack::Brain::Command

        preload

      end

      def preload
        if @application.balanced?
          command = @command_factory.create("Creating load balancer for application #{@application.name} ") do
                      unless @application.load_balancer.exists?
                        @application.load_balancer.create
                        @application.load_balancer.add_security_group(@application.stack.group.name)
                      end
                    end
          @computer.register(command)

          if @application.cdn?
            command = @command_factory.create("Creating CDN #{@application.cdn.name} for application #{@application.name} ") do
                        @application.cdn.create unless @application.cdn.exists?
                      end
            @computer.register(command)
          end

          commands = @application.servers.inject([]) do |cmds,server|
            cmds << @command_factory.create("Creating Server #{server.name} for application #{@application.name} ") do
                      unless server.exists?
                        server.add_group( @application.stack.db_group.name ) if @application.config["database"]
                        server.add_group( @application.stack.cache_group.name ) if @application.config["cache"]
                        server.create
                        sleep(1) while server.status[:status] != "running"
                        @application.load_balancer.add_instance( server.get.id ) if @application.balanced?
                      end
                    end
            cmds
          end
           @computer.register commands
        else
          server = @application.servers.first
          command = @command_factory.create("Creating Server #{server.name} for application #{@application.name} ") do
                      unless server.exists?
                        server.add_group( @application.stack.db_group.name ) if @application.config["database"]
                        server.add_group( @application.stack.cache_group.name ) if @application.config["cache"]
                        server.create
                        sleep(1) while server.status[:status] != "running"
                        @application.load_balancer.add_instance( server.get.id ) if @application.balanced?
                      end
                    end
          @computer.register(command)
        end

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
