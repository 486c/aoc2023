use std::{fs::File, io::{BufReader, BufRead}};

use eyre::Result;

fn main() -> Result<()> {
    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);

    let mut sum = 0;

    // 0 - red
    // 1 - blue
    // 2 - green
    for line in reader.lines() {
        let line = line?;

        let mut split = line.split(':');

        //let game = split.next().unwrap();
        let cubes = split.next().unwrap();
        //let game_id: usize = game[5..game.len()].parse()?;

        let cube_sets = cubes.split(';');
        
        // Cube sets
        let mut min_required = [0, 0, 0];
        for cube_set in cube_sets {
            let cubes = cube_set.split(',');
            
            // Individual cubes
            for cube in cubes {
                let mut set_counter = [0, 0, 0];

                let mut cube = cube[1..cube.len()].split(' ');

                let amount: usize = cube.next().unwrap()
                    .parse()?;
                let color = cube.next().unwrap();

                match color {
                    "red" => set_counter[0] = amount,
                    "blue" => set_counter[1] = amount,
                    "green" => set_counter[2] = amount,
                    _ => (),
                };
                
                // Red
                if min_required[0] < set_counter[0] {
                    min_required[0] = set_counter[0]
                };
                
                // Blue
                if min_required[1] < set_counter[1] {
                    min_required[1] = set_counter[1]
                };
                
                // Green
                if min_required[2] < set_counter[2] {
                    min_required[2] = set_counter[2]
                };
            }
        }

        let power = min_required[0] 
            * min_required[1] 
            * min_required[2];

        sum += power;
    }

    println!("Sum: {sum}");

    Ok(())
}
