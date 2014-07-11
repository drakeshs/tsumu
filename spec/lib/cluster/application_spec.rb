require 'spec_helper'


module Cluster
  describe Application do

    let(:application) { Cluster::Application.new  }

    it "should have a accessible ec2 object" do
      expect(application).to respond_to :ec2
      expect(application).to respond_to :ec2=
    end

    it "should respond to a name" do
      expect(application).to respond_to :name
      expect(application).to respond_to :name=
    end

    it "should respond to a cluster" do
      expect(application).to respond_to :cluster
      expect(application).to respond_to :cluster=
    end

    it "should respond to a config" do
      expect(application).to respond_to :config
      expect(application).to respond_to :config=
    end

    context "fully application" do

      let(:config) {
        { "servers" => 1 }
      }
      let(:cluster) { Cluster::Base.new("staging") }

      let(:application) {
        cluster
        Cluster::Application.new(
          name: "test",
          ec2: AWS::EC2.new,
          config: config,
          cluster: cluster
        )}

      it "should have many servers" do
        application.servers.count.should eq(1)
        application.servers.first.should be_instance_of( Cluster::Server )
        application.servers.first.name.should eq("#{application.name}_1")
      end


      it "should have a database connection"
      it "should have status from those server"
      it "should have a cache connection"

      it "should be able to install"
      it "should be able to delete"
      it "should be able to display information"
    end


  end
end