module BangNestedCaller
  def bang_respond_to? name
    (@bang_target && @bang_target.respond_to?(name)) || (name.end_with?("!") && respond_to?(name[...-1]))
  end

  def bang_method_missing name, *a, **na, &b
    return @bang_target.send(name, *a, **na, &b) if @bang_target && @bang_target.respond_to?(name)
    return send(name[...-1], *a, **na, &b) if respond_to?(name[...-1])
    return super
  end

  def bang_nest item, **na, &b
    na.each do |k, v|
      item.send("#{k}=", v)
    end
    if b
      @bang_target, original_bang_target = item, @bang_target
      b.call item
      @bang_target = original_bang_target
    end
    item
  end
end
