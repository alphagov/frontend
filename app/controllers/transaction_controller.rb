class TransactionController < ContentItemsController
  include Cacheable
  include LocaleHelper

  before_action :deny_framing
  attr_accessor :variant_slug

  helper_method :variant_slug

  def show
    @variant_slug = params["variant"]
  end

private

  def publication
    @publication ||= begin
      response = GovukGraphQl.transaction(basePath: request.path)
      TransactionGraphqlPresenter.new(response.data.transaction)
    end
  end
end
