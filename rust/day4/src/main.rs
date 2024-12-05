use std::fs::read_to_string;

fn main() {
    let input = read_to_string("../data/day4.txt").unwrap();
    let res1 = solve1(&input);
    println!("1: {}", res1);
    let res2 = solve2(&input);
    println!("1: {}", res2);
}

fn solve1(input: &str) -> u32 {
    let lines: Vec<&str> = input.lines().collect();
    let n_lines = lines.len();
    let n_cols = lines[0].len();

    let directions: [(i32,i32); 8] = [
        (0, 1),   // right
        (0, -1),  // left
        (1, 0),   // down
        (-1, 0),  // up
        (1, 1),   // down-right
        (1, -1),  // down-left
        (-1, 1),  // up-right
        (-1, -1), // up-left
    ];

    let lines = &lines;
    (0..n_lines)
	.flat_map(|xi|
	 (0..n_cols).map(move |xj| {
	    let xi = xi as i32;
            let xj = xj as i32;
	    
	    directions.iter()
		.filter(|&(di, dj)| {
		    let coords = (0..4).map(|step| (
			xi + di * step,
			xj + dj * step
		    ));
		    
		    if !coords.clone().all(|(i, j)| 
					   i >= 0 && (i as usize) < n_lines && 
					   j >= 0 && (j as usize) < n_cols
		    ) {
			return false;
		    }
		    
		    let word: String = coords.map(|(i, j)| {
			lines[i as usize].chars().nth(j as usize).unwrap()
		    }).collect();
		    
		    word == "XMAS"
		}).count() as u32
	 }
    )).sum()
}

fn solve2(input: &str) -> u32 {
    let lines: Vec<&str> = input.lines().collect();
    let n_lines = lines.len();
    let n_cols = lines[0].len();

    let lines = &lines;
    (0..n_lines)
	.flat_map(|xi|
		  (0..n_cols).map(move |xj| {
		      let xi = xi as i32;
		      let xj = xj as i32;

		      if lines[xi as usize].chars().nth(xj as usize).unwrap() != 'A' {
			  return 0
		      }

		      let diag1: [(i32, i32);3] = [(-1, -1), (0, 0), (1, 1)].map(|(di, dj)| (xi+di, xj+dj));  
		      if !diag1.into_iter().all(|(i,j)| i >= 0 && (i as usize) < n_lines && 
						j >= 0 && (j as usize) < n_cols) {
			  return 0
		      }
		      
		      let diag2: [(i32, i32);3] = [(1, -1), (0, 0), (-1, 1)].map(|(di, dj)| (xi+di, xj+dj));  
		      if !diag2.into_iter().all(|(i,j)| i >= 0 && (i as usize) < n_lines && 
						j >= 0 && (j as usize) < n_cols) {
			  return 0
		      }

		      let word1: String = diag1.into_iter().map(|(i,j)| lines[i as usize].chars().nth(j as usize).unwrap()).collect();
		      let word2: String = diag2.into_iter().map(|(i,j)| lines[i as usize].chars().nth(j as usize).unwrap()).collect();
		      ((word1 == "MAS" || word1 == "SAM") && (word2 == "MAS" || word2 == "SAM")) as u32
		  }
		  )).sum()
}

#[cfg(test)]
mod tests {
    use crate::{solve1, solve2};

    #[test]
    fn test_solve_1() {
	let input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX";
	let result = solve1(&input);
	assert_eq!(result, 18);
    }

    #[test]
    fn test_solve_2() {
	let input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX";
	let result = solve2(&input);
	assert_eq!(result, 9);
    }
}
