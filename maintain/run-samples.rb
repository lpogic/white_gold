require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: tgui-update.rb [options]"

  opts.on("-sSTART", "--start=START", "First script to run. All previous will be skipped.") do |v|
    options[:start] = v
  end
end.parse!

def each_file_ancestor base, dir, &b
  base_dir = "#{base}/#{dir}"
  Dir.each_child base_dir do |filename|
    if File.directory? "#{base_dir}/#{filename}"
      each_file_ancestor base, "#{dir}/#{filename}", &b
    else
      b.("#{dir}/#{filename}")
    end
  end
end

each_file_ancestor '.', 'sample' do |script|
  if script.end_with? ".rb"
    if !options[:start] || options[:start] == script
      options[:start] = nil
      puts script
      `ruby ./#{script}`
    end
  end
end