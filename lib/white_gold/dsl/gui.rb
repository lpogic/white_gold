require_relative 'backend_gui'
require_relative 'signal/signal'

module Tgui
  class Gui < BackendGui
    abi_signal :on_view_change, Tgui::Signal
  end
end