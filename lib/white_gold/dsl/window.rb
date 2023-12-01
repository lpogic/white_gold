require_relative '../abi/extern_object'

module Tgui
  class Window < ExternObject

    abi_def :close
    abi_def :open?
    abi_def :title=, String => nil

  end
end