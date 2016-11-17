require 'simple_smart_answers/flow'

class SimpleSmartAnswersController < ApplicationController
  before_filter :validate_slug_param
  before_filter -> { set_expiry unless viewing_draft_content? }

  rescue_from RecordNotFound, with: :cacheable_404

  def flow
    artefact = fetch_artefact(params[:slug], params[:edition])

    @publication = PublicationPresenter.new(artefact)
    @edition = params[:edition]

    cacheable_404 and return unless @publication.format == "simple_smart_answer"

    setup_content_item_and_navigation_helpers("/" + params[:slug])

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

  def viewing_draft_content?
    params.include?('edition')
  end
end
