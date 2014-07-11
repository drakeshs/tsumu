require 'spec_helper'


module Cluster
  describe Base do

    let(:cluster) { Cluster::Base.new( "staging")  }

    it "should condigure AWS" do
      AWS.should_receive(:config)
      Cluster::Base.new( "staging")
    end

    it "should have a accessible ec2 object" do
      expect(cluster).to respond_to :ec2
      expect(cluster).to respond_to :ec2=
    end

    it "should have an environment" do
      expect(cluster).to respond_to :environment
      expect(cluster).to respond_to :environment=
    end


    context 'working cluster' do

      let(:cluster_name) { "staging" }
      let(:cluster) { Cluster::Base.new( cluster_name ) }

      it "should have an environment with the name of the cluster" do
        expect(cluster.environment.name).to eq(cluster_name)
        cluster.environment.should be_instance_of(Cluster::Environment)
      end

      it "should have many web applications" do
        cluster.applications.count.should eq(2)
        cluster.applications.first.should be_instance_of( Cluster::Application )
      end

      it "should have a database server"
      it "should have a cache server"

      it "should gather all as services"

      it "should print the status of all services"

      context "provider" do
        it "should be deployed to a AWS"
        it "should return a valid AWS connection"
        it "should return a valid AWS EC2"
        it "should return a valid AWS RDS"
        it "should return a valid AWS ElasticCache"
      end


    end


  end
end