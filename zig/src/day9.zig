const std = @import("std");
const print = std.debug.print;

pub fn part1(input: []const u8) u64 {
    _ = input;

    return 0;
}

pub fn part2(input: []const u8) u64 {
    _ = input;

    return 0;
}

pub fn run() !void {
    const buff = @embedFile("./inputs/day8_input.txt");

    var timer = try std.time.Timer.start();
    const res_p1 = part1(buff);
    timer.reset();

    const p1_time: f64 = @as(f64, @floatFromInt(timer.read())) / 1e6;

    timer = try std.time.Timer.start();
    const res_p2 = part2(buff);
    timer.reset();

    const p2_time: f64 = @as(f64, @floatFromInt(timer.read())) / 1e6;

    std.debug.print("Results: {d} ({d}ms) | {d} ({d}ms)\n", .{ res_p1, p1_time, res_p2, p2_time });
}
