require_relative 'theme_attributed'
require_relative 'common_renderer'

module Tgui
  class ThemeComponent
    include BangNest
    extend ThemeAttributed

    def initialize name
      @name = name
      @attributes = {}
    end

    attr :name

    DEFINED_ATTRIBUTES = {}

    def self.defined_attributes rise = false
      if rise
        ThemeComponent::DEFINED_ATTRIBUTES[self] ||= {}
      else
        ThemeComponent::DEFINED_ATTRIBUTES[self] || {}
      end
    end

    def to_theme
      return "" if @attributes.empty?
      "#{name} {\n#{@attributes.values.map(&:to_theme).join("\n")}\n}"
    end
  end
end