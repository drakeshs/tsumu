module Provider
    class Factory

      def self.server( record, strategy, provider )
        class_name = case record
        when Server
          "Box"
        when Database
          "DbBox"
        when KeyPair
          "Key"
        end
        Object.const_get("::Provider::#{strategy.downcase.titlecase}::#{class_name}").new(record, provider)
      end

  end
end
