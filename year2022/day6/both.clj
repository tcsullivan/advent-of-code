(defn find-marker [data n]
  (->> data
       (partition n 1)
       (map #(apply distinct? %))
       (take-while false?)
       (#(+ n (count %)))))

(let [data (slurp "input")]
    (doseq [ind [4 14]]
      (println (find-marker data ind))))
