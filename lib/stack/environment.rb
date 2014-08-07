module Stack
  class Environment

    attr_accessor :name, :config, :group_name

    def initialize( args = {} )
      @name = args.fetch(:name, "development")
      @test = Stack::Base::TEST
      @group_name = "dish-env-#{@name}"
      load_config
      @description = load
    end

    def db_group_name
      "db_#{@group_name}"
    end

    def cache_group_name
      "cache_#{@group_name}"
    end

    def load_config
       config_file.tap do |config|
        raise "Config environment is not present in environments.yml" if config.nil?
        @config = config
      end
    end


    def saved_file
      PROJECT_ROOT.join("tmp/#{@name}.yml")
    end

    def load
      @description =  if File.exists?(saved_file)
                        YAML::load_file( saved_file )
                      else
                        @config
                      end
    end

    def save
      File.open(saved_file, "w") do |file|
        file << YAML::dump( @description )
      end
    end

    def destroy
      if File.exists?(saved_file)
        File.delete(saved_file)
      end
    end

    private

    def config_file
      base =  if @test
                PROJECT_ROOT.join("spec")
              else
                PROJECT_ROOT
              end
      if File.exists?( base.join("config","#{@name}.yml") )
        YAML::load_file(base.join("config","#{@name}.yml"))
      else
        YAML::load_file(base.join("config","environments.yml"))[@name]
      end
    end

  end
end