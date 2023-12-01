require_relative 'child_window'

module Tgui
  class FileDialog < ChildWindow

    abi_def :selected_paths, nil => (String..) # not empty only in onFileSelected callback
    abi_attr :path, String
    abi_attr :filename, String

    def file_type_filters=(filters)
      length_it = filters.values.map(&:size).each
      length_block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [0]) do
        length_it.next
      rescue StopIteration
        0
      end
      filter_it = filters.map{|k, v| [k, *v] }.flatten.each
      filter_block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        abi_pack_string filter_it.next
      rescue StopIteration
        ""
      end
      _abi_set_file_type_filters filters.size, length_block_caller, filter_block_caller, 0
    end

    def file_type_filters
      data = Hash.new{|h, k| h[k] = [] }
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |i, b, f|
        data[abi_unpack_string b] << abi_unpack_string(f)
      end
      _abi_get_file_type_filters block_caller
      data.default_proc = nil
      return data
    end

    def file_type_filter
      filters = file_type_filters
      key = filters.keys[_abi_get_file_type_filters_index]
      key ? {key => filters[key]} : {} # empty filter = pass all
    end

    abi_attr :confirm_text, String, :confirm_button_text
    abi_attr :cancel_text, String, :cancel_button_text
    abi_attr :create_folder_text, String, :create_folder_button_text
    abi_attr :allow_create_folder?
    abi_attr :filename_label, String, :filename_label_text
    abi_def :list_view_column_captions, :get_, nil => (String..)

    def name_label=(label)
      self_change_list_view_column_captions 0, label
    end

    def name_label
      list_view_column_captions[0] 
    end

    def size_label=(label)
      self_change_list_view_column_caption 1, label
    end

    def size_label
      list_view_column_captions[1]
    end

    def modified_label=(label)
      self_change_list_view_column_caption 2, label
    end

    def modified_label
      list_view_column_captions[2]
    end

    abi_attr :file_must_exist?, :get_
    abi_def :dir_only=, :set_selecting_directory, "Boolean" => nil
    abi_def :dir_only?, :get_selecting_directory, nil => "Boolean"
    abi_attr :multi_select?, :get_
    abi_signal :on_file_select, Signal
    abi_signal :on_cancel, Signal

    def self_change_list_view_column_caption column, caption
      captions = list_view_column_captions
      captions[column] = abi_pack_string caption
      _abi_set_list_view_column_captions *captions
    end
  end
end