use std::collections::HashMap;

use eyre::Result;

pub fn run(input: &str) -> u64 {

    let p2 = part2(input).unwrap();

    p2
}

pub fn run_debug(input: &str) -> (u64, u64) {
    let p1 = part1(input).unwrap();
    let p2 = part2(input).unwrap();

    (p1, p2)
}

#[derive(Debug)]
struct LastFirst {
    first: u64,
    last: u64,
}

impl LastFirst {
    pub fn new() -> Self {
        Self {
            first: 0,
            last: 0,
        }
    }

    pub fn add_num(&mut self, num: u64) {
        if self.first == 0 {
            self.first = num
        } else {
            self.last = num
        }
    }

    pub fn produce_final_number(&self) -> u64 {
        let mut num = self.first;

        if self.last == 0 {
            num = (num * 10) + self.first;
        } else {
            num = (num * 10) + self.last;
        }

        num
    }

    pub fn clear(&mut self) {
        self.first = 0;
        self.last = 0;
    }
}

pub fn part1(input: &str) -> Result<u64> {
    let mut first_last = LastFirst::new();
    let mut sum = 0;

    for line in input.lines() {
        first_last.clear();
        let chars = line.chars();

        for c in chars {
            if let Some(n) = c.to_digit(10) {
                first_last.add_num(n as u64);
            } else {
                continue
            }
        }
        
        sum += first_last.produce_final_number();
    }

    Ok(sum)
}

pub fn part2(input: &str) -> Result<u64> {
    let cmp_map = [
        ("one", 1),
        ("two", 2),
        ("three", 3),
        ("four", 4),
        ("five", 5),
        ("six", 6),
        ("seven", 7),
        ("eight", 8),
        ("nine", 9),
    ];

    let mut last_first = LastFirst::new();
    let mut sum = 0;
    
    for line in input.lines() {
        let mut cursor = 0;
        last_first.clear();

        'main: while line.len() != cursor {
            let line = &line[cursor..line.len()];

            for (k, v) in cmp_map.iter() {
                if line.starts_with(k) {
                    last_first.add_num(*v);
                    cursor += k.len() - 1;
                    continue 'main;
                }
            }

            let char = &line.chars().next().unwrap();

            if let Some(n) = char.to_digit(10) {
                last_first.add_num(n as u64);
            }

            cursor += 1;
        }    

        sum += last_first.produce_final_number();
    }

    Ok(sum)
}
