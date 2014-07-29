require 'spec_helper'


module Stack
  describe Base do

    let(:stack) { Stack::Base.new( "staging")  }

    it "should have a accessible provider" do
      expect(stack).to respond_to :provider
      expect(stack).to respond_to :provider=
    end

    it "should have an environment" do
      expect(stack).to respond_to :environment
      expect(stack).to respond_to :environment=
    end


    context 'working stack' do

      let(:stack_name) { "staging" }
      let(:stack) { Stack::Base.new( stack_name ) }

      it "should have an environment with the name of the stack" do
        expect(stack.environment.name).to eq(stack_name)
        stack.environment.should be_instance_of(Stack::Environment)
      end

      it "should have many web applications" do
        stack.applications.count.should eq(2)
        stack.applications.first.should be_instance_of( Stack::Application )
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