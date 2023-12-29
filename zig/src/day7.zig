const std = @import("std");
const print = std.debug.print;

const HandType = enum(u8) {
    FiveK,
    FourK,
    FullHouse,
    ThreeK,
    TwoP,
    OneP,
    HighC,
};

const Hand = struct {
    hand: *const [5]u8,
    hand_kind: HandType,
    bid: u64,

    pub fn parse(map: *std.AutoArrayHashMap(u8, u8), line: []const u8) Hand {
        var line_split = std.mem.splitAny(u8, line, " ");

        const raw_hand = line_split.next().?[0..5];
        const bid = std.fmt.parseInt(u64, line_split.next().?, 10) catch unreachable;

        // Couting distinct values
        for (raw_hand) |char| {
            const value = map.getOrPut(char) catch unreachable;

            if (!value.found_existing) {
                value.value_ptr.* = 1;
            } else {
                value.value_ptr.* += 1;
            }
        }

        const kind = switch (map.count()) {
            1 => HandType.FiveK,
            2 => blk: {
                var values = map.values();
                std.sort.insertion(u8, values[0..], {}, cmp_value);

                if (values[0] == 4 and values[1] == 1) {
                    break :blk HandType.FourK;
                }

                if (values[0] == 3 and values[1] == 2) {
                    break :blk HandType.FullHouse;
                }

                unreachable;
            },
            3 => blk: {
                var values = map.values();
                std.sort.insertion(u8, values[0..], {}, cmp_value);

                if (values[0] == 3 and values[1] == 1 and values[2] == 1)
                    break :blk HandType.ThreeK;

                if (values[0] == 2 and values[1] == 2 and values[2] == 1)
                    break :blk HandType.TwoP;

                unreachable;
            },
            4 => HandType.OneP,
            5 => HandType.HighC,
            else => unreachable,
        };

        return Hand{ .hand = raw_hand, .hand_kind = kind, .bid = bid };
    }
};

fn strength(card: u8) u8 {
    const res: u8 = switch (card) {
        'A' => 13,
        'K' => 12,
        'Q' => 11,
        'J' => 10,
        'T' => 9,
        '9' => 8,
        '8' => 7,
        '7' => 6,
        '6' => 5,
        '5' => 4,
        '4' => 3,
        '3' => 2,
        '2' => 1,
        else => unreachable,
    };

    return res;
}

fn cmp_value(context: void, a: u8, b: u8) bool {
    return std.sort.desc(u8)(context, a, b);
}

fn cmp_leaderboard(context: void, a: Hand, b: Hand) bool {
    _ = context;
    if (@intFromEnum(a.hand_kind) == @intFromEnum(b.hand_kind)) {
        for (a.hand, b.hand) |h1, h2| {
            if (strength(h1) == strength(h2)) {
                continue;
            } else {
                return strength(h1) < strength(h2);
            }
        }
    }

    return @intFromEnum(a.hand_kind) > @intFromEnum(b.hand_kind);
}

pub fn part1(input: []const u8) u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var lines = std.mem.splitAny(u8, input, "\n");
    var map = std.AutoArrayHashMap(u8, u8).init(gpa.allocator());
    defer map.deinit();

    var leaderboard = std.ArrayList(Hand).init(gpa.allocator());
    leaderboard.ensureTotalCapacity(1000) catch unreachable;
    defer leaderboard.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const hand = Hand.parse(&map, line);

        leaderboard.append(hand) catch unreachable;

        map.clearRetainingCapacity();
    }

    std.sort.insertion(Hand, leaderboard.items, {}, cmp_leaderboard);

    var sum: u64 = 0;
    for (1.., leaderboard.items) |rank, hand| {
        print("{s} - {d}\n", .{ hand.hand, hand.bid * rank });
        sum += hand.bid * rank;
    }

    return sum;
}

pub fn part2(input: []const u8) u64 {
    _ = input;

    return 0;
}

pub fn run() !void {
    //var gpa = std.mem.GeneralPurposeAllocator(.{});

    const buff = @embedFile("./inputs/day7_input.txt");

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

test "test array hashmap" {
    const line = "AAAAA";
    const expect = std.testing.expect;

    const test_allocator = std.testing.allocator;

    var map = std.AutoArrayHashMap(u8, void).init(test_allocator);
    defer map.deinit();

    for (line) |char| {
        map.put(char, {}) catch unreachable;
    }

    try expect(map.count() == 1);
}

test "test parse" {
    const expect = std.testing.expect;

    var line: []const u8 = "AAAAA 123";
    var expecting: Hand = Hand{ .hand = "AAAAA", .hand_kind = HandType.FiveK, .bid = 123 };
    var parsed: Hand = Hand.parse(line);

    try expect(parsed.bid == expecting.bid);
    try expect(parsed.hand_kind == expecting.hand_kind);
    try expect(std.mem.eql(u8, parsed.hand, expecting.hand) == true);

    line = "AAAAB 123";
    expecting = Hand{ .hand = "AAAAB", .hand_kind = HandType.FourK, .bid = 123 };
    parsed = Hand.parse(line);

    try expect(parsed.bid == expecting.bid);
    try expect(parsed.hand_kind == expecting.hand_kind);
    try expect(std.mem.eql(u8, parsed.hand, expecting.hand) == true);
}

test "test sorting" {
    const test_allocator = std.testing.allocator;

    var map = std.AutoArrayHashMap(u8, void).init(test_allocator);

    map.put(1, 4);
    map.put(2, 2);
    map.put(3, 88);
    map.put(5, 1);
}
