class TransactionPresenter

  def initialize(transaction)
    @transaction = transaction
  end

  def multiple_more_information_sections?
    num_sections = [:before_you_start?, :what_you_need_to_know?, :other_ways_to_apply?].count {|s| self.send(s) }
    num_sections > 1
  end

  def before_you_start?
    @transaction.more_information.present?
  end

  def what_you_need_to_know?
    @transaction.need_to_know.present?
  end

  def other_ways_to_apply?
    @transaction.alternate_methods.present?
  end

  def open_in_new_window?
    self.class.new_window_transactions.include? @transaction.slug
  end

  # attr_accessor stuff to allow overriding the data file in tests
  @new_window_transactions_file = Rails.root.join('lib','data','new_window_transactions.json')
  class << self
    attr_reader :new_window_transactions_file
  end
  def self.new_window_transactions_file=(file)
    @new_window_transactions_file = file
    @new_window_transactions = nil
  end

  def self.new_window_transactions
    @new_window_transactions ||= JSON.parse( File.read( @new_window_transactions_file ) )["new-window"]
  end
end
