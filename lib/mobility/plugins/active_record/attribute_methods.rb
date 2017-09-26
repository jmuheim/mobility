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
      end

      class AttributeMethods < Module
        def initialize(*attribute_names)
          include TranslatedAttributes
          define_method :translated_attributes do
            super().merge(attribute_names.inject({}) { |attributes, name| attributes.merge(name.to_s => send(name)) })
          end
        end

        def included(model_class)
          untranslated_attributes = model_class.superclass.instance_method(:attributes)
          model_class.class_eval do
            define_method :untranslated_attributes, untranslated_attributes
          end
        end
      end
    end
  end
end
