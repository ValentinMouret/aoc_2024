use std::fs::read_to_string;

use regex::Regex;

fn main() {
    println!("Hello, world!");
    let input = read_to_string("../data/day3.txt").unwrap();
    let commands = parse_commands(&input);

    let res1 = solve_1(&commands);
    println!("1: {}", res1);

    let res2 = solve_2(&commands);
    println!("2: {}", res2);
}

#[derive(Clone, Debug)]
enum Command {
    Do,
    Dont,
    Mul{ a: u32, b: u32},
}

fn parse_commands(input: &String) -> Vec<Command> {
    let re = Regex::new(r"(mul\((\d+),(\d+)\)|do\(\)|don't\(\))").unwrap();
    re.captures_iter(input).map(|cap| {
        let command = cap.get(1).unwrap().as_str();
        if command.starts_with("mul") {
            Command::Mul {
                a: cap[2].parse().unwrap(),
                b: cap[3].parse().unwrap(),
            }
        } else if command == "do()" {
            Command::Do
        } else {
            Command::Dont
        }
    }).collect()
}

fn solve_1(commands: &Vec<Command>) -> u32 {
    commands
	.into_iter()
	.filter_map(|command| match command {
	    Command::Mul { a, b } => Some(a*b),
	    _=>None
	})
	.sum()
}

fn solve_2(commands: &Vec<Command>) -> u32 {
    commands
	.into_iter()
	.fold((0, true),
	      |(res, is_do), command| {
		  match command {
		      Command::Do => (res, true),
		      Command::Dont => (res, false),
		      Command::Mul { a, b } => {
			  let delta = if is_do { a * b} else { 0 };
			  (res + delta , is_do)
		      }
		  }
	      })
	.0
	.try_into()
	.unwrap()
}

#[cfg(test)]
mod tests {
    use crate::{parse_commands, solve_1, solve_2};

    #[test]
    fn test_solve1() {
	let test_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))".to_string();
	let commands = parse_commands(&test_input);
	let result = solve_1(&commands);
	assert_eq!(result, 161);
    }

    #[test]
    fn test_solve2() {
	let test_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))".to_string();
	let commands = parse_commands(&test_input);
	let result = solve_2(&commands);
	assert_eq!(result, 48);
    }
}
