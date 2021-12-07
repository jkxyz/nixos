(require
 '[clojure.string :as string]
 '[clojure.java.shell :as shell]
 '[cheshire.core :as json])

(def header {:version 1})

(println (json/generate-string header))

(println "[")

(-> (Runtime/getRuntime)
    (.addShutdownHook (Thread. #(println "]"))))

(def date-time-formatter
  (java.time.format.DateTimeFormatter/ofPattern "EEE dd MMM HH:mm"))

(defn jc [parser & cmd]
  (-> (:out (shell/sh "jc" (str "--" (name parser)) :in (:out (apply shell/sh cmd))))
      (json/parse-string true)))

(defn clock []
  (let [now (java.time.ZonedDateTime/now)]
    {:full_text (.format now date-time-formatter)}))

(defn battery []
  (let [info (first (jc :upower "upower" "--show-info" "/org/freedesktop/UPower/devices/battery_BAT0"))
        percentage (get-in info [:detail :percentage])]
    (cond-> {:full_text (str "Battery: " (Math/round percentage) "%")}
      (<= percentage 25)
      (assoc :urgent true))))

(while true
  (let [status [(battery) (clock)]]
    (println (str (json/generate-string status) ",")))
  (Thread/sleep 1000))
