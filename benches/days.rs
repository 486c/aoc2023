use divan::{black_box, Bencher};

macro_rules! generate_part {
    ($day:ident, $part:ident) => {
        #[divan::bench]
        fn $part(bencher: divan::Bencher) {
            let mut $day = String::new();

            let input_path = format!(
                "inputs/{}_input.txt", 
                stringify!($day)
            );

            File::open(&input_path).unwrap()
                .read_to_string(&mut $day).unwrap();

            bencher
                .with_inputs(|| {
                    $day.as_str()
                })
                .bench_local_refs(|input| {
                    aoc::$day::$part(input)
                });
        }
    }
}

macro_rules! generate_bench {
    ($day:ident) => {
        mod $day {
            use divan::{black_box, Bencher};
            use std::fs::File;
            use std::io::Read;

            generate_part!($day, part1);
            generate_part!($day, part2);
        }
    }
}

generate_bench!(day1);
generate_bench!(day2);

fn main() {
    divan::main();
}
