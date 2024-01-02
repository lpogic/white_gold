require_relative 'theme_attributed'

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

    def default_name
      self.class.name.split("::")[-2]
    end

    def base_name
      @name || default_name
    end

    def name
      @custom_name || base_name
    end

    def to_theme
      return "" if @attributes.empty? && !@custom_name
      header = @custom_name ? "#{@custom_name} : #{base_name}" : name
      "#{header} {\n#{@attributes.values.map(&:to_theme).join("\n")}\n}"
    end
  end
end