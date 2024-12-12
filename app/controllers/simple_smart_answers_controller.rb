require "simple_smart_answers/flow"

class SimpleSmartAnswersController < ContentItemsController
  include Cacheable

  def show
    @presenter = SimpleSmartAnswerPresenter.new(content_item)
  end

  def flow
    responses = params[:responses].to_s.split("/")
    @flow = SimpleSmartAnswers::Flow.new(publication.nodes)
    @flow_state = @flow.state_for_responses(responses)

    if params[:response] && !@flow_state.error?
      @flow_state.add_response(params[:response])
      redirect_to smart_answer_path_for_responses(@flow_state.completed_questions) unless @flow_state.error?
    end
  end

private

  helper_method(
    :answer_summary_data,
    :change_completed_question_path,
    :simple_smart_answer_page_title,
    :smart_answer_path_for_responses,
  )

  def content_item_path
    "/#{params[:slug]}"
  end

  def publication_class
    SimpleSmartAnswerPresenter
  end

  def smart_answer_path_for_responses(responses, extra_attrs = {})
    responses_as_string = responses.any? ? responses.map(&:slug).join("/") : nil
    attrs = { slug: publication.slug, responses: responses_as_string, edition: params[:edition] }.merge(extra_attrs)
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
          data_attributes: {
            module: "ga4-link-tracker",
            ga4_link: {
              event_name: "form_change_response",
              type: "simple smart answer",
              section: question.question.title,
              action: "change response",
              tool_name: publication.title,
            },
          },
        },
      }
    end

    items
  end

  def simple_smart_answer_page_title(page_title)
    title = []

    if @flow_state.error?
      title << "Error"
    end

    title << page_title
    title << publication.title
    title << "GOV.UK"

    title.join(" - ")
  end
end
