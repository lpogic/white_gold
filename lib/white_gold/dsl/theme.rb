require_relative '../extern_object'

module Tgui
  class Theme < ExternObject
    def self.default=(theme)
      _abi_set_default Util.expand_path(theme)
    end
  end
end