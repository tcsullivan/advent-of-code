(require '[clojure.string :as str])

(def caves (->> (slurp "./in")
           (str/split-lines)
           (map #(str/split % #"-"))
           (map (partial map str))
           (#(concat % (map reverse %)))
           ))

(defn get-caves-forward [klst]
  (map #(cons (second %) klst)
    (filter
      #(or (< (int (first (second %))) 96)
           (not-any? (partial = (second %)) klst))
      (filter #(= (first %) (first klst)) caves)
      )))

(loop [lst (get-caves-forward ["start"]) ms '()]
  (let [nxt (->> lst
                 (map get-caves-forward)
                 (apply concat))
        mtchs  (concat ms (filter #(= (first %) "end") nxt))
        nxtlst (filter #(not= (first %) "end") nxt)]
    (if (empty? nxtlst)
      (println (count mtchs))
      (recur nxtlst mtchs))))

