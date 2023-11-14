require_relative '../extern_object'

module Tgui
  class Window < ExternObject

    abi_alias :close
    abi_alias :open?, :is_
    abi_alias :title=, :set_

  end
end