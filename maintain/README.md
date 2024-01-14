tgui-abi-update.rb
===

Script for updating tgui abi.<br>
Requires configuration file to work.<br>
Configuration file should be located at: '../../tgui-abi-update.config' with following structure:

```RUBY

TGUI_CABI_HPP = # absolute path to cabi header file (.../TGUI-ABI/include/TGUI/Abi/Cabi.hpp)
BUILD_TGUI_ABI  = # absolute path to compilation script (.../TGUI-ABI.build.bat) or compilation command (make -C .../TGUI-ABI/bin)
TGUI_COMPILED_BIN = # absolute path to compiled shared library (.../TGUI-ABI/bin/lib/Release/tgui.dll) (.../TGUI-ABI/bin/lib/tgui.so-0.0.1)
TGUI_TARGET_BIN = # absolute path to target shared library (.../ext/dll/tgui.dll) (.../ext/so/tgui.so)

```

options:

**-c** - run TGUI-ABI compilation before generating abi loader file

api-doc-update.rb
===

Compiles .rbmd files to .md (inserts code, evaluate expressions). Generates API reference pages.

Current directory excepted to be .../white_gold (not .../white_gold/maintain)!

No additional configuration required. No parameters excepted.

run-samples.rb
===

Run selected scripts from samples folder sequentially. Simplifies manual testing.

No additional configuration required. No parameters excepted.

options:

**-sSTART, --start=START** - First script to run. All previous will be skipped.