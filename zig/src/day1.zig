const std = @import("std");
const print = std.debug.print;

pub fn part1(input: []const u8) u64 {
    var lines = std.mem.splitAny(u8, input, "\n");

    var digits = [_]u8{ 0, 0 };
    var sum: u64 = 0;

    while (lines.next()) |line| {
        var digit: u8 = 0;
        for (line) |char| {
            digit = std.fmt.charToDigit(char, 10) catch continue;

            if (digits[0] == 0) {
                digits[0] = digit;
            }
        }

        digits[1] = digit;

        const num = digits[0] * 10 + digits[1];

        sum += num;

        digits[0] = 0;
        digits[1] = 0;
    }

    return sum;
}

const KeyValue = struct { key: []const u8, value: u8 };

pub fn part2(input: []const u8) u64 {
    const values = [_]KeyValue{
        KeyValue{ .key = "one", .value = 1 },
        KeyValue{ .key = "two", .value = 2 },
        KeyValue{ .key = "three", .value = 3 },
        KeyValue{ .key = "four", .value = 4 },
        KeyValue{ .key = "five", .value = 5 },
        KeyValue{ .key = "six", .value = 6 },
        KeyValue{ .key = "seven", .value = 7 },
        KeyValue{ .key = "eight", .value = 8 },
        KeyValue{ .key = "nine", .value = 9 },
    };

    var sum: u64 = 0;

    var first_digit: u8 = 0;
    var last_digit: u8 = 0;

    var lines = std.mem.splitAny(u8, input, "\n");
    while (lines.next()) |line| {
        var n: usize = 0;
        first_digit = 0;
        last_digit = 0;
        char_loop: while (n < line.len) : (n += 1) {
            for (values) |kv| {
                if (std.mem.startsWith(u8, line[n..], kv.key)) {
                    if (first_digit == 0) {
                        first_digit = kv.value;
                    } else {
                        last_digit = kv.value;
                    }

                    n += kv.key.len - 1;
                    continue :char_loop;
                }
            }

            const d = std.fmt.charToDigit(line[n], 10) catch continue;

            if (first_digit == 0) {
                first_digit = d;
            } else {
                last_digit = d;
            }
        }

        if (last_digit == 0) last_digit = first_digit;

        const num = first_digit * 10 + last_digit;

        print("{d}\n", .{num});
        sum += num;
    }

    return sum;
}

pub fn run() !void {
    //var alloc = std.heap.GeneralPurposeAllocator(.{}){};

    //const buff = try std.fs.cwd()
    //.readFileAlloc(alloc.allocator(), "inputs/day1_input.txt", std.math.maxInt(usize));
    const buff = @embedFile("./inputs/day1_test.txt");

    var timer = try std.time.Timer.start();
    const res_p1 = part1(buff);
    timer.reset();

    const p1_time: f64 = @as(f64, @floatFromInt(timer.read())) / 1e6;

    const res_p2 = part2(buff);

    std.debug.print("Results: {d} ({d}ms) | {d}\n", .{ res_p1, p1_time, res_p2 });
}
