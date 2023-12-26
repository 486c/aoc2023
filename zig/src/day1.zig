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

pub fn part2(input: []const u8) u64 {
    _ = input;
    return 0;
}

pub fn run() !void {
    //var alloc = std.heap.GeneralPurposeAllocator(.{}){};

    //const buff = try std.fs.cwd()
    //.readFileAlloc(alloc.allocator(), "inputs/day1_input.txt", std.math.maxInt(usize));
    const buff = @embedFile("./inputs/day1_input.txt");

    var timer = try std.time.Timer.start();
    const res_p1 = part1(buff);
    timer.reset();

    const p1_time: f64 = @as(f64, @floatFromInt(timer.read())) / 1e6;

    const res_p2 = part2(buff);

    std.debug.print("Results: {d} ({d}ms) | {d}\n", .{ res_p1, p1_time, res_p2 });
}
