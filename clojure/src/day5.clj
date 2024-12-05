(ns day5
  (:require [clojure.string :as str]
            [clojure.math :as math]))

(def test-input
  "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47")

(def final-input (slurp "../data/day5.txt"))

(defn row-ordered?
  "Asserts the validity of a row based on part1’s predicate.

  row: sequence of numbers
  numbers-after: map of number to all the numbers that should be smaller

  A row is valid if, for all the numbers it contains, the clauses that are
  associated to it are valid."
  [row numbers-after]
  (if (seq row)
    (let [it      (first row)
          clauses (get numbers-after it #{})]
      (and (every? clauses (rest row))
           (row-ordered? (rest row) numbers-after)))
    true))

(defn parse-problem
  [^String input]
  (let [[orders updates] (str/split input #"\R\R")
        orders           (->> orders
                              (re-seq #"(\d+)\|(\d+)")
                              (map (fn parse [[_ n1 n2]]
                                     [(parse-long n1) (parse-long n2)])))
        updates          (->> (str/split-lines updates)
                              (map (fn parse [l]
                                     (->> (str/split l #",")
                                          (map parse-long)))))
        numbers-after   (->> orders
                             (group-by first)
                             (map (fn [[num vs]] [num (->> vs (map second) (into #{}))]))
                             (into {}))]
    [updates numbers-after]))

(defn get-middle-element
  [coll]
  (let [index (quot (count coll) 2)]
    (nth coll index)))

(defn solve-1
  [^String input]
  (let [[updates numbers-after] (parse-problem input)]
    (->> updates
         (filter #(row-ordered? % numbers-after))
         (map get-middle-element)
         (reduce +))))

(defn sort-pages
  "Implement a sort of bubble sort."
  [row numbers-after]
  (if (seq row)
    (let [it      (first row)
          clauses (get numbers-after it #{})
          {:keys [before after]} (group-by (fn [n] (if (clauses n) :after :before)) (rest row))]
      (concat (or before [])
              [it]
              (sort-pages (or after []) numbers-after)))
    []))

(defn sort-until-sorted
  [row numbers-after]
  (loop [current row]
    (if-not (row-ordered? current numbers-after)
      (recur (sort-pages current numbers-after))
      current)))

(defn solve-2
  [^String input]
  (let [[updates numbers-after] (parse-problem input)
        invalid-rows            (filter #((complement row-ordered?) % numbers-after) updates)
        fixed                   (map #(sort-until-sorted % numbers-after) invalid-rows)]

    (->> fixed
         (map get-middle-element)
         (reduce +))))

(solve-1 test-input)
;; => 143

(solve-1 final-input)
;; => 5948

(solve-2 test-input)
;; => 123

(solve-2 final-input)
;; => 3062
