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
      _abi_set_file_type_filters @pointer, filters.size, length_block_caller, filter_block_caller, 0
    end

    def file_type_filters
      data = Hash.new{|h, k| h[k] = [] }
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP, Fiddle::TYPE_VOIDP]) do |i, b, f|
        data[b.parse('char32_t')] << f.parse('char32_t')
      end
      _abi_get_file_type_filters @pointer, block_caller
      data.default_proc = nil
      return data
    end

    def file_type_filter
      filters = file_type_filters
      key = filters.keys[file_type_filters_index]
      key ? {key => filters[key]} : {} # empty filter = pass all
    end

    def list_view_column_captions
      data = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |str|
        data << str.parse('char32_t')
      end
      _abi_get_list_view_column_captions @pointer, block_caller
      return data
    end
  end
end