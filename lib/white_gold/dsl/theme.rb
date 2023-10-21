require_relative '../extern_object'

module Tgui
  class Theme < ExternObject
    def self.default=(theme)
      self.set_default theme
    end
  end
end