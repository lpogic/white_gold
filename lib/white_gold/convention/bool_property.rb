class BoolProperty
  def initialize pointer
    @pointer = pointer
  end

  def set value = true
    @pointer.set value
  end

  def unset
    @pointer.unset
  end
end