(def to-closing {\{ \} \( \) \[ \] \< \>})
(def to-score {\) 1 \] 2 \} 3 \> 4})

(defn check-line [input]
  (loop [in input open '()]
    (cond
      (empty? in)
      (map to-closing open)
      (and (contains? #{\} \) \] \>} (first in))
           (not= (to-closing (first open)) (first in)))
      nil
      :else
      (recur
        (rest in)
        (if (contains? #{\{ \( \[ \<} (first in))
          (conj open (first in))
          (rest open)
          )))))

(->> (slurp "./in")
     (clojure.string/split-lines)
     (map (comp check-line vec))
     (filter some?)
     (map (partial reduce #(+ (* 5 %1) (to-score %2)) 0))
     (sort)
     (#(nth % (quot (count %) 2)))
     (println))

