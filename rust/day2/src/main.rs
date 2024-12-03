use std::fs;

fn main() {
    let input = fs::read_to_string("../data/day2.txt").unwrap();
    println!("1: {}", solve_1(&input));
    println!("2: {}", solve_2(&input));
}

fn solve_1(s: &String) -> u32 {
    s.lines()
        .filter(|l| {
        let numbers: Vec<u32> = l.split_whitespace().map(|char| char.parse::<u32>().unwrap()).collect();
          return row_is_safe(&numbers)
        })
        .count()
        .try_into()
        .unwrap()
}

fn row_is_safe(numbers: &Vec<u32>) -> bool {
    let mut is_increasing: Option<bool> = None;
    for (n1, n2) in numbers.clone().into_iter().zip(numbers.clone().into_iter().skip(1)) {
        if n1 == n2 {
            return false;
        }

        let difference_abs: u32 = if n1>n2 {n1-n2} else {n2-n1};
        if is_increasing.is_none() {
                is_increasing = Some(n1 < n2);
        }
        if is_increasing.unwrap() && n1 > n2 {
            return false
        }
        if !is_increasing.unwrap() && n1 < n2 {
            return false
        }
        if difference_abs > 3 {
            return false;
        }
    }
    return true;
    
}

fn solve_2(s: &String) -> u32 {
    s.lines()
        .filter(|l| {
            let numbers: Vec<u32> = l.split_whitespace().map(|char| char.parse::<u32>().unwrap()).collect();
            let length = (&numbers).len();
            return row_is_safe(&numbers)
                || (0..length).find(|i| {
                    let other_numbers: Vec<u32> = numbers.clone().into_iter().enumerate().filter(|(j, _)| j!=i).map(|(_, v)| v).collect();
                    return row_is_safe(&other_numbers);
        })
        .is_some()})
        .count()
        .try_into()
        .unwrap()
}

#[cfg(test)]
mod tests {
    use crate::{solve_1, solve_2};


    #[test]
    fn test_solve_1() {
        let test_input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9";
        let result = solve_1(&test_input.to_string());
        assert_eq!(result, 2);
    }

    #[test]
    fn test_solve_2() {
        let test_input = "7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9";
        let result = solve_2(&test_input.to_string());
        assert_eq!(result, 4);
    }
}

