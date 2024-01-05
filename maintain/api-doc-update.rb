require_relative '../lib/white_gold/master'
require_relative '../doc/doc'
include Tgui

def write_file filepath, &b
  filepath.split("/").reduce do |path, next_part|
    Dir.mkdir path if not Dir.exist? path
    "#{path}/#{next_part}"
  end
  File.open filepath, "w", &b
end

def public_api_instance_methods type
  methods = type.instance_methods.reject do |m| 
    m =~ /^abi_|_abi_|api_|self_|doc_/
  end - BangNest.instance_methods - ExternObject.instance_methods
  methods.sort
end

def wiki_dir
  File.dirname(File.dirname(__FILE__)) + "/doc/wiki"
end

def update_api_doc type
  type_name = type.name.split("::").last
  file_name = type_name.gsub(/([A-Z])/, '_\1').downcase.delete_prefix("_") + ".md"
  write_file "#{wiki_dir}/api/#{file_name}" do |f|
    f << type_name << "\n" << "===" << "\n"
    public_api_instance_methods(type).each do |m|
      f << "- `#" << m << "`"
      doc_method = "doc_#{m}".to_sym
      if type.respond_to? doc_method
        f << " - " << type.send(doc_method)
      end
      f << "\n"
    end
  end
  [type_name, file_name]
end





WIDGETS = [
  BitmapButton,
  Button,
  ChatBox,
  CheckBox,
  ChildWindow,
  ColorPicker,
  ComboBox,
  EditBox,
  FileDialog,
  Grid,
  Group,
  Gui,
  HorizontalLayout,
  HorizontalWrap,
  Knob,
  Label,
  ListBox,
  ListView,
  MenuBar,
  MessageBox,
  PanelLIstBox,
  Panel,
  Picture,
  ProgressBar,
  RadioButtonGroup,
  RadioButton,
  RangeSlider,
  RichTextLabel,
  ScrollablePanel,
  Scrollbar,
  SeparatorLine,
  Slider,
  SpinButton,
  SpinControl,
  TabContainer,
  Tabs,
  TextArea,
  ToggleButton,
  ToolTip,
  TreeView,
  VerticalLayout,
  Window
].freeze

write_file "#{wiki_dir}/api.md" do |f|
  f << "Widgets" << "\n" << "===" << "\n"
  WIDGETS.each do |type|
    type_name, file_name = *update_api_doc(type)
    f << "- [#{type_name}](./api/#{file_name})" << "\n"
  end
end