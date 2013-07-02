require 'simple_smart_answers/flow'

class SimpleSmartAnswersController < ApplicationController

  rescue_from RecordNotFound, with: :cacheable_404

  def flow
    artefact = fetch_artefact(params[:slug])
    @publication = PublicationPresenter.new(artefact)
    cacheable_404 and return unless @publication.format == "simple_smart_answer"

    responses = params[:responses].to_s.split('/')
    @flow = SimpleSmartAnswers::Flow.new(@publication.nodes)
    @flow_state = @flow.state_for_responses(responses)

    if params[:response]
      @flow_state.add_response(params[:response])
      redirect_to smart_answer_path_for_responses(@flow_state.completed_questions)
    end
  end

  private

  helper_method :smart_answer_path_for_responses, :change_completed_question_path

  def smart_answer_path_for_responses(responses, extra_params = {})
    responses_as_string = responses.any? ? responses.map(&:slug).join("/") : nil
    smart_answer_flow_path extra_params.merge(:slug => @publication.slug, :responses => responses_as_string)
  end
end
