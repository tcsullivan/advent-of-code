(require '[clojure.string :as str])

(->> (str/split-lines (slurp "./in"))
     (map
       (fn [line]
         (as-> line $
           (str/split $ #" ")
           (subvec $ 11 15)
           (filter #(.contains [2 3 4 7] (count %)) $)
           (count $)
           )))
     (apply +)
     (println)
     )

