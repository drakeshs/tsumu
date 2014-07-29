require 'spec_helper'

module Stack
  module Brain
    describe Command do

      let(:contextual_sum) { 34 + other  }
      let(:other) { 16 }
      let(:on_error) { 404 }
      let(:command) { Stack::Brain::Command.new }

      it "should be able to load a command in context" do
        command.load do
          contextual_sum
        end
        command.instruction.should be_instance_of(Proc)
      end

      it "should call given command and return value" do
        command.load do
          contextual_sum
        end
        command.execute.should eq (contextual_sum)
      end

      it "should be able to have a on error action" do
        command.register_error do
          on_error
        end
        command.on_error.should eq (on_error)
      end

    end
  end
end