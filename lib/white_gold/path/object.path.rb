require_relative '../convention/proc_method_factory'

class Object
  def behalf client, &todo
    client.instance_exec self, client, &todo
  end

  def proc &block
    block_given? ? Kernel.proc(&block) : ProcMethodFactory.new(self)
  end
end