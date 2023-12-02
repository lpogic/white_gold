class String
  def pascalcase
    split("_").map(&:capitalize).join
  end
end