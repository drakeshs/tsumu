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
        @computer.register @command_factory.create do
          if !@application.load_balancer.exists? && @application.balanced?
            p "Creating load balancer for application #{@application.name} "
            @application.load_balancer.create
            @application.load_balancer.add_security_group(@application.stack.group.get.name)
            p "Load Balancer for application #{@application.name} created"
          end
        end
        if @application.balanced?
          commands = @application.servers.inject([]) do |cmds,server|
            cmds << @command_factory.create do
                      unless server.exists?
                        p "Creating Server #{server.name} for application #{@application.name} "
                        server.add_group( @application.stack.db_group.get.name ) if @application.config["database"]
                        server.add_group( @application.stack.cache_group.get.name ) if @application.config["cache"]
                        server.create
                        sleep(1) while server.status[:status] != "running"
                        @application.load_balancer.add_instance( server.get.id ) if @application.balanced?
                        p "Server #{server.name} for application #{@application.name} created"
                      end
                    end
            cmds
          end
           @computer.register commands
        else
         @computer.register @command_factory.create do
            server = @application.servers.first
            unless server.exists?
              p "Creating Server #{server.name} for application #{@application.name} "
              server.add_group( @application.stack.db_group.get.name ) if @application.config["database"]
              server.add_group( @application.stack.cache_group.get.name ) if @application.config["cache"]
              server.create
              sleep(1) while server.status[:status] != "running"
              @application.load_balancer.add_instance( server.get.id ) if @application.balanced?
              p "Server #{server.name} for application #{@application.name} created"
            end
          end
        end
      end

      def run
        @computer.execute
        p @computer.result
      end

    end
  end
end
