require 'test_helper'

class QaPagePresenterTest < ActiveSupport::TestCase
  context "the appropriate content item" do
    setup do
      @item = content_store_has_random_item(base_path: '/qa-pages-rock', "content_id" => QaPagePresenter::BREXIT_CHECKER_CONTENT_ID)
      @structured_data = QaPagePresenter.new(@item, "image1.jpg", %(image2.jpg)).structured_data
    end

    should "contain the correct headline" do
      assert_equal @item["title"], @structured_data[:headline]
    end

    should "contain the correct schema types" do
      assert_equal "QAPage", @structured_data[:@type]
      assert_equal "Question", @structured_data[:mainEntity][:@type]
      assert_equal "Answer", @structured_data[:mainEntity][:acceptedAnswer][:@type]
    end

    should "use the text provided for the question and answer" do
      question_text = @structured_data[:mainEntity][:text]
      assert_not_nil question_text
      assert_equal I18n.t("qa_pages.checker.question"), question_text

      answer_text = @structured_data[:mainEntity][:acceptedAnswer][:text]
      assert_not_nil answer_text
      assert_equal I18n.t("qa_pages.checker.answer"), answer_text
    end
  end

  context "other content items" do
    setup do
      @item = content_store_has_random_item(base_path: '/no-qa-page-here')
      @structured_data = QaPagePresenter.new(@item, "image1.jpg", %(image2.jpg)).structured_data
    end

    should "return an empty hash" do
      assert_equal({}, @structured_data)
    end
  end
end
