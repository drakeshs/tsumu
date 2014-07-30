module Stack
  module Brain
    class Computer

      class Stop < StandardError
      end

      attr_reader :commands

      def initialize
        @commands = []
        @output = ""
      end

      def register( command )
        @commands << command
      end

      def execute
        begin
          do_execute( @commands )
        rescue Stack::Brain::Computer::Stop => e
          @output << "[]: #{e.message}"
        end
        @output
      end

      def register_error(&block)
        @error = block
      end

      def on_error
        @error.call()
      end

      def result
        @output.nil? ? "" : @output
      end


      private

      def do_log(command,result)
        "[#{command.object_id}]: #{result.to_s} \n"
      end
      def do_error( command, message )
        "[#{command.object_id}]: ERROR: #{message.to_s} \n"
      end

      def secure_execute( command )
        begin
          @output << do_log( command, command.execute )
        rescue Stack::Brain::Computer::Stop => e
          @output << do_error( command, "#{command.name} :: #{e.message}\n" << e.backtrace.join("\n") )
          raise Stack::Brain::Computer::Stop.new("aborted execution")
        rescue Exception => e
          @output << do_error( command, "#{command.name} :: #{e.message}\n" << e.backtrace.join("\n") )
        end
      end

      def do_execute( legacy_commands )
        legacy_commands.each do |command|
          if command.is_a?(Enumerable)
            do_parallel_execute( command )
          else
            secure_execute( command )
          end
        end
      end

      def do_parallel_execute( legacy_commands )
        legacy_commands.inject([]) do |threads, command|
          threads << Thread.new { secure_execute( command ) }
        end.compact.map(&:join)
      end

    end
  end
end
