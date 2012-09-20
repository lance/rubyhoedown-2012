(ns tweet-grabber.core
  (:require [immutant.messaging :as msg]))

(defn tweet-grabber [dest reader]
  (let [done (atom false)]
    {:start (fn []
              (loop [count 1]
                (when-not @done
                  (msg/publish dest (.readLine reader) :encoding :text)
                  (if (= 0 (rem count 25))
                    (println "tweet-grabber.clj: grabbed" count "tweets"))
                  (Thread/sleep (int (rand 1000)))
                  (recur (inc count)))))
     :stop #(reset! done true)}))


