require "simple_smart_answers/flow"

class SimpleSmartAnswersController < ApplicationController
  include Navigable

  slimmer_template "wrapper"

  before_action :set_expiry
  before_action -> { set_content_item(SimpleSmartAnswerPresenter) }

  def show; end

  def flow
    responses = params[:responses].to_s.split("/")
    @flow = SimpleSmartAnswers::Flow.new(@publication.nodes)
    @flow_state = @flow.state_for_responses(responses)

    if params[:response] && !@flow_state.error?
      @flow_state.add_response(params[:response])
      redirect_to smart_answer_path_for_responses(@flow_state.completed_questions) unless @flow_state.error?
    end
  end

private

  helper_method(
    :smart_answer_path_for_responses,
    :change_completed_question_path,
    :answer_summary_data,
  )

  def smart_answer_path_for_responses(responses, extra_attrs = {})
    responses_as_string = responses.any? ? responses.map(&:slug).join("/") : nil
    attrs = { slug: @publication.slug, responses: responses_as_string, edition: params[:edition] }.merge(extra_attrs)
    smart_answer_flow_path attrs
  end

  def change_completed_question_path(question_number)
    smart_answer_path_for_responses(@flow_state.completed_questions[0...question_number], previous_response: @flow_state.completed_questions[question_number].slug)
  end

  def answer_summary_data
    items = []
    @flow_state.completed_questions.each_with_index do |question, completed_question_counter|
      items << {
        field: "#{completed_question_counter + 1}. #{question.question.title}",
        value: question.label,
        edit: {
          href: change_completed_question_path(completed_question_counter),
          link_text: t("formats.simple_smart_answer.change"),
        },
      }
    end

    items
  end
end
