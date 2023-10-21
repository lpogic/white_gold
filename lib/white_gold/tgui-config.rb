module Tgui
  module Config
    LIBS = [
      File.expand_path('../../ext/dll/openal32.dll', __dir__),
      File.expand_path('../../ext/dll/sfml-system-2.dll', __dir__),
      File.expand_path('../../ext/dll/sfml-window-2.dll', __dir__),
      File.expand_path('../../ext/dll/sfml-graphics-2.dll', __dir__),
      File.expand_path('../../ext/dll/tgui.dll', __dir__),
    ].freeze
  end
end