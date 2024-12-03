(ns day3)

(def test-input
  "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")

(def final-input
  (slurp "../data/day3.txt"))

(defn solve1
  [^String input]
  (->> input
       (re-seq #"mul\((\d+),(\d+)\)")
       (map rest)
       (map (fn [vs] (let [numbers (map parse-long vs)]
                       (apply * numbers))))
       (reduce +)))

(solve1 test-input)
;; => 161

(solve1 final-input)
;; => 170807108

(defn parse-command
  [[full-match param1 param2]]
  (let [command (second (re-find #"(.+)\(" full-match))]
    (-> {:command command}
        (cond-> (= "mul" command)
          (assoc :value (* (parse-long param1) (parse-long param2)))))))

(defn solve2
  [^String input]
  (let [commands (re-seq #"(mul\((\d+),(\d+)\)|do\(\)|don't\(\))" input)]
    (->> commands
         (map (comp parse-command rest))
         (reduce (fn [{:keys [result do?]}
                      {:keys [command value]}]
                   (case command
                     "do"    {:result result
                              :do?    true}
                     "don't" {:result result
                              :do?    false}
                     "mul"   {:result (if do? (+ result value) result)
                              :do?    do?}))
                 {:result 0
                  :do?    true})
         :result)))

(def test-input2
  "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")

(solve2 test-input2)
;; => 48

(solve2 final-input)
;; => 74838033

(defn -main
  []
  (println "1:" (solve1 final-input))
  (println "2:" (solve2 final-input)))

(-main)
