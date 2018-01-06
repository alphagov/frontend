if Object.const_defined?('LogStasher') && LogStasher.enabled
  LogStasher.watch('postcode_error_notification') do |_name, _start, _finish, _id, payload, store|
    store[:postcode_error] = payload[:postcode_error]
  end
end
