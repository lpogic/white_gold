require_relative 'boolean_attribute'
require_relative 'color_attribute'
require_relative 'float_attribute'
require_relative 'outline_attribute'
require_relative 'text_styles_attribute'
require_relative 'texture_attribute'

module Tgui
  module ThemeAttributed
    include Extree

    ATTRIBUTE_TYPES = {
      boolean: BooleanAttribute,
      color: ColorAttribute,
      float: FloatAttribute,
      outline: OutlineAttribute,
      text_styles: TextStylesAttribute,
      texture: TextureAttribute,
    }.freeze

    def theme_attr name, type
      attr_name = name.to_s.pascalcase
      attr_type = ATTRIBUTE_TYPES[type]
      def! name do |*value|
        attributes[attr_name] = attr_type.new attr_name, value
      end
    end

    def theme_comp name, type
      def! name do |custom_name = nil, base_name = nil, **na, &b|
        attribute = type.new(base_name, custom_name)
        attribute = attributes[attribute.name] ||= attribute
        attribute.host! **na, &b
      end
    end
  end
end