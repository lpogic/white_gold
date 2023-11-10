module BangNestedCaller
  def bang_respond_to? name
    name.end_with?("!") && (respond_to?("#{name[...-1]}=") || respond_to?(name[...-1]) || (@bang_target && @bang_target.respond_to?(name)))
  end

  def bang_method_missing name, *a, **na, &b
    return @bang_target.send(name, *a, **na, &b) if @bang_target && @bang_target.respond_to?(name)
    if na.empty?
      if block_given?
        if a.empty?
          if respond_to? "#{name[...-1]}="
            return send("#{name[...-1]}=", b)
          end
        end
      else
        if a.size == 1
          if respond_to? "#{name[...-1]}="
            return send("#{name[...-1]}=", a.first)
          end
        end
      end
    end
    return send(name[...-1], *a, **na, &b) if respond_to?(name[...-1])
    no_method_error = NoMethodError.new("undefined bang nested method `#{name}` for #{bang_object_stack.map(&:class).join("/")}")
    raise no_method_error
  end

  def self!
    @bang_target.respond_to?(:self!) ? @bang_target.self! : self
  end

  def bang_object_stack root = true
    stack = []
    stack << self if root
    stack << @bang_target if @bang_target
    stack += @bang_target.bang_object_stack(false) if @bang_target&.respond_to? :bang_object_stack
    return stack
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
