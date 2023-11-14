class Unit
  @@default = :px

  class << self
    
    def default=(unit)
      @@default = unit
    end

    def default
      @@default
    end

    def nominate numeric, unit = @@default
      case unit
      when :pixel, :px then numeric.px
      when :percent, :pc then numeric.pc
      else raise "Ivalid unit `#{unit}` (:px/:pixel/:pc/:percent allowed)"
      end
    end
  end
end
