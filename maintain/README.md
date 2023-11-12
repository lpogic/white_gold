** tgui-abi-update.rb

Script for generating abi loader (../lib/generated/tgui-abi-loader.gf.rb).
Requires configuration file to work. Configuration file should be located at: '../../tgui-update.config'
Configuration file structure:

```RUBY

TGUI_CABI_HPP = # absolute path to cabi header file (.../TGUI-ABI/include/TGUI/Abi/Cabi.hpp)
BUILD_TGUI_ABI = # absolute path to compilation script (.../TGUI-ABI.build.bat)
TGUI_DLL = # absolute path to compiled shared library (.../TGUI-ABI/bin/lib/Release/tgui.dll)

```

available flags:

-c - run TGUI-ABI compilation before generate abi loader file