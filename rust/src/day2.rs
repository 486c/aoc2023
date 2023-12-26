use eyre::Result;

const RED: usize = 0;
const BLUE: usize = 1;
const GREEN: usize = 2;

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
    let mut sum: u64 = 0;

    for (game_id, line) in input.lines().enumerate() {
        let mut split = line.split(':').skip(1);

        let cubes = split.next().unwrap();

        let cube_sets = cubes.split(';');

        let mut won = true;
        'cube_set: for cube_set in cube_sets {
            let cubes = cube_set.split(',');
            
            // Individual cubes
            for cube in cubes {
                let mut cube = cube[1..cube.len()].split(' ');

                let amount: u64 = cube
                    .next()
                    .unwrap()
                    .parse()?;

                let color = cube.next().unwrap();

                match (color, amount) {
                    ("red", n) => {
                        if n > 12 { 
                            won = false;
                            break 'cube_set;
                        }
                    },
                    ("blue", n) => {
                        if n > 14 {
                            won = false;
                            break 'cube_set;
                        }
                    },
                    ("green", n) => {
                        if n > 13 {
                            won = false;
                            break 'cube_set;
                        }
                    },
                    _ => (),
                };
            }
        }

        if won {
            sum += game_id as u64 + 1
        }
    }

    Ok(sum)
}

pub fn part2(input: &str) -> Result<u64> {
    let mut sum = 0;

    for line in input.lines() {
        let mut split = line.split(':').skip(1);

        let cubes = split.next().unwrap();

        let cube_sets = cubes.split(';');
        
        // Cube sets
        let mut min_required = [0, 0, 0];
        for cube_set in cube_sets {
            let cubes = cube_set.split(',');
            
            // Individual cubes
            for cube in cubes {
                let mut cube = cube[1..cube.len()].split(' ');

                let amount: u64 = cube
                    .next()
                    .unwrap()
                    .parse()?;

                let color = cube.next().unwrap();

                match color {
                    "red" => {
                        if min_required[RED] < amount {
                            min_required[RED] = amount
                        }
                    },
                    "blue" => {
                        if min_required[BLUE] < amount {
                            min_required[BLUE] = amount
                        }
                    },
                    "green" => {
                        if min_required[GREEN] < amount {
                            min_required[GREEN] = amount
                        }
                    },
                    _ => (),
                };
            }
        }

        let power = min_required[RED] 
            * min_required[BLUE] 
            * min_required[GREEN];

        sum += power;
    }
    
    Ok(sum)
}
