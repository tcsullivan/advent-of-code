(def input-map
  (->> (slurp "./in")
       (clojure.string/split-lines)
       (mapv vec)
       (mapv (partial mapv #(- (int %) 48)))
       ))

(defn basin-bottom-single? [a b]
  (if (or (nil? a) (nil? b) (< a b)) 1 0))

(defn basin-continues? [a b]
  (and (some? b) (not= b 9) (> b a)))

(defn basin-bottom? [hmap p adj]
  (= 4
    (apply +
      (map
        #(basin-bottom-single?
           (get-in hmap p)
           (get-in hmap %))
        adj
        ))))

(defn get-adj [y x]
  [[(dec y) x]
   [(inc y) x]
   [y (dec x)]
   [y (inc x)]])

(defn find-basin [hmap y x adj]
  (let [res (reduce
              #(if
                   (basin-continues? (get-in hmap [y x])
                                     (get-in hmap %2))
                 (conj %1 %2)
                 %1)
              []
              adj
              )]
    (if (empty? res)
      []
      (apply
        (partial concat res)
        (map
          #(find-basin hmap (first %) (second %) (apply get-adj %))
          res))
      )
    )
  )

(println
  (apply *
    (take 3
      (sort >
        (filter
          pos?
            (for [y (range 0 (count input-map))
                   x (range 0 (count (first input-map)))]
              (let [adj (get-adj y x)]
                (if (basin-bottom? input-map [y x] adj)
                  (count (distinct (concat [[y x]] (find-basin input-map y x adj))))
                  0
                  ))))))))

