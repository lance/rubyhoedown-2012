(ns tweet-grabber.init
  (:require [immutant.daemons   :as daemon]
            [immutant.utilities :as util]
            [tweet-grabber.core :as core]
            [clojure.java.io    :as io]))

(let [daemon (core/tweet-grabber
              "/queue/tweets"
              (io/reader (io/file (util/app-root) "tweets")))]

  (println "*************** Starting tweet-grabber daemon from clojure **************")
  (daemon/start "tweet-grabber"
                (:start daemon)
                (:stop daemon)))


