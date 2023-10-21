class Club
  def initialize
    @params = {}
    @members = []
  end

  def join id
    @members << id
  end

  def params
    @params
  end

  def members
    @members
  end

  def []=(param, value)
    @params[param] = value
  end

  def [](param)
    @params[param]
  end
end