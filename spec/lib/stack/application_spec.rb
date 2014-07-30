require 'spec_helper'


module Stack
  describe Application do

    let(:application) { Stack::Application.new  }

    it "should respond to a name" do
      expect(application).to respond_to :name
      expect(application).to respond_to :name=
    end

    it "should respond to a stack" do
      expect(application).to respond_to :stack
      expect(application).to respond_to :stack=
    end

    it "should respond to a config" do
      expect(application).to respond_to :config
      expect(application).to respond_to :config=
    end

    context "fully application" do

      let(:config) {
        { "servers" => 1, flavor: "t1.micro", image_id: "ami-00894c68" }
      }
      let(:config_2) {
        { "servers" => 3, flavor: "t1.micro", image_id: "ami-00894c68" }
      }
      let(:stack) { Stack::Base.new("staging") }

      let(:application) {
        stack
        Stack::Application.new(
          name: "test",
          provider: stack.provider.compute,
          config: config,
          stack: stack
        )}


      let(:application_2) {
        stack
        Stack::Application.new(
          name: "test",
          provider: stack.provider.compute,
          config: config_2,
          stack: stack
        )}

      it "should have many servers" do
        application.servers.count.should eq(1)
        application.servers.first.should be_instance_of( Stack::Server )
        application.servers.first.name.should eq("#{application.name}_1")
      end

      it "should have a application builder to build servers" do
        builder = application.build
        computer = builder.instance_variable_get(:@computer)
        expect(computer.commands.count).to eq(1)
      end

      it "should have application builder with multi server in parallel" do
        builder = application_2.build
        computer = builder.instance_variable_get(:@computer)
        expect(computer.commands.last).to be_instance_of(Array)
        expect(computer.commands.last.count).to eq(config_2["servers"])
      end

      it "should have an application destroyer" do
        destroyer = application_2.destroy
        computer = destroyer.instance_variable_get(:@computer)
        expect(computer.commands.last).to be_instance_of(Array)
        expect(computer.commands.last.count).to eq(config_2["servers"])
      end


    end


  end
end