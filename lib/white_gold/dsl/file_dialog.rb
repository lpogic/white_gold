require_relative 'child_window'

module Tgui
  class FileDialog < ChildWindow
    def selected_paths # not empty only in onFileSelected callback
      data = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        data << str.parse('char32_t')
      end
      _abi_get_selected_paths @pointer, block_caller
      return data
    end

    abi_attr :path
    abi_attr :filename

    def file_type_filters=(filters)
      length_it = filters.values.map(&:size).each
      length_block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [0]) do
        length_it.next
      rescue StopIteration
        ""
      end
      filter_it = filters.map{|k, v| [k, *v] }.flatten.each
      filter_block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        filter_it.next
      rescue StopIteration
        ""
      end
      _abi_set_file_type_filters filters.size, length_block_caller, filter_block_caller, 0
    end

    def file_type_filters
      data = Hash.new{|h, k| h[k] = [] }
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |i, b, f|
        data[b.parse('char32_t')] << f.parse('char32_t')
      end
      _abi_get_file_type_filters block_caller
      data.default_proc = nil
      return data
    end

    def file_type_filter
      filters = file_type_filters
      key = filters.keys[file_type_filters_index]
      key ? {key => filters[key]} : {} # empty filter = pass all
    end

    abi_attr :confirm_text, :confirm_button_text
    abi_attr :cancel_text, :cancel_button_text
    abi_attr :create_folder_text, :create_folder_button_text
    abi_attr :allow_create_folder?
    abi_attr :filename_label, :filename_label_text

    def name_label=(label)
      self_change_list_view_column_captions 0, label
    end

    def name_label
      self_get_list_view_column_captions[0] 
    end

    def size_label=(label)
      self_change_list_view_column_caption 1, label
    end

    def size_label
      self_get_list_view_column_captions[1]
    end

    def modified_label=(label)
      self_change_list_view_column_caption 2, label
    end

    def modified_label
      self_get_list_view_column_captions[2]
    end

    abi_attr :file_must_exist?, :get_
    abi_attr :dir_only=, :set_selecting_directory
    abi_alias :dir_only?, :get_selecting_directory
    abi_attr :multi_select?, :get_
    abi_signal :on_file_select, Signal
    abi_signal :on_cancel, Signal


    def self_change_list_view_column_caption column, caption
      captions = self_get_list_view_column_captions
      captions[column] = caption
      _abi_set_list_view_column_captions *captions
    end

    def self_get_list_view_column_captions
      data = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        data << str.parse('char32_t')
      end
      _abi_get_list_view_column_captions block_caller
      return data
    end
  end
end