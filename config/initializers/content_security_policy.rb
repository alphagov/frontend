GovukContentSecurityPolicy.configure do |policy|
  # The map component makes use of maplibre
  policy.img_src(*policy.img_src, "https://tiles.openfreemap.org", :data)
  policy.connect_src(*policy.connect_src, "https://tiles.openfreemap.org", :data)
  policy.worker_src(*policy.worker_src, "self", :blob)
end
