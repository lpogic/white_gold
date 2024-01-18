require_relative '../lib/white_gold/master'
require_relative '../doc/draft/doc'
include Tgui

def write_file filepath, &b
  filepath.split("/").reduce do |path, next_part|
    Dir.mkdir path if not Dir.exist? path
    "#{path}/#{next_part}"
  end
  File.open filepath, "w", &b
end

def public_api_instance_methods type, exlude = []
  methods = type.instance_methods.reject do |m| 
    m =~ /^abi_|_abi_|api_child|self_/
  end - exlude
  methods.map{|m| m =~ /^api_bang_(.*)/ ? "#{$1}!" : m.to_s }.sort
end

def base_dir
  Dir.getwd
end

def update_api_doc type
  type_name = type.name.split("::").last
  file_name = type_name.gsub(/([A-Z])/, '_\1').downcase.delete_prefix("_") + ".md"
  write_file "#{base_dir}/doc/wiki/api/widget/#{file_name}" do |f|
    f << type_name << "\n" << "===" << "\n"
    public_api_instance_methods(type, ExternObject.instance_methods + BangNest.instance_methods).each do |m|
      f << "- `#" << m << "`"
      doc_method = "doc_#{m}".to_sym
      if type.respond_to? doc_method
        f << " - " << type.send(doc_method)
      end
      f << "\n"
    end
    type.constants.each do |const_symbol|
      const = type.const_get(const_symbol)
      if const.is_a?(Class)
        if const < WidgetLike
          f << "## #{const_symbol}\n"
          public_api_instance_methods(const, WidgetLike.instance_methods).each do |m|
            f << "- `#" << m << "`\n"
          end
        elsif const < ThemeComponent
          f << "## #{const_symbol}\n"
          public_api_instance_methods(const, ThemeComponent.instance_methods).each do |m|
            f << "- `#" << m << "`\n"
          end
        end
      end
    end
  end
  [type_name, file_name]
end

def compile_rbmd input_file, output_file
  write_file output_file do |f|
    File.foreach input_file do |line|
      if line =~ /#\[(.*)\]/
        f << "```RUBY\n"
        File.foreach "#{base_dir}/#{$1}" do |line|
          f << line
        end
        f << "\n```\n"
      else
        f << line.gsub(/\#{.*?}/){|group| eval group[2...-1] }
      end
    end
  end
end


write_file "#{base_dir}/doc/wiki/api/README.md" do |f|
  f << "Widgets" << "\n" << "===" << "\n"
  widget_set = Tgui.widget_set
  widget_set.keys.sort.each do |method|
    type = widget_set[method]
    type_name, file_name = *update_api_doc(type)
    f << "- `##{method}!` => [#{type_name}](./widget/#{file_name})" << "\n"
  end
end

compile_rbmd "#{base_dir}/doc/draft/wiki.rbmd", "#{base_dir}/doc/wiki/README.md"
compile_rbmd "#{base_dir}/doc/draft/readme.rbmd", "#{base_dir}/README.md"
