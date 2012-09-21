TorqueBox.configure do

  job RandomIdeaSender do
    cron '*/10 * * * * ?'
  end

  #service TweetGrabber do
    #config do
      #search_terms %w{billsidea}
      #queue_name "/queue/tweets"
    #end
  #end
  
  queue "/queue/tweets" do
    processor TweetAnalyzer do
      config do
        queue_name "/queue/analyzed-tweets"
      end
    end
  end
  
  queue "/queue/analyzed-tweets"

  stomplet TweetStomplet do
    route '/stomplet/tweets'
    config do
      queue_name '/queue/analyzed-tweets'
    end
  end
  
end
