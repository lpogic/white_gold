class Foo
  def []=(*a, value)
    p a
  end
end

foo = Foo.new
foo[] = 1
foo[1, 3, ratio: 4, bool: true] = 2
foo[1, 2] = 3