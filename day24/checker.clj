(require '[clojure.string :as str])

(defn alu-parse-argument [arg]
  (if (contains? #{\w \x \y \z} (first arg))
    (str/join ["@" arg])
    (read-string arg)))

(defn alu-parse-instruction [[ins arg1 arg2]]
  (let [arg2-parsed (if (some? arg2) (alu-parse-argument arg2) 0)]
    (case ins
      "inp"
      (str/join ["(reset! " arg1 " (- (int (get input (swap! index inc))) 48))\n"])
      "add"
      (str/join ["(swap! " arg1 " +' " arg2-parsed ")\n"])
      "mul"
      (str/join ["(swap! " arg1 " *' " arg2-parsed ")\n"])
      "div"
      (str/join ["(swap! " arg1 " quot " arg2-parsed ")\n"])
      "mod"
      (str/join ["(swap! " arg1 " rem " arg2-parsed ")\n"])
      "eql"
      (str/join ["(swap! " arg1 " #(if (= % " arg2-parsed ") 1 0))\n"]))))

(def alu-program-header
    "(defn alu-program [input]
     (let [index (atom -1) w (atom 0) x (atom 0) y (atom 0) z (atom 0)]\n")

(defn alu-compile-program [instructions]
  (let [parsed-ins (mapv alu-parse-instruction instructions)]
    (eval (read-string
      (str/join [alu-program-header
                 (str/join parsed-ins)
                 "@z))"])))))

(def program (->> (slurp "./in")
                  str/split-lines
                  (map #(str/split % #"\s+"))
                  (alu-compile-program)))

; to split by `inp w`s:
;                  (partition 18)
;                  (reverse)
;                  (mapv alu-compile-program)))

(println "Part 1:" (program "16181111641521"))
(println "Part 2:" (program "59692994994998"))

