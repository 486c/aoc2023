use std::{fs::File, io::Read};
use eyre::Result;


fn main() -> Result<()> {
    let mut file = File::open("inputs/day4_test.txt")?;
    let mut buff = String::new();
    file.read_to_string(&mut buff)?;


    let res = aoc::day4::run_debug(&buff);
    println!("{}, {}", res.0, res.1);

    Ok(())
}
