(require '[clojure.string :as str])

(println
  (->> "./in"
       (slurp)
       (str/split-lines)
       (map (fn [l] (map #(if (= % \1) 1 0) l)))
       (apply (partial map +))
       (map #(if (< % 500) \1 \0))
       (str/join)
       (#(Integer/parseInt % 2))
       (#(* % (bit-xor % (dec (int (Math/pow 2 12))))))
       )
  )

; (->> input data file name
;      read in entire contents
;      split contents into array of lines
;      for each line, transform characters '1'/'0' to numbers
;      build sum array using the lines
;      convert back to array of characters
;      join characters into single string
;      convert binary string to a number (gamma)
;      multiply gamma by its bit-inverse (bit length hard-coded)

