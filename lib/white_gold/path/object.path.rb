class Object
  def behalf client, &todo
    client.instance_exec self, client, &todo
  end
end