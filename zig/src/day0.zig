const std = @import("std");

const input = @embedFile("./data/day1.txt");

// Let’s do day 1 of 2023 to get prepared.

fn digitToInt(c: u8) ?u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        else => null,
    };
}

fn solve1(s: []const u8) !u32 {
    var it = std.mem.tokenizeScalar(u8, s, '\n');
    var result: u32 = 0;
    while (it.next()) |token| {
        var firstDigit: ?u8 = null;
        var lastDigit: ?u8 = null;
        for (token) |char| {
            const d = digitToInt(char);
            if (d == null) continue;
            if (firstDigit == null) {
                firstDigit = char;
            }
            lastDigit = char;
        }
        if ((firstDigit == null) or (lastDigit == null)) {
            std.log.err("missing digit\n", .{});
            continue;
        }
        const numberStr = &[_]u8{ firstDigit.?, lastDigit.? };
        const number = try std.fmt.parseInt(u32, numberStr, 10);
        result = result + number;
    }
    return result;
}

fn solve2(s: []const u8) !u32 {
    var it = std.mem.tokenizeScalar(u8, s, '\n');
    var result: u32 = 0;
    while (it.next()) |token| {
        var firstDigit: ?u8 = null;
        var lastDigit: ?u8 = null;

        for (token, 0..) |char, i| {
            var num = digitToInt(char);

            if (num == null) {
                num = scanNumbers(token[i..]);
            }

            if (num == null) continue;

            if (firstDigit == null) {
                firstDigit = num;
            }
            lastDigit = num;
        }
        if (firstDigit == null or lastDigit == null) {
            std.log.err("missing digits", .{});
            continue;
        }
        result += 10 * firstDigit.? + lastDigit.?;
    }
    return result;
}

fn scanNumbers(s: []const u8) ?u8 {
    if (s.len < 3) {
        return null;
    }

    const nextThree = s[0..3];
    if (std.mem.eql(u8, nextThree, "one")) {
        return 1;
    }
    if (std.mem.eql(u8, nextThree, "two")) {
        return 2;
    }
    if (std.mem.eql(u8, nextThree, "six")) {
        return 6;
    }

    if (s.len < 4) {
        return null;
    }
    const nextFour = s[0..4];
    if (std.mem.eql(u8, nextFour, "four")) {
        return 4;
    }
    if (std.mem.eql(u8, nextFour, "five")) {
        return 5;
    }
    if (std.mem.eql(u8, nextFour, "nine")) {
        return 9;
    }

    if (s.len < 5) {
        return null;
    }
    const nextFive = s[0..5];
    if (std.mem.eql(u8, nextFive, "three")) {
        return 3;
    }
    if (std.mem.eql(u8, nextFive, "seven")) {
        return 7;
    }
    if (std.mem.eql(u8, nextFive, "eight")) {
        return 8;
    }
    return null;
}

test "scan numbers" {
    try std.testing.expectEqual(scanNumbers(""), null);

    try std.testing.expectEqual(scanNumbers("one"), 1);
    try std.testing.expectEqual(scanNumbers("two"), 2);
    try std.testing.expectEqual(scanNumbers("three"), 3);
    try std.testing.expectEqual(scanNumbers("four"), 4);
    try std.testing.expectEqual(scanNumbers("five"), 5);
    try std.testing.expectEqual(scanNumbers("six"), 6);
    try std.testing.expectEqual(scanNumbers("seven"), 7);
    try std.testing.expectEqual(scanNumbers("eight"), 8);
    try std.testing.expectEqual(scanNumbers("nine"), 9);

    try std.testing.expectEqual(scanNumbers("preone"), null);
    try std.testing.expectEqual(scanNumbers("pretwo"), null);
    try std.testing.expectEqual(scanNumbers("prethree"), null);
    try std.testing.expectEqual(scanNumbers("prefour"), null);
    try std.testing.expectEqual(scanNumbers("prefive"), null);
    try std.testing.expectEqual(scanNumbers("presix"), null);
    try std.testing.expectEqual(scanNumbers("preseven"), null);
    try std.testing.expectEqual(scanNumbers("preeight"), null);
    try std.testing.expectEqual(scanNumbers("prenine"), null);

    try std.testing.expectEqual(scanNumbers("onerest"), 1);
    try std.testing.expectEqual(scanNumbers("tworest"), 2);
    try std.testing.expectEqual(scanNumbers("threerest"), 3);
    try std.testing.expectEqual(scanNumbers("fourrest"), 4);
    try std.testing.expectEqual(scanNumbers("fiverest"), 5);
    try std.testing.expectEqual(scanNumbers("sixrest"), 6);
    try std.testing.expectEqual(scanNumbers("sevenrest"), 7);
    try std.testing.expectEqual(scanNumbers("eightrest"), 8);
    try std.testing.expectEqual(scanNumbers("ninerest"), 9);
}

pub fn main() !void {
    const res1 = try solve1(input);
    std.debug.print("1: {d}\n", .{res1});

    const res2 = try solve2(input);
    std.debug.print("2: {d}\n", .{res2});
}

test "test " {
    const testInput =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    const result = solve1(testInput);
    try std.testing.expectEqual(142, result);
}

test "solve2" {
    const testInput =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    try std.testing.expectEqual(281, solve2(testInput));
}
