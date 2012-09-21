require 'json'

class TweetAnalyzer < TorqueBox::Messaging::MessageProcessor

  def initialize(options)
    @queue = TorqueBox::Messaging::Queue.new(options['queue_name'])
    @cache = TorqueBox::Infinispan::Cache.new(:name => 'proc-cache', :mode => :replicated)
  end

  def on_message(message)
    TorqueBox.transaction do
      @queue.publish(score_message(message), :encoding => :text)
      if (count = @cache.increment('proc-count')) % 5 == 0
        puts "TweetAnalyzer: analyzed #{count} tweets"
      end
    end
  end








  protected 

  def score_message(message)
    message = JSON.parse(message)    
    message['score'] = WEIGHTED_TERMS.inject(10) do |score, (term, weight)|
      score + (message['text'] =~ /#{term}/i ? weight : 0)
    end
    message.to_json
  end
    
  WEIGHTED_TERMS ||= {
    "love" => 2,
    "marry" => 3,
    "@justinbieber" => 5,
    "gomez|selena" => 1,
    "belieber" => 1,
    "hate" => -4
  }

end
