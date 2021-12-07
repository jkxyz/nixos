(require
 '[clojure.string :as string]
 '[clojure.java.shell :as shell]
 '[cheshire.core :as json]
 '[babashka.process :as process])

(def header {:version 1})

(println (json/generate-string header))

(println "[")

#_
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

(defn wifi []
  (when-let [name (not-empty (string/trim (:out (process/sh ["nmcli" "-t" "-f" "NAME" "connection" "show" "--active"]))))]
    {:full_text (str "Network: " name)}))

(defn status-blocks []
  (filter identity [(wifi) (battery) (clock)]))

(while true
  (println (str (json/generate-string (status-blocks)) ","))
  (Thread/sleep 1000))
