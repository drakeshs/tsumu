module Provider
  module Aws
    class Box

      def initialize( record, provider )
        @record = record
        @provider = provider
      end

      def get
        @provider.servers.get(@record.name)
        rescue
        nil
      end

      def exists?
        !get.nil?
      end

      def destroy
        unless @record.private_ip_address.nil?
          system "knife node delete ip-#{@record.private_ip_address.gsub(".","-")}.ec2.internal -y"
          system "knife client delete ip-#{@record.private_ip_address.gsub(".","-")}.ec2.internal -y"
        end
        get.destroy
      end

      def run_up
        unless exists?
          server = @provider.servers.new({
            flavor_id: @record.application.safe_flavor,
            image_id: @record.application.safe_image_id,
            vpc_id: @record.eco_system.vpc,
            subnet_id: @record.eco_system.subnet.box_id,
            security_group_ids: @record.groups_name,
            key_name: @record.application.eco_system.key_pairs.first.name,
            tags: { group: @record.application.name, eco_system: @record.eco_system_name  }
            })
          server.save
          server.wait_for { sleep(1); ready? }
          server
        end
      end

      def bootstrap
        root_file = "cd #{Rails.root} &&"
        ip = Rails.env.development? ? @record.ip : @record.private_ip_address
        log = "> log/bootstrap_#{@record.name}_#{@record.application.name}_#{@record.application.eco_system.rails_environment}.log 2> log/bootstrap_#{@record.name}_#{@record.bootstrap_role}_#{@record.application.eco_system.rails_environment}_error.log"
        system "#{root_file} knife bootstrap #{ip} -x ubuntu -i keys/#{@record.application.eco_system.key_pairs.first.name}.pem -r 'role[#{@record.bootstrap_role}]' --secret-file .chef/encrypted_data_bag_secret --sudo -E #{@record.application.eco_system.rails_environment} #{log}"
      end


    end
  end
end
