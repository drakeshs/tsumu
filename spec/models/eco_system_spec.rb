require 'rails_helper'

RSpec.describe EcoSystem, :type => :model do


  let(:eco_system) { create(:aws_eco_system) }

  describe "AWS warehouse" do
    it "should return a valid warehouse" do
      expect(eco_system.warehouse).to be_instance_of(OpenStruct)
      expect(eco_system.warehouse.compute).to be_instance_of(Fog::Compute::AWS::Mock)
    end
  end

end
