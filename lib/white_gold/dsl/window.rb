require_relative '../abi/extern_object'
require_relative '../convention/bang_nest'

module Tgui
  class Window < ExternObject
    include BangNest

    abi_def :close
    def! :close do
      close
    end
    abi_def :open?
    abi_def :title=, String => nil

  end
end