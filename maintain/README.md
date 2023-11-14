tgui-abi-update.rb
---

Script for updating tgui abi for Windows enviroment.<br>
Requires configuration file to work.<br>
Configuration file should be located at: '../../tgui-abi-update.config' with following structure:

```RUBY

TGUI_CABI_HPP = # absolute path to cabi header file (.../TGUI-ABI/include/TGUI/Abi/Cabi.hpp)
BUILD_TGUI_ABI = # absolute path to compilation script (.../TGUI-ABI.build.bat)
TGUI_DLL = # absolute path to compiled shared library (.../TGUI-ABI/bin/lib/Release/tgui.dll)

```

available flags:

-c - run TGUI-ABI compilation before generating abi loader file
