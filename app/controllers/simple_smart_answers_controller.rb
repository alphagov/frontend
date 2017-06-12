require 'simple_smart_answers/flow'

class SimpleSmartAnswersController < ApplicationController
  include Navigable
  include EducationNavigationABTestable
  include BenchmarkingContactDvlaABTestable

  before_filter :set_expiry
  before_filter -> { set_content_item(SimpleSmartAnswerPresenter) }

  def show
    if is_benchmarking_tested_path?
      set_benchmark_contact_dvla_title_response_header
    end

    if is_benchmarking_lab_tested_path?
      set_benchmark_contact_dvla_button_response_header
    end
  end

  def flow
    if is_benchmarking_tested_path?
      set_benchmark_contact_dvla_title_response_header
    end
    responses = params[:responses].to_s.split('/')
    @flow = SimpleSmartAnswers::Flow.new(@publication.nodes)
    @flow_state = @flow.state_for_responses(responses)

    if params[:response] and ! @flow_state.error?
      @flow_state.add_response(params[:response])
      redirect_to smart_answer_path_for_responses(@flow_state.completed_questions) unless @flow_state.error?
    end
  end

private

  helper_method(
    :smart_answer_path_for_responses,
    :change_completed_question_path,
    :is_benchmarking_tested_path?,
    :is_benchmarking_lab_tested_path?,
    :should_show_benchmarking_variant?,
    :should_show_benchmarking_lab_variant?
  )

  def smart_answer_path_for_responses(responses, extra_attrs = {})
    responses_as_string = responses.any? ? responses.map(&:slug).join("/") : nil
    attrs = { slug: @publication.slug, responses: responses_as_string, edition: params[:edition] }.merge(extra_attrs)
    smart_answer_flow_path attrs
  end

  def change_completed_question_path(question_number)
    smart_answer_path_for_responses(@flow_state.completed_questions[0...question_number], previous_response: @flow_state.completed_questions[question_number].slug)
  end
end
