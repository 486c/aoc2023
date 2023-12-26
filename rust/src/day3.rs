use std::ops::Index;

use eyre::Result;

pub fn run(input: &str) -> u64 {
    let p2 = part1(input).unwrap();

    p2
}

pub fn run_debug(input: &str) -> (u64, u64) {
    let p1 = part1(input).unwrap();
    let p2 = part2(input).unwrap();

    (p1, p2)
}

struct Matrix<'a> {
    bytes: &'a [u8],
    width: usize,
    height: usize,
}

impl<'a> Matrix<'a> {
    fn new(input: &'a str) -> Self {
        Self {
            width: input.find('\n').unwrap() + 1,
            height: input.lines().count(),
            bytes: input.as_bytes()
        }
    }
}

impl Index<usize> for Matrix<'_> {
    type Output = [u8];

    fn index(&self, index: usize) -> &Self::Output {
        &self.bytes[(index * self.width)..][..self.width - 1]
    }
}

fn check_slice(slice: &[u8]) -> bool {
    for b in slice {
        if !b.is_ascii_digit() {
            if *b != b'.' {
                return true;
            }
        }
    }

    return false
}

pub fn part1(input: &str) -> Result<u64> {
    let matrix = Matrix::new(input);

    let lines = input.lines().map(str::as_bytes).enumerate();
    let mut sum = 0;

    for (y, line) in lines {
        let mut start = 0;

        while start < (line.len() - 1) {
            let mut end = start;
            if line[start].is_ascii_digit() {
                while end < (line.len()) && line[end].is_ascii_digit() {
                    end += 1;
                }

                let num: u64 = line[start..end].iter().fold(
                    0, 
                    |n, x| 
                    (n * 10) + (*x & 0xF) as u64
                );

                let start_pos = start.saturating_sub(1);
                let end_pos = (end+1).min(line.len());

                let mut touching = false;
                for ny in y.saturating_sub(1)..=(y+1).min(matrix.height-1) {
                    let check = check_slice(
                        &matrix[ny][start_pos..end_pos]
                    );

                    if check {
                        touching = true;
                        break;
                    }
                }

                if touching {
                    sum += num;
                }

                start = end;

                continue;
            }

            start += 1;
        }
    }

    Ok(sum)
}

pub fn part2(input: &str) -> Result<u64> {
    Ok(1)
}

#[test]
fn check_matrix() {
    let test = "123\n456\n...\n.*$";

    let matrix = Matrix::new(&test);

    assert_eq!(matrix[0][0] as char,  '1');
    assert_eq!(matrix[1][0] as char,  '4');
    assert_eq!(matrix[2][0] as char,  '.');
    assert_eq!(matrix[3][1] as char,  '*');

    assert_eq!(&matrix[0], "123".as_bytes());
    assert_eq!(&matrix[1], "456".as_bytes());
    assert_eq!(&matrix[2], "...".as_bytes());
    assert_eq!(&matrix[3], ".*$".as_bytes());
}

#[test]
fn check_matrix2() {
    let test = "467..114..\n...*....33\n..35..633.";

    let matrix = Matrix::new(&test);

    assert_eq!(
        unsafe {std::str::from_utf8_unchecked(&matrix[0]) },
        "467..114.."
    );

    assert_eq!(
        unsafe {std::str::from_utf8_unchecked(&matrix[1]) },
        "...*....33"
    );

    assert_eq!(
        unsafe {std::str::from_utf8_unchecked(&matrix[2]) },
        "..35..633."
    );
}
