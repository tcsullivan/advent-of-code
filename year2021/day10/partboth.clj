(def to-closing {\{ \} \( \) \[ \] \< \>})
(def to-score {\) 3 \] 57 \} 1197 \> 25137})
(def to-score2 {\) 1 \] 2 \} 3 \> 4})

(defn check-line [input]
  (loop [in input open '()]
    (if-let [c (first in)]
      (if (some->> (#{\} \) \] \>} c) (not= (first open)))
        c
        (recur
          (rest in)
          (if-let [op (to-closing c)]
            (conj open op)
            (rest open)
            )))
      open
      )))

(->> (slurp "./in")
     (clojure.string/split-lines)
     (map (comp check-line vec))
     ; check-line returns first invalid character, or list of characters
     ; necessary to close the line. Work through these through `reduce`
     ; and build the answers for both parts:
     (reduce
       (fn [tots nxt]
         (if (seq? nxt)
           (update tots 1 #(conj % (reduce (fn [a b] (+ (* 5 a) (to-score2 b))) 0 nxt)))
           (update tots 0 #(+ % (to-score nxt)))))
       [0 '()])
     ; Get part 2 answer from the list of scores:
     (#(update % 1 (fn [ns] (nth ns (quot (count ns) 2)))))
     (println))

