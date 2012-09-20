class Idea < ActiveRecord::Base
  attr_accessible :text
  validates_presence_of :text
  default_scope :order => 'created_at desc'

  after_create :post_to_twitter

  def post_to_twitter
    puts "Posting '#{text} #billsidea' to twitter"
    sleep(5)
    puts "Idea posted."
  end

end
