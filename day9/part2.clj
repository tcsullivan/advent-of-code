(def input-map
  (->> (slurp "./in")
       (clojure.string/split-lines)
       (mapv vec)
       (mapv (partial mapv #(- (int %) 48)))
       ))

(defn get-adj 
  "Gets vector of coords surrounding (x, y)."
  [y x] [[(dec y) x] [(inc y) x] [y (dec x)] [y (inc x)]])

(defn basin-continues? 
  "Determines if `b` is a continuation of the basin that includes `a`."
  [a b]
  (and (some? b) (not= b 9) (> b a)))

(defn basin-bottom?
  "Determines if point `p` in `hmap` is the bottom of a basin surrounded by
   points `adj`."
  [hmap p adj]
  (empty?
    (filter
      #(let [q (get-in hmap %)] (and (some? q) (> (get-in hmap p) q)))
      adj
      )))

(defn find-basin
  "If point `yx` in `hmap` is in a basin (determined using `adj`), return a
   list of points in the basin that are above `yx`."
  [hmap yx adj]
  (let [res (filter #(basin-continues? (get-in hmap yx)
                                       (get-in hmap %))
                    adj)]
    (if-not (empty? res)
      (apply
        (partial concat res)
        (map
          #(find-basin hmap % (apply get-adj %))
          res
          )))))

(->> (for [y (range 0 (count input-map))
           x (range 0 (count (first input-map)))]
       (let [adj (get-adj y x)]
         (when (basin-bottom? input-map [y x] adj)
           (inc (count (distinct (find-basin input-map [y x] adj))))
           )))
     (filter some?)
     (sort >)
     (take 3)
     (apply *)
     (println)
     )

