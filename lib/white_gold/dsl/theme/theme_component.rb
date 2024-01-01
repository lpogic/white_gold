require_relative 'theme_attributed'
require_relative 'common_renderer'

module Tgui
  class ThemeComponent
    include BangNest
    extend ThemeAttributed

    def initialize name, custom_name
      @name = name
      @custom_name = custom_name
      @attributes = {}
    end

    attr :name, :attributes

    def to_theme
      return "" if @attributes.empty?
      header = @custom_name ? "#{@custom_name} : #{@name}" : @name
      "#{header} {\n#{@attributes.values.map(&:to_theme).join("\n")}\n}"
    end
  end
end