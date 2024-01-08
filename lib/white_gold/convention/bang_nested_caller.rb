module BangNestedCaller

  @@bang_stack = []

  def self.push object
    @@bang_stack.push object
  end

  def self.pop
    @@bang_stack.pop
  end

  def self.peek
    @@bang_stack.last
  end

  def self!
    @bang_nest ? BangNestedCaller.peek : self
  end

  def bang_respond_to? name
    top = self!
    top.respond_to?("#{name}=") || top.respond_to?("api_bang_#{name}")
  end

  def bang_method_missing name, *a, **na, &b
    top = self!
    api_bang_name = "api_bang_#{name[...-1]}".to_sym
    return top.send(api_bang_name, *a, **na, &b) if top.respond_to? api_bang_name
    setter = "#{name[...-1]}=".to_sym
    if top.respond_to? setter
      return top.send(setter, a) if !a.empty?
      return top.send(setter, na) if !na.empty?
      return top.send(setter, b) if block_given?
      return top.send(setter)
    end

    no_method_error = NoMethodError.new("bang method missing `#{name}` for #{top.class}")
    raise no_method_error
  end

  def nest! &b
    @bang_nest = true
    BangNestedCaller.push self
    if b
      b.call
      BangNestedCaller.pop
      @bang_nest = false
    end
  end

  def send! &b
    if b
      BangNestedCaller.push self
      b.call self
      BangNestedCaller.pop
    end
    self
  end
end
