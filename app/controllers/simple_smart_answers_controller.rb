require 'simple_smart_answers/flow'

class SimpleSmartAnswersController < ApplicationController

  before_filter :validate_slug_param
  before_filter :set_expiry
  before_filter :setup_edition

  rescue_from RecordNotFound, with: :cacheable_404

  def flow
    artefact = fetch_artefact(params[:slug], @edition)
    @publication = PublicationPresenter.new(artefact)
    cacheable_404 and return unless @publication.format == "simple_smart_answer"

    responses = params[:responses].to_s.split('/')
    @flow = SimpleSmartAnswers::Flow.new(@publication.nodes)
    @flow_state = @flow.state_for_responses(responses)

    if params[:response] and ! @flow_state.error?
      @flow_state.add_response(params[:response])
      redirect_to smart_answer_path_for_responses(@flow_state.completed_questions) unless @flow_state.error?
    end

    set_slimmer_artefact_headers(artefact)
  end

  private

  def setup_edition
    @edition = params[:edition].to_i
    if @edition > 0
      expires_now # Prevent caching when previewing
    else
      @edition = nil
    end
  end

  helper_method :smart_answer_path_for_responses, :change_completed_question_path

  def smart_answer_path_for_responses(responses, extra_attrs = {})
    responses_as_string = responses.any? ? responses.map(&:slug).join("/") : nil
    attrs = {:slug => @publication.slug, :responses => responses_as_string, :edition => @edition}.merge(extra_attrs)
    smart_answer_flow_path attrs
  end

  def change_completed_question_path(question_number)
    smart_answer_path_for_responses(@flow_state.completed_questions[0...question_number], :previous_response => @flow_state.completed_questions[question_number].slug)
  end
end
