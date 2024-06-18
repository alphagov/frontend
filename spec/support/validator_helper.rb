module ValidatorHelper
  def build_random_string(len)
    chars = [*"a".."z", *"0".."9"]
    r = ""
    len.times { r << chars[rand(36)] }
    r
  end
end
