require 'optparse'
require 'fileutils'
require_relative '../../tgui-update.config'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: tgui-update.rb [options]"

  opts.on("-c", "--compile", "Compile RGUI-ABI") do |v|
    options[:compile] = v
  end
end.parse!

if options[:compile]
  system BUILD_TGUI_ABI
else
  puts "Skipping TGUI-ABI compilation"
end

def script_path file
  File.expand_path(file, File.dirname($0))
end

loader_file = File.new(script_path("../lib/generated/tgui-abi-loader.gf.rb"), "w")
loader_file.write <<~RUBY_
## File generated by tgui-update.rb
## Manual changes not recommended

class Tgui
  module Abi
RUBY_

## Parse header file

classes = {}
classes.default_proc = proc{|h, k| h[k] = []}
pointer_type = proc{ _1.end_with? "*" }
File.new(TGUI_CABI_HPP).each_line do |line|
  if lm = /^\s*(C_ABI_(?:RAW|METHOD|STATIC|SETTER|GETTER|TESTER|MAKE|FREE|SIGNAL))\s+(.+)ABI_([[:alnum:]]*)_(\w+)(.*);/.match(line)
    parser = ""
    return_type = lm[2].strip
    case return_type
    when 'bool'
      parser = ".odd?"
      return_type = 'int'
    when 'char'
      parser = '.chr'
    when pointer_type
      parser = ".parse('#{return_type.delete_prefix("const ").delete_suffix("*").tr(" ", "")}')"
      return_type = "void*"
    end
    function_name = "ABI_#{lm[3]}_#{lm[4]}"
    method_name = lm[4].gsub(/([A-Z])/, '_\1').downcase
    loader_file.write "    extern '#{return_type} #{function_name}#{lm[5]}'\n"
    case lm[1]
    when "C_ABI_METHOD"
      classes[lm[3]] << "def #{method_name}(*a, &b);    Abi.call_arg_map! a; Abi.#{function_name}(@pointer, *a)#{parser}; end"
    when "C_ABI_STATIC"
      classes[lm[3]] << "def self.#{method_name}(*a);    Abi.call_arg_map! a; Abi.#{function_name}(*a)#{parser}; end"
    when "C_ABI_SETTER"
      classes[lm[3]] << "def #{method_name.delete_prefix("set_") + "="}(a);    a = a.is_a?(Array) ? a : [a]; Abi.call_arg_map! a; Abi.#{function_name}(@pointer, *a)#{parser}; end"
    when "C_ABI_GETTER"
      classes[lm[3]] << "def #{method_name.delete_prefix("get_")}(*a);    Abi.call_arg_map! a; Abi.#{function_name}(@pointer, *a)#{parser}; end"
    when "C_ABI_TESTER"
      classes[lm[3]] << "def #{method_name.delete_prefix("is_") + "?"}(*a);    Abi.call_arg_map! a; Abi.#{function_name}(@pointer, *a)#{parser}; end"
    when "C_ABI_MAKE"
      classes[lm[3]] << "def initialize(*a, pointer: nil);    Abi.call_arg_map! a; super(pointer: pointer || Abi.#{function_name}(*a)); initialized(); end"
    when "C_ABI_FREE"
      classes[lm[3]] << "def self.finalizer(pointer);    proc{ Abi.#{function_name}(pointer) }; end"
    when "C_ABI_RAW"
      classes[lm[3]] << "module Private; def self.#{method_name}(*a);    Abi.call_arg_map! a; Abi.#{function_name}(*a)#{parser}; end; end"
    when "C_ABI_SIGNAL"
      classes[lm[3]] << "def #{method_name}(*a, &b);   Abi.call_arg_map! a; signal = Abi.#{function_name}(@pointer, *a)#{parser}; block_given? ? signal.connect(&b) : signal; end"
      classes[lm[3]] << "def #{method_name}=(a);    signal = Abi.#{function_name}(@pointer)#{parser}; signal.connect(&a); end"
    end
  end
end

loader_file.write "  end\n"

classes.each do |c, ms|
  loader_file.write "\n  class #{c}"
  ms.each do |m|
    loader_file.write "\n    "
    loader_file.write m
  end
  loader_file.write "\n  end\n"
end

loader_file.write "end\n"
loader_file.close

## copy generated shared library
FileUtils.cp TGUI_DLL, script_path('../ext/dll/tgui.dll')