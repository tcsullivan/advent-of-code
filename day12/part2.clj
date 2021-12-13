(require '[clojure.string :as str])
(require '[clojure.core.reducers :as r])

; Build list of cave connections:
(def caves (->> (slurp "./in")
           (str/split-lines)
           (map #(str/split % #"-"))
           (map (partial map str))
           (#(concat % (map reverse %)))
           ))

; Try to help execution speed by memoizing cave searches:
(def search-caves
  (memoize (fn [id]
    (filter
      #(and (= (first %) id)
            (not (str/starts-with? (second %) "start")))
      caves
      ))))

; Given current path 'path', return a list of valid paths that branch
; from 'path'. Note, paths are stored in reverse order.
(defn get-caves-forward [path]
  (r/map #(cons (second %) path)
    (r/filter
      (fn [cv]
        (or
          ; Always allow uppercase paths
          (< (int (first (second cv))) 96)
          ; Or, allow lowercase paths that have never been visited
          (not-any? #(= % (second cv)) path)
          ; Or, allow one duplicate if there are none yet
          (apply distinct? (filter #(= (str/lower-case %) %) path))))
      ; Only work with paths that we connect to
      (search-caves (first path))
      )))

(loop [paths (into [] (get-caves-forward ["start"])) complete-paths 0]
  (let [results (->> paths
                     (r/mapcat get-caves-forward)
                     (r/foldcat)
                     (r/reduce
                       (fn [r b] (if (not= (first b) "end")
                                   (update r :next-paths #(conj % b))
                                   (update r :complete-counts inc)))
                       {:next-paths [] :complete-counts complete-paths}))]
    (println (results :complete-counts))
    (when-not (empty? (results :next-paths))
      (recur (results :next-paths) (results :complete-counts)))))

