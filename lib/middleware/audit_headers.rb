class AuditHeaders
  def initialize(app)
    @app = app
    @responses = []
    at_exit { show_output }
  end

  def call(env)
    @status, @headers, @response = @app.call(env)
    @responses << [env["PATH_INFO"], @status, @headers.keys.inject("") { |s, k| s + "#{k}: #{@headers[k]}\n" }.length]
    [@status, @headers, @response]
  end

  def show_output
    @compact_responses = {}
    @responses.each do |r|
      @compact_responses[r[0]] = r unless @compact_responses.key?(r[0])
      @compact_responses[r[0]] = r if @compact_responses[r[0]][2] < r[2]
    end

    @compact_responses.values.sort_by { |r| r[2] }.reverse.each do |r|
      puts("AD::R #{r[0]} (#{r[1]}) Response headers size=#{r[2]}")
    end
  end
end
