module ImageHelper
  def srcset_string(name, image)
    if image[:sources]["#{name}_2x".to_sym]
      return "#{image_path(image[:sources][name])}, #{image_path(image[:sources]["#{name}_2x".to_sym])} 2x"
    end

    image_path(image[:sources][name])
  end
end
