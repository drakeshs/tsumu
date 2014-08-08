require 'rails_helper'

RSpec.describe Server, :type => :model do


  let(:eco_system) { create(:aws_eco_system) }
  let(:application) { Application.new( eco_system: eco_system, name: "staging" ) }
  let(:server) { Server.new( application:  application ) }

  it "should update serve's info after build" do
    server.should_receive(:box).twice.and_return(OpenStruct.new( create: nil, get: nil ))
    server.should_receive(:update_after_run_up)
    server.build!
  end

end
