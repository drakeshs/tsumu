module Provider
    class Factory

      def self.server( record, strategy, provider )
        Object.const_get("::Provider::#{strategy.downcase.titlecase}::Box").new(record, provider)
      end

  end
end
