require 'spec_helper'


module Stack
  describe Environment do

    it "should raise an error if given environment doesn't exist" do
      expect{Stack::Environment.new( name: "named", test: true )}.to raise_error(RuntimeError)
    end

    it "should look for a file with that environment name" do
      begin
        File.open(PROJECT_ROOT.join("spec", "config", "textenv.yml"), "w"){|file| file << YAML::dump({ applications:[ {sumito:{ servers: 1} }]} ) }
        Stack::Environment.new( name: "textenv", test: true ).config
      ensure
        File.delete(PROJECT_ROOT.join("spec", "config", "textenv.yml"))
      end
    end


    describe "Working environment" do

      let(:environment) {
        Stack::Environment.new( name: "fullstack", test: true )
      }

      it "should create a file with empty stack in tmp folder when save" do
        environment.save
        File.exists?(environment.saved_file).should be_truthy
        environment.destroy
        File.exists?(environment.saved_file).should be_falsy
      end


    end

  end
end