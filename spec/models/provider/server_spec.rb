require 'rails_helper'

RSpec.describe Server, :type => :model do


  describe "AWS provider" do

    let(:eco_system) { create(:aws_eco_system) }
    let(:application) { Application.new( eco_system: eco_system, name: "staging" ) }
    let(:server) { Server.new( application:  application ) }

    it "should return a provider from given ecosystem" do
      expect(server.provider).to be_instance_of(Fog::Compute::AWS::Mock)
    end

    it "should return a valid provider instance box object" do
      expect(server.box).to be_instance_of(Provider::Aws::Box)
    end

  end

end
