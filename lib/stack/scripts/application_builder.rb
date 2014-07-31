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
                      if !@application.load_balancer.exists? && @application.balanced?
                        @application.load_balancer.create
                        @application.load_balancer.add_security_group(@application.stack.group.name)
                      end
                    end
          @computer.register(command)


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
