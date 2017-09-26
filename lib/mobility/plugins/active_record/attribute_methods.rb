module Mobility
  module Plugins
    module ActiveRecord
      module TranslatedAttributes
        def translated_attributes
          {}
        end

        def attributes
          super.merge(translated_attributes)
        end

        define_method :untranslated_attributes, ::ActiveRecord::Base.instance_method(:attributes)
      end

      class AttributeMethods < Module
        def initialize(*attribute_names)
          include TranslatedAttributes
          define_method :translated_attributes do
            super().merge(attribute_names.inject({}) { |attributes, name| attributes.merge(name.to_s => send(name)) })
          end
        end
      end
    end
  end
end
