(require '[clojure.string :as str])

(def caves (->> (slurp "./in")
           (str/split-lines)
           (map #(str/split % #"-"))
           (map (partial map str))
           (#(concat % (map reverse %)))
           ))

(def search-caves
  (memoize (fn [id]
    (filter #(= (first %) id) caves))))

(defn get-caves-forward [klst]
  (let [end (first klst)]
    (if (str/starts-with? end "end")
      [klst]
      (map #(cons (second %) klst)
        (filter
          (fn [cv]
            (or (< (int (first (second cv))) 96)
                (not-any? #(= % (second cv)) klst)))
          (search-caves end)
          )))))

(loop [lst (get-caves-forward ["start"]) ms '()]
  (let [nxt (->> lst
                 (map get-caves-forward)
                 (apply concat))
        mtchs  (concat ms (filter #(= (first %) "end") nxt))
        nxtlst (filter #(not= (first %) "end") nxt)]
    (if (empty? nxtlst)
      (println (count mtchs))
      (recur nxtlst mtchs))))

