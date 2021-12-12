    (require '[clojure.string :as str])
    
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
        (filter #(= (first %) id) caves))))
    
    ; Given current path 'path', return a list of valid paths that branch
    ; from 'path'. Note, paths are stored in reverse order.
    (defn get-caves-forward [path]
      (map #(cons (second %) path)
        (filter
          (fn [cv]
            (and
              ; Do not return to start
              (not (str/starts-with? (second cv) "start"))
              (or
                ; Always allow uppercase paths
                (< (int (first (second cv))) 96)
                (let [lw (filter #(= (str/lower-case %) %) path)]
                  (or
                    ; Allow lowercase paths that have never been visited
                    (= 0 (count (filter #(= % (second cv)) path)))
                    ; Allow one duplicate if there are none yet
                    (= 0 (- (count lw) (count (distinct lw)))))))))
          ; Only work with paths that we connect to
          (search-caves (first path))
          )))
    
    (loop [paths (get-caves-forward ["start"]) complete-paths []]
      (let [branches          (->> paths
                                   (map get-caves-forward)
                                   (apply concat))
            complete-branches (concat complete-paths
                                      (filter #(= (first %) "end") branches))
            next-paths        (filter #(not= (first %) "end") branches)]
        (if (empty? next-paths)
          (println (count complete-branches))
          (recur next-paths complete-branches))))
    
