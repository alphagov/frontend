class TransactionPresenter

  cattr_accessor :new_window_transactions

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
    @transaction.minutes_to_complete.present? || @transaction.expectations.any?
  end

  def other_ways_to_apply?
    @transaction.alternate_methods.present?
  end

  def open_in_new_window?
    self.class.load_new_window_transactions unless self.class.new_window_transactions
    self.class.new_window_transactions.include? @transaction.slug
  end

  def self.load_new_window_transactions
    self.new_window_transactions = JSON.parse( File.open( Rails.root.join('lib', 'data', 'new_window_transactions.json') ).read )
  end
end
