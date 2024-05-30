require_relative '../abi/extern_object'

module Tgui
  class Window < ExternObject
    include Extree

    def self.finalizer(pointer)
      _abi_delete pointer
    end

    abi_def :close
    def! :close do
      close
    end
    abi_def :open?
    abi_def :title=, String => nil
    abi_attr :size, Vector2i
    abi_attr :position, Vector2i
    abi_def :has_focus?, nil => Boolean
    abi_def :request_focus
    def! :request_focus do
      request_focus
    end

  end
end