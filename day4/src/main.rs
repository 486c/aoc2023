use std::{fs::File, io::{BufReader, BufRead}, collections::{HashSet, HashMap}};

use eyre::Result;

fn main() -> Result<()> {
    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);

    let mut lookup_table: HashSet<usize> = HashSet::new();
    let mut our_numbers: HashSet<usize> = HashSet::new();

    let mut copies: HashMap<usize, usize> = HashMap::new();

    for (i, line) in reader.lines().enumerate() {
        let line = line?;
        let actual_index = i + 1;
        println!("Card {}", actual_index);

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

    println!("Sum: {sum}");

    Ok(())
}
