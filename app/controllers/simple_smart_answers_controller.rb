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
  end
end
