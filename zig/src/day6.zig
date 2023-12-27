const std = @import("std");
const print = std.debug.print;

pub fn calc_dist(hold: u32, lasts: u32) u32 {
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
    _ = input;

    return 0;
}

pub fn run() !void {
    const buff = @embedFile("./inputs/day6_input.txt");

    var timer = try std.time.Timer.start();
    const res_p1 = part1(buff);
    timer.reset();

    const p1_time: f64 = @as(f64, @floatFromInt(timer.read())) / 1e6;

    const res_p2 = part2(buff);

    std.debug.print("Results: {d} ({d}ms) | {d}\n", .{ res_p1, p1_time, res_p2 });
}
