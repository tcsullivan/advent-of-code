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
            (and
              (not (str/starts-with? (second cv) "start"))
              (or
                (< (int (first (second cv))) 96)
                (let [rv (count (filter #(= % (second cv)) klst))
                      lw (filter #(= (str/lower-case %) %) klst)]
                  (or (= 0 rv) (< (- (count lw) (count (distinct lw))) 1)))
                )
              ))
          (search-caves end)
          )))))

(loop [lst (get-caves-forward ["start"]) ms []]
  (println (count ms))
  (let [nxt (->> lst
                 (map get-caves-forward)
                 (apply concat))
        mtchs (concat ms (filter #(= (first %) "end") nxt))
        nxtlst (filter #(not= (first %) "end") nxt)]
    (if (empty? nxtlst)
      (println (count mtchs))
      (recur nxtlst mtchs))))

