require 'spec_helper'

module Stack
  module Brain
    describe Computer do

      let(:to_execute) { (34 + 16) * 2 }
      let(:to_exception) { raise "an error ocurred" }
      let(:command) do
        command = Stack::Brain::Command.new("Command ")
        command.load do
          to_execute
        end
        command
      end
      let(:command_second) do
        command = Stack::Brain::Command.new("Command Second")
        command.load do
          to_execute * 2
        end
        command
      end
      let(:command_exception) do
        command = Stack::Brain::Command.new("Command exception")
        command.load do
          to_exception
        end
        command
      end
      let(:command_stop_exception) do
        command = Stack::Brain::Command.new("Command Ohh Noo")
        command.load do
          raise Stack::Brain::Computer::Stop.new("ohhh nooo")
        end
        command
      end
      let(:computer) { Stack::Brain::Computer.new }

      it "should register instructions in order" do
        computer.register command
        expect(computer.commands.count).to eq(1)
        expect(computer.commands.first).to eq(command)
      end

      it "should be possible to register parallel instructions" do
        computer.register [command,command_second]
        expect(computer.commands.count).to eq(1)
        expect(computer.commands.first.first).to eq(command)
      end

      it "should be able to execute a single command" do
        computer.register command
        expect(computer.execute).to match(/#{to_execute}/)
      end

      it "should be able to execute parallel commands" do
        computer.register [command,command_second]
        computer.execute
        expect(computer.result).to match(/#{to_execute}/)
        expect(computer.result).to match(/#{to_execute * 2}/)
      end

      it "should be able to catch an exception and log it" do
        computer.register command_exception
        expect(computer.execute).to match(/an error ocurred/)
      end

      it "should be able to stop the executoin if stop exception is thrown" do
        computer.register command_stop_exception
        computer.register command
        computer.execute
        expect(computer.result).to match(/ohhh nooo/)
        expect(computer.result).to_not match(/ 100/)
      end

      it "should be able to stop the executoin if stop exception is thrown in parallel" do
        computer.register [command_second,command_stop_exception]
        computer.register command
        computer.execute
        expect(computer.result).to match(/ 200/)
        expect(computer.result).to_not match(/ 100/)
        expect(computer.result).to match(/ohhh nooo/)
      end

      describe "Thread execution" do
        it "should be multi thread execution when parallel" do
          expect(Thread).to receive(:new).twice
          computer.register [command_second,command]
          computer.register command
          computer.execute
        end
        it "should have the same resutl" do
          computer.register [command_second,command]
          computer.register command
          computer.execute
          expect(computer.result).to match(/ 200/)
          expect(computer.result).to match(/ 100/)
        end
      end


    end
  end
end