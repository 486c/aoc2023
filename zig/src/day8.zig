const std = @import("std");
const print = std.debug.print;

const Node = struct {
    right: *const [3]u8,
    left: *const [3]u8,
};

pub fn part1(input: []const u8) u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var lines = std.mem.splitAny(u8, input, "\n");
    var map = std.StringHashMap(Node).init(gpa.allocator());
    defer map.deinit();

    const header_line = lines.next().?;

    _ = lines.next().?; // Empty row

    while (lines.next()) |line| {
        var line_split = std.mem.splitAny(u8, line, "=");

        const value = line_split.next() orelse break;

        if (value.len == 0) break;

        const bracket_split = line_split.next().?;

        map.putNoClobber(value[0..3], Node{ .left = bracket_split[2..5], .right = bracket_split[7..10] }) catch unreachable;
    }

    var index: usize = 0;
    var element = map.get("AAA").?;
    var steps: u64 = 0;

    while (true) {
        if (index == header_line.len) {
            index = 0;
            continue;
        }

        const instruction = header_line[index];

        const current_letters = switch (instruction) {
            'R' => element.right,
            'L' => element.left,
            else => unreachable,
        };

        steps += 1;

        element = map.get(current_letters).?;

        if (std.mem.eql(u8, current_letters, "ZZZ")) {
            break;
        }

        index += 1;
    }

    return steps;
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
