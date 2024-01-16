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
    abi_attr :size, Vector2u
    abi_attr :position, Vector2u
    abi_def :has_focus?, nil => Boolean
    abi_def :request_focus
    def! :request_focus do
      request_focus
    end

  end
end