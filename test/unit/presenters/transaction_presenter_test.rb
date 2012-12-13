require_relative '../../test_helper'

class TransactionPresenterTest < ActiveSupport::TestCase

  setup do
    @transaction = stub()
    @presenter = TransactionPresenter.new(@transaction)
  end

  context "multiple_more_information_sections?" do
    setup do
      @presenter.stubs(:before_you_start?).returns(false)
      @presenter.stubs(:what_you_need_to_know?).returns(false)
      @presenter.stubs(:other_ways_to_apply?).returns(false)
    end

    should "be false with no sections" do
      assert ! @presenter.multiple_more_information_sections?
    end

    should "be false with only one section" do
      @presenter.stubs(:before_you_start?).returns(true)
      assert ! @presenter.multiple_more_information_sections?

      @presenter.stubs(:before_you_start?).returns(false)
      @presenter.stubs(:what_you_need_to_know?).returns(true)
      assert ! @presenter.multiple_more_information_sections?

      @presenter.stubs(:what_you_need_to_know?).returns(false)
      @presenter.stubs(:other_ways_to_apply?).returns(true)
      assert ! @presenter.multiple_more_information_sections?
    end

    should "be true otherwise" do
      @presenter.stubs(:before_you_start?).returns(true)
      @presenter.stubs(:what_you_need_to_know?).returns(true)
      assert @presenter.multiple_more_information_sections?

      @presenter.stubs(:what_you_need_to_know?).returns(false)
      @presenter.stubs(:other_ways_to_apply?).returns(true)
      assert @presenter.multiple_more_information_sections?

      @presenter.stubs(:what_you_need_to_know?).returns(true)
      assert @presenter.multiple_more_information_sections?
    end
  end

  context "before_you_start?" do

    should "be true if transaction has more information" do
      @transaction.stubs(:more_information).returns("Something")
      assert @presenter.before_you_start?
    end

    should "be false otherwise" do
      @transaction.stubs(:more_information).returns("")
      assert ! @presenter.before_you_start?
    end
  end

  context "what_you_need_to_know?" do
    setup do
      @transaction.stubs(:minutes_to_complete).returns("")
      @transaction.stubs(:expectations).returns([])
    end

    should "be true if transaction has any expectations" do
      @transaction.stubs(:expectations).returns(["something"])
      assert @presenter.what_you_need_to_know?
    end

    should "be true if transaction has specified minutes to complete" do
      @transaction.stubs(:minutes_to_complete).returns("10")
      assert @presenter.what_you_need_to_know?
    end

    should "be false otherwise" do
      assert ! @presenter.what_you_need_to_know?
    end
  end

  context "other_ways_to_apply?" do
    should "be true if transaction has alternate methods" do
      @transaction.stubs(:alternate_methods).returns("Something")
      assert @presenter.other_ways_to_apply?
    end

    should "be false otherwise" do
      @transaction.stubs(:alternate_methods).returns("")
      assert ! @presenter.other_ways_to_apply?
    end
  end

  context "new window transactions" do
    should "use the new window transaction list in lib/data by default" do
      presenter = TransactionPresenter.new(@transaction)
      pathname = Rails.root.join('lib','data','new_window_transactions.json')

      assert_equal pathname, presenter.new_window_transactions_file
    end

    context "given a list of new window transactions" do
      setup do
        @presenter.new_window_transactions_file = Rails.root.join('test','fixtures','new-window-transactions.json')
      end

      context "new window transactions" do
        should "load new window transactions from file" do
          expected_transactions = [
            "car-tax-disc-vehicle-licence",
            "register-login-student-finance",
            "find-your-local-council",
            "book-practical-driving-test",
            "example-slug-one"
          ]

          assert_equal expected_transactions, @presenter.new_window_transactions
        end

        should "load transaction in new window if slug is in list" do
          @transaction.stubs(:slug).returns("example-slug-one")
          assert @presenter.open_in_new_window?
        end

        should "not load transaction in new window if slug is not in list" do
          @transaction.stubs(:slug).returns("example-slug-two")
          assert ! @presenter.open_in_new_window?
        end
      end

      context "restricted window transactions" do
        should "load restricted window transactions from file" do
          expected_transactions = [ "restricted-window-example" ]

          assert_equal expected_transactions, @presenter.restricted_window_transactions
        end

        should "load transaction in new window if slug is in list" do
          @transaction.stubs(:slug).returns("restricted-window-example")
          assert @presenter.open_in_restricted_window?
        end

        should "not load transaction in new window if slug is not in list" do
          @transaction.stubs(:slug).returns("example-slug-two")
          assert ! @presenter.open_in_restricted_window?
        end
      end
    end
  end
end
