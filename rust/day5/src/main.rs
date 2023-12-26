use std::{
    fs::File, 
    io::{BufReader, BufRead, Seek, SeekFrom, Lines}, 
    collections::HashMap, ops::Range
};

use rayon::prelude::*;
use eyre::Result;

enum Part {
    First,
    Second
}

#[derive(Debug)]
struct MapRange {
    dest: usize,
    source: usize,
    len: usize,
}

impl MapRange {
    fn map(&self, value: usize) -> Option<usize> {
        if (self.source..=self.source+self.len - 1).contains(&value) {
            let diff = value - self.source;

            Some(self.dest + diff)
        } else {
            None
        }
    }
}

impl From<&str> for MapRange {
    fn from(value: &str) -> Self {
        let mut range = value
            .split(' ')
            .map(|x| x.parse::<usize>())
            .flatten();

        Self {
            dest: range.next().unwrap(),
            source: range.next().unwrap(),
            len: range.next().unwrap()
        }
    }
}

//fn part1(file: File) {
//}

fn parse_seeds(line: &str, part: Part) -> Vec<Range<usize>> {
    // seeds: 79 14 55 13
    let line = &line[7..line.len()];

    let line_seeds: Vec<usize> = line.split(' ')
        .map(|x| x.parse::<usize>())
        .flatten()
        .collect();

    let seeds: Vec<Range<usize>> = match part {
        Part::First => {
            line_seeds
                .into_iter()
                .map(|x| {
                    Range {
                        start: x,
                        end: x
                    }
                })
                .collect()
        },
        Part::Second => {
            line_seeds
                .chunks(2)
                .map(|chk| Range { start: chk[0], end: chk[0] + chk[1] })
                .collect()
        },
    };

    seeds
}

fn parse_stages(lines: &mut Lines<BufReader<File>>) -> Vec<Vec<MapRange>> {
    let mut mapped = Vec::new();

    while let Some(Ok(line)) = &lines.next() {
        if !line.contains("-to-") {
            continue
        };

        // Ranges for current specific map
        let mut ranges = Vec::new();

        while let Some(Ok(line)) = &lines.next() {
            if line.len() == 0 {
                break;
            }
            ranges.push(MapRange::from(line.as_ref()));
        }

        mapped.push(ranges);
    };

    mapped
}

fn find_min(
    seeds_ranges: &[Range<usize>], 
    stages: &[Vec<MapRange>]
) -> usize {
    let mut min = 0;

    seeds_ranges.iter().for_each(|range| {
        (range.start..=range.end).for_each(|num| {
            let mut current_num = num;

            for stage in stages {
                let mut mapped = false;

                for map_range in stage {
                    if let Some(v) = map_range.map(current_num) {
                        mapped = true;
                        current_num = v;
                        break;
                    }
                }

                if !mapped {
                    current_num = current_num;
                }
            }

            if min == 0 {
                min = current_num
            }

            if current_num < min {
                min = current_num
            };
        });
    });


    min
}

fn execute_for_file(path: &str) -> Result<()> {
    println!("===== {path} =====");
    let file = File::open(path)?;
    let reader = BufReader::new(file);

    // Part 1
    let mut lines = reader.lines().into_iter();
    let seeds_line = lines.next().unwrap()?;

    let seeds_ranges_p1 = parse_seeds(
        &seeds_line, Part::First
    );

    let seeds_ranges_p2 = parse_seeds(
        &seeds_line, Part::Second
    );

    let stages = parse_stages(&mut lines);

    println!("Part 1: {}", find_min(&seeds_ranges_p1, &stages));
    println!("Part 2: {}", find_min(&seeds_ranges_p2, &stages));

    Ok(())

}

fn main() -> Result<()> {
    execute_for_file("test.txt")?;
    execute_for_file("input.txt")?;

    Ok(())
}

#[test]
fn test_map_range() {
    let range = MapRange {
        dest: 52,
        source: 50,
        len: 48,
    };

    assert_eq!(range.map(79), Some(81));

    let range = MapRange {
        dest: 50,
        source: 98,
        len: 2,
    };

    assert_eq!(range.map(98), Some(50));
    assert_eq!(range.map(99), Some(51));
    assert_eq!(range.map(100), None);

    let range = MapRange {
        dest: 50,
        source: 98,
        len: 1,
    };

    assert_eq!(range.map(98), Some(50));
    assert_eq!(range.map(99), None);
}

#[test]
fn test_parse_seeds() {
    let line = "seeds: 79 14 55 13";

    let ranges = parse_seeds(&line, Part::First);
    assert_eq!(ranges.len(), 4);

    let ranges = parse_seeds(&line, Part::Second);
    assert_eq!(ranges.len(), 2);
}
