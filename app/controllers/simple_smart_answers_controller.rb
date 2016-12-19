require 'simple_smart_answers/flow'

class SimpleSmartAnswersController < ApplicationController
  include Previewable
  include Cacheable
  include Navigable

  before_filter :redirect_if_api_request, only: :show

  def show
    @publication = publication
  end

  def flow
    @publication = publication

    cacheable_404 and return unless @publication.format == "simple_smart_answer"

    responses = params[:responses].to_s.split('/')
    @flow = SimpleSmartAnswers::Flow.new(@publication.nodes)
    @flow_state = @flow.state_for_responses(responses)

    if params[:response] and ! @flow_state.error?
      @flow_state.add_response(params[:response])
      redirect_to smart_answer_path_for_responses(@flow_state.completed_questions) unless @flow_state.error?
    end
  end

private

  helper_method :smart_answer_path_for_responses, :change_completed_question_path

  def smart_answer_path_for_responses(responses, extra_attrs = {})
    responses_as_string = responses.any? ? responses.map(&:slug).join("/") : nil
    attrs = { slug: @publication.slug, responses: responses_as_string, edition: params[:edition] }.merge(extra_attrs)
    smart_answer_flow_path attrs
  end

  def change_completed_question_path(question_number)
    smart_answer_path_for_responses(@flow_state.completed_questions[0...question_number], previous_response: @flow_state.completed_questions[question_number].slug)
  end

  def redirect_if_api_request
    redirect_to "/api/#{params[:slug]}.json" if request.format.json?
  end
end
