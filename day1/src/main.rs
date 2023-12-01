use std::{fs::File, io::{BufReader, BufRead}, collections::HashMap};

use eyre::Result;

fn main() -> Result<()> {
    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);

    let cmp_map: HashMap<&str, usize> = HashMap::from([
        ("one", 1),
        ("two", 2),
        ("three", 3),
        ("four", 4),
        ("five", 5),
        ("six", 6),
        ("seven", 7),
        ("eight", 8),
        ("nine", 9),
    ]);

    let mut numbers = Vec::new();
    let mut line_numbers = Vec::new();
    
    for line in reader.lines() {
        let line = line?;
        let mut cursor = 0;

        line_numbers.clear();

        'main: while line.len() != cursor {
            let line = &line[cursor..line.len()];

            for (k, v) in cmp_map.iter() {
                if line.starts_with(k) {
                    line_numbers.push(*v);
                    cursor += 1;
                    continue 'main;
                }
            }

            let char = &line.chars().next().unwrap();

            if let Some(n) = char.to_digit(10) {
                line_numbers.push(n as usize);
            }

            cursor += 1;
        }    

        let mut num = line_numbers[0];
        num = (num * 10) + line_numbers.last().unwrap();
        numbers.push(num)
    }

    let sum = numbers.iter().sum::<usize>();

    println!("Sum: {sum}");

    Ok(())
}
