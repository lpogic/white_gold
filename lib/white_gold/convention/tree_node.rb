class TreeNode
  def initialize text
    @text = text
    @nodes = {}
  end

  attr_accessor :text
  attr :nodes

  def [](*path, grow: false)
    if grow
      path.reduce(self){|node, o| node.nodes[o] ||= TreeNode.new(nil) }
    else
      path.reduce(self){|node, o| node&.nodes[o] }
    end
  end

  def cut *path, last
    self[*path].nodes.delete last
  end

  def cut_branches *path
    self[*path].nodes = {}
  end

  def path_str_to_object *path
    object_path = []
    path.reduce self do |node, str|
      o, node = *node.nodes.find{|k, v| v.text == str }
      object_path << o
      node
    end
    object_path
  end

  def path_object_to_str *path
    str_path = []
    path.reduce self do |node, o|
      node[o].tap{ str_path << _1.text }
    end
    str_path
  end
end