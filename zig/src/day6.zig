const std = @import("std");
const print = std.debug.print;

pub fn calc_dist(hold: u64, lasts: u64) u64 {
    return hold * (lasts - hold);
}

pub fn part1(input: []const u8) u64 {
    var lines = std.mem.splitAny(u8, input, "\n");
    var sum: u64 = 1;

    var dist_arr = [4]u32{ 0, 0, 0, 0 };
    var time_arr = [4]u32{ 0, 0, 0, 0 };

    const time_raw = lines.next().?;
    const distance = lines.next().?;

    var time_split = std.mem.splitAny(u8, time_raw[9..], " ");
    var dist_split = std.mem.splitAny(u8, distance[9..], " ");

    var index: usize = 0;
    while (time_split.next()) |l_time| {
        if (l_time.len == 0) continue;

        const digit = std.fmt.parseInt(u32, l_time, 10) catch continue;
        time_arr[index] = digit;
        index += 1;
    }

    index = 0;
    while (dist_split.next()) |l_dist| {
        if (l_dist.len == 0) continue;

        const digit = std.fmt.parseInt(u32, l_dist, 10) catch continue;
        dist_arr[index] = digit;
        index += 1;
    }

    for (time_arr, dist_arr) |time, dist| {
        var win_amount: u64 = 0;
        for (0..time) |hold| {
            const result_dist = calc_dist(@intCast(hold), time);

            if (result_dist > dist) {
                win_amount += 1;
            }
        }

        if (win_amount != 0) sum *= win_amount;
    }

    return sum;
}

pub fn part2(input: []const u8) u64 {
    var lines = std.mem.splitAny(u8, input, "\n");

    var time_num: u64 = 0;
    var dist_num: u64 = 0;

    const time_raw = lines.next().?;
    const distance = lines.next().?;

    var time_split = std.mem.splitAny(u8, time_raw[9..], " ");
    var dist_split = std.mem.splitAny(u8, distance[9..], " ");

    while (time_split.next()) |l_time| {
        if (l_time.len == 0) continue;
        const digit = std.fmt.parseInt(u32, l_time, 10) catch continue;
        const mult: u32 = switch (l_time.len) {
            1 => 10,
            2 => 100,
            3 => 1000,
            4 => 10000,
            else => unreachable,
        };
        time_num = time_num * mult + digit;
    }

    while (dist_split.next()) |l_dist| {
        if (l_dist.len == 0) continue;

        const digit = std.fmt.parseInt(u32, l_dist, 10) catch continue;
        const mult: u32 = switch (l_dist.len) {
            1 => 10,
            2 => 100,
            3 => 1000,
            4 => 10000,
            else => unreachable,
        };

        dist_num = dist_num * mult + digit;
    }

    var win_amount: u64 = 0;
    for (0..time_num) |hold| {
        const result_dist = calc_dist(@intCast(hold), @intCast(time_num));

        if (result_dist > dist_num) {
            win_amount += 1;
        }
    }

    return win_amount;
}

pub fn run() !void {
    const buff = @embedFile("./inputs/day6_input.txt");

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
