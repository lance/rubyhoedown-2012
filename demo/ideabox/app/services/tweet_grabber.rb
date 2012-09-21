
class TweetGrabber

  def initialize(options)
    @search_terms = options['search_terms']
    @queue = TorqueBox::Messaging::Queue.new(options['queue_name'])
  end

  def start
    puts "******************** Starting TweetGrabber ********************"
    Thread.new do
      each_tweet do |tweet|
        break if @done
        @queue.publish(tweet, :encoding => :text)
      end
    end
  end

  def stop
    @done = true
  end







  protected

  def each_tweet
    tweet_count = 0
    IO.readlines(ENV['RAILS_ROOT'] + '/tweets').each do |tweet|
      yield tweet
      puts "TweetGrabber: grabbed #{tweet_count} tweets" if (tweet_count += 1) % 25 == 0
      sleep(rand)
    end
  end

end
