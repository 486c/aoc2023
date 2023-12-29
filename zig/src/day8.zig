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
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    var lines = std.mem.splitAny(u8, input, "\n");
    var map = std.StringHashMap(Node).init(gpa.allocator());
    var follow = std.ArrayList(*const [3]u8).init(gpa.allocator());
    defer map.deinit();

    var l: u64 = 1;

    const header_line = lines.next().?;

    _ = lines.next().?; // Empty row

    while (lines.next()) |line| {
        var line_split = std.mem.splitAny(u8, line, "=");

        const value = line_split.next() orelse break;

        if (value.len == 0) break;

        const bracket_split = line_split.next().?;

        const value_key = value[0..3];

        if (value_key[2] == 'A') {
            follow.append(value_key) catch unreachable;
        }

        map.putNoClobber(value_key, Node{ .left = bracket_split[2..5], .right = bracket_split[7..10] }) catch unreachable;
    }

    var follow_index: usize = 0;
    while (follow_index < follow.items.len) : (follow_index += 1) {
        var index: usize = 0;
        var steps: usize = 0;

        print("Checking {s}\n", .{follow.items[follow_index]});

        while (true) {
            if (index == header_line.len) {
                index = 0;
                continue;
            }

            const element = map.get(follow.items[follow_index]).?;

            const instruction = header_line[index];

            const current_letters = switch (instruction) {
                'R' => element.right,
                'L' => element.left,
                else => unreachable,
            };

            steps += 1;

            if (current_letters[2] == 'Z') {
                l = lcm_v2(l, steps);
                break;
            }

            follow.items[follow_index] = current_letters;

            index += 1;
        }
    }

    return l;
}

pub fn gcd(a: u64, b: u64) u64 {
    if (b == 0) return a;
    return gcd(b, a % b);
}

pub fn lcm(arr: []const u64) u64 {
    var ans = arr[0];

    for (1..arr.len) |i| {
        ans = ans * arr[i] / gcd(ans, arr[i]);
    }

    return ans;
}

pub fn lcm_v2(a: u64, b: u64) u64 {
    return a * b / gcd(a, b);
}

test "gcd test" {
    try std.testing.expect(gcd(6, 3) == 3);
    try std.testing.expect(gcd(770, 900) == 10);
}

test "lcm test" {
    var test_arr = [_]u64{ 3, 6 };
    try std.testing.expect(lcm(&test_arr) == 6);

    const test_arr_2 = [_]u64{ 330, 75, 450, 225 };
    try std.testing.expect(lcm(&test_arr_2) == 4950);

    try std.testing.expect(lcm_v2(3, 6) == 6);
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
