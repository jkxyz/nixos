(require
 '[clojure.core.async :as async]
 '[clojure.string :as string]
 '[clojure.java.shell :as shell]
 '[cheshire.core :as json]
 '[babashka.process :as process])

(def header {:version 1})

(println (json/generate-string header))

(println "[")

(-> (Runtime/getRuntime)
    (.addShutdownHook (Thread. #(println "\n]"))))

(def date-time-formatter
  (java.time.format.DateTimeFormatter/ofPattern "EEE dd MMM HH:mm"))

(defn jc [parser cmd]
  (-> (process/process cmd)
      (process/process ["jc" (str "--" (name parser))])
      :out
      (slurp)
      (json/parse-string true)))

(defn clock []
  (let [now (java.time.ZonedDateTime/now)]
    {:full_text (.format now date-time-formatter)}))

(defn battery []
  (let [info (first (jc :upower ["upower" "--show-info" "/org/freedesktop/UPower/devices/battery_BAT0"]))
        percentage (get-in info [:detail :percentage])]
    (cond-> {:full_text (str "Battery: " (Math/round percentage) "%")}
      (<= percentage 25)
      (assoc :urgent true))))

(defn non-blank [s]
  (when-not (string/blank? s)
    s))

(def wifi-device "wlp0s20f3")

(defn get-wifi-connection []
  (-> (:out (process/sh ["nmcli" "--terse" "--fields" "GENERAL.CONNECTION" "device" "show" wifi-device]))
      (string/trim)
      (subs (count "GENERAL.CONNECTION:"))
      (non-blank)))

(defn wifi []
  (when-let [connection (get-wifi-connection)]
    {:full_text (str "WiFi: " connection)}))

(def system-stats (atom nil))

(async/go-loop []
  (let [vmstat (last (jc :vmstat ["vmstat" "--unit" "M" "1" "2"]))]
    (reset! system-stats
            {:cpu-usage (- 100 (:idle_time vmstat))
             :free-mem (:free_mem vmstat)}))
  (async/<! (async/timeout 1000))
  (recur))

(defn disk []
  (let [root (first (filter #(= (:filesystem %) "/dev/vg/root") (jc :df ["df" "--human-readable"])))]
    {:full_text (str "Disk: " (:used root) "/" (:size root))}))

(defn cpu []
  (when-let [usage (:cpu-usage @system-stats)]
    {:full_text (str "CPU: " usage "%")}))

(defn memory []
  (when-let [free (:free-mem @system-stats)]
    {:full_text (str "Memory: " free "M free")}))

(defn status-blocks []
  (filter some? [(disk) (cpu) (memory) (wifi) (battery) (clock)]))

(print (json/generate-string (status-blocks)))

(loop []
  (println ",")
  (print (json/generate-string (status-blocks)))
  (Thread/sleep 1000)
  (recur))
