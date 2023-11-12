class ProcMethodFactory
  def initialize source
    @source = source
  end

  def method_missing name, *curry
    proc do |*a, **na, &b|
      method = @source.method name
      arity = method.arity
      a = [*curry, *a]
      if arity >= 0
        @source.send(name, *a[...arity], **na, &b)
      else
        @source.send(name, *a, **na, &b)
      end
    end
  end

  def respond_to? name
    @source.respond_to? name
  end
end