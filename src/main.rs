use std::{fs::File, io::Read};
use eyre::Result;

mod day1;
mod day2;

fn main() -> Result<()> {
    let mut file = File::open("inputs/day2_input.txt")?;
    let mut buff = String::new();
    file.read_to_string(&mut buff)?;


    let res = crate::day2::run_debug(&buff);
    println!("{}, {}", res.0, res.1);

    Ok(())
}
