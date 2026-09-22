module PostalVoteVideoAbTestable
  ALLOWED_VARIANTS = %w[A B Z].freeze
  POSTAL_VOTE_PATH = "/how-to-vote/postal-voting".freeze

  def self.included(base)
    base.helper_method(
      :current_guide_part_body,
      :postal_vote_video_ab_test_variant,
      :postal_vote_video_page?,
      :show_postal_vote_video?,
    )
    base.after_action :set_postal_vote_video_ab_test_response_header
  end

  def postal_vote_video_ab_test
    @postal_vote_video_ab_test ||= GovukAbTesting::AbTest.new(
      "PostalVoteVideo",
      allowed_variants: ALLOWED_VARIANTS,
    )
  end

  def postal_vote_video_ab_test_variant
    @postal_vote_video_ab_test_variant ||= postal_vote_video_ab_test.requested_variant(request.headers)
  end

  def current_guide_part_body
    return content_item.current_part_body unless hide_postal_vote_video?

    GovspeakYoutubeVideoRemover.new(content_item.current_part_body).remove
  end

  def postal_vote_video_page?
    request.path == POSTAL_VOTE_PATH
  end

  def show_postal_vote_video?
    postal_vote_video_page? && postal_vote_video_ab_test_variant.variant?("B")
  end

private

  def hide_postal_vote_video?
    postal_vote_video_page? && !show_postal_vote_video?
  end

  def set_postal_vote_video_ab_test_response_header
    postal_vote_video_ab_test_variant.configure_response(response) if postal_vote_video_page?
  end
end
