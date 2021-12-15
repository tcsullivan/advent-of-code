(require 'clojure.set)

(defn find-sum [sum lst]
  (->> lst
       ((juxt set (comp set #(map (partial - sum) %))))
       (apply clojure.set/intersection)
       (vec)))

(->> (slurp "./in")
     clojure.string/split-lines
     ((comp set (partial map read-string)))
     ((fn [lst]
       (reduce
         #(let [fnd (find-sum (- 2020 %2) (clojure.set/difference lst #{%2}))]
            (if (empty? fnd) %1 [%2 fnd]))
         []
         lst)))
     flatten
     (apply *)
     (println))
