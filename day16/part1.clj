(require '[clojure.string :as str])
(require '[clojure.set :as set])

(def hex-lookup
  {\0 "0000" \1 "0001" \2 "0010" \3 "0011"
   \4 "0100" \5 "0101" \6 "0110" \7 "0111"
   \8 "1000" \9 "1001" \A "1010" \B "1011"
   \C "1100" \D "1101" \E "1110" \F "1111"})

(defn binary-to-num [binstr]
  (reduce
    #(cond-> %1 true (* 2) (= \1 %2) inc)
    0
    binstr))

(defn take-packet-version [packet]
  (-> (split-at 3 packet)
      (update 0 binary-to-num)))

(defn take-literal-value [packet]
  (let [[tid data] (split-at 3 packet)]
    (when (= '(\1 \0 \0) tid)
      (let [sd   (into [] data)
            spl  (split-with #(= \1 (first %)) (partition 5 sd))
            nums (map rest (concat (first spl) (take 1 (second spl))))]
        [(binary-to-num (reduce concat nums))
         (drop (* 5 (inc (count (first spl)))) sd)]
        ))))

(defn take-operator [packet]
  (let [id (first packet) ps (str/join (rest packet))]
    (if (= \0 id)
      (let [bits (binary-to-num (subs ps 0 15))]
        [(subs ps 15) bits :bits])
      (let [pkts (binary-to-num (subs ps 0 11))]
        [(subs ps 11) pkts :pkts]))))

(defn process-packet [[input vcnt]]
  (let [[version data] (take-packet-version input)]
    (if (every? #(= \0 %) data)
      ['() vcnt]
      (do
        (println "Version:          " version)
        (if-let [value (take-literal-value data)]
          (do
            (println "Value:" (first value))
            [(second value) (+ vcnt version)])
          (do
            (let [info (take-operator (drop 3 data))]
              (println "Subpacket:")
              (if (= :bits (get info 2))
                (loop [inpt [(subs (first info) 0 (get info 1)) (+ vcnt version)]]
                  (if (empty? (first inpt))
                    [(subs (first info) (get info 1)) (second inpt)]
                    (recur (process-packet inpt))))
                (loop [n (get info 1) inpt [(get info 0) (+ vcnt version)]]
                  (if (pos? n)
                    (recur (dec n) (process-packet inpt))
                    inpt))))))))))

(loop [packet (->> (slurp "./in")
                   (map hex-lookup)
                   (take-while some?)
                   (reduce concat)
                   (str/join)
                   (#(vector % 0))
                   (process-packet))]
  (if (not (empty? (first packet)))
    (recur (process-packet packet))
    (println packet)))

