if Object.const_defined?('LogStasher') && LogStasher.enabled
  LogStasher.add_custom_fields do |fields|
    # Mirrors Nginx request logging, e.g GET /path/here HTTP/1.1
    fields[:request] = "#{request.request_method} #{request.fullpath} #{request.headers['SERVER_PROTOCOL']}"
    # Pass the request id to logging
    fields[:govuk_request_id] = request.headers['GOVUK-Request-Id']
    fields[:varnish_id] = request.headers['X-Varnish']
  end

  LogStasher.watch('postcode_error_notification') do |_name, _start, _finish, _id, payload, store|
    store[:postcode_error] = payload[:postcode_error]
  end
end
