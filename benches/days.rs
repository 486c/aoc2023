use divan::{black_box, Bencher};

fn main() {
    divan::main();
}

mod day1 {
    use divan::{black_box, Bencher};
    use std::fs::File;
    use std::io::Read;

    #[divan::bench]
    fn part1(bencher: divan::Bencher) {
        let mut day1 = String::new();

        File::open("inputs/day1_input.txt").unwrap()
            .read_to_string(&mut day1).unwrap();

        bencher
            .with_inputs(|| {
                day1.as_str()
            })
            .bench_local_refs(|input| {
                aoc::day1::part1(input)
            });

    }

    #[divan::bench]
    fn part2(bencher: divan::Bencher) {
        let mut day1 = String::new();

        File::open("inputs/day1_input.txt").unwrap()
            .read_to_string(&mut day1).unwrap();

        bencher
            .with_inputs(|| {
                day1.as_str()
            })
            .bench_local_refs(|input| {
                aoc::day1::part2(input)
            });

    }
}

