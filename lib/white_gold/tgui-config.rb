module Tgui
  module Config
    if RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
      LIBS = [
        File.expand_path('../../ext/dll/openal32.dll', __dir__),
        File.expand_path('../../ext/dll/sfml-system-2.dll', __dir__),
        File.expand_path('../../ext/dll/sfml-window-2.dll', __dir__),
        File.expand_path('../../ext/dll/sfml-graphics-2.dll', __dir__),
        File.expand_path('../../ext/dll/tgui.dll', __dir__),
      ].freeze
    else
      LIBS = [
        File.expand_path('../../ext/so/libsfml-system.so', __dir__),
        File.expand_path('../../ext/so/libsfml-window.so', __dir__),
        File.expand_path('../../ext/so/libsfml-graphics.so', __dir__),
        File.expand_path('../../ext/so/libtgui.so', __dir__),
      ].freeze
    end
  end
end