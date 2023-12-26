use std::collections::{HashSet, HashMap};

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

pub fn part1(input: &str) -> Result<u64> {
    Ok(1)
}

pub fn part2(input: &str) -> Result<u64> {
    let mut lookup_table: HashSet<usize> = HashSet::new();
    let mut our_numbers: HashSet<usize> = HashSet::new();

    let mut copies: HashMap<usize, usize> = HashMap::new();

    for (i, line) in input.lines().enumerate() {
        let actual_index = i + 1;

        match copies.get(&(i + 1)) {
            Some(count) => copies.insert(actual_index, count + 1),
            None => copies.insert(actual_index, 1),
        };

        let mut card_split = line.split(':').skip(1);

        let numbers_body = card_split.next().unwrap();

        let mut numbers_body_split = numbers_body.split('|');

        let winning_numbers = numbers_body_split
            .next()
            .unwrap()
            .split(' ');

        let my_numbers = numbers_body_split
            .next()
            .unwrap()
            .split(' ');

        lookup_table.clear();
        our_numbers.clear();

        // Parsing winning numbers into lookup table
        for win_num in winning_numbers {
            if let Ok(win_num) = win_num.parse::<usize>() {
                lookup_table.insert(win_num);
            }
        }

        // Parsing our numbers
        for num in my_numbers {
            if let Ok(num) = num.parse::<usize>() {
                our_numbers.insert(num);
            }
        }

        let matched_numbers: Vec<&usize> = lookup_table
            .intersection(&our_numbers)
            .collect();

        let copies_of_current_card = copies.get(&(i + 1))
            .unwrap_or(&1);

        for _ in 0..*copies_of_current_card {
            matched_numbers.iter().enumerate().for_each(|(index, _)| {
                let card_copy = (i + 1) + (index + 1);

                match copies.get(&card_copy) {
                    Some(count) => copies.insert(card_copy, count + 1),
                    None => copies.insert(card_copy, 1),
                };
            });
        }


    }

    let sum: usize = copies.values().sum();

    Ok(sum as u64)
}
