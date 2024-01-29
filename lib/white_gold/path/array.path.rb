class Array
  def x
    self[0]
  end

  def y
    self[1]
  end

  alias_method :_insert, :[]=
  
  def []=(*a)
    a.size != 1 ? _insert(*a) : append(a[0])
    return a.last
  end
end