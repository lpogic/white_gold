require_relative '../extern_object'

module Tgui
  class Window < ExternObject

    abi_alias :close
    abi_alias :open?, :is_

  end
end