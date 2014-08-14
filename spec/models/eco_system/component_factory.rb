require 'rails_helper'

RSpec.describe EcoSystem, :type => :model do


  let(:eco_system) { create(:aws_eco_system) }


  describe "Database & Cache factory" do

    it "should not factor for any other key" do
      expect{ eco_system.factory.create(:server) }.to raise_error
    end

    it "should factor databases for given eco system" do
      instance = eco_system.factory.create(:database)
      expect(instance).to be_instance_of(Database)
      expect(instance.name).to eq( "#{instance.engine}-#{eco_system.name.to_s}" )
    end

    it "should factor caches for given eco system" do
      instance = eco_system.factory.create(:cache)
      expect(instance).to be_instance_of(Cache)
    end

    it "should be possible to override attributes" do
      instance = eco_system.factory.create(:database,  { name: "buuuu"})
      expect(instance.name).to eq( "buuuu" )
    end

  end


end
