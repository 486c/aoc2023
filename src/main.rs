use std::{fs::File, io::Read};
use eyre::Result;

mod day1;
mod day2;
mod day3;
mod day4;

fn main() -> Result<()> {
    let mut file = File::open("inputs/day4_test.txt")?;
    let mut buff = String::new();
    file.read_to_string(&mut buff)?;


    let res = crate::day4::run_debug(&buff);
    println!("{}, {}", res.0, res.1);

    Ok(())
}
