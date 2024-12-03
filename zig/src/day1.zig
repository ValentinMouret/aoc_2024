const std = @import("std");
const input = @embedFile("./data/day1.txt");

pub fn main() !void {
    const res1 = try solve1(input);
    std.log.info("1: {d}\n", .{res1});

    const res2 = try solve2(input);
    std.log.info("2: {d}\n", .{res2});
}

fn solve1(s: []const u8) !u32 {
    var gpa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = gpa.allocator();

    var it = std.mem.tokenizeScalar(u8, s, '\n');
    var result: u32 = 0;

    var leftList = std.ArrayList(u32).init(allocator);
    var rightList = std.ArrayList(u32).init(allocator);
    defer leftList.deinit();
    defer rightList.deinit();

    while (it.next()) |token| {
        var numbers = std.mem.split(u8, token, "   ");
        const first = try std.fmt.parseInt(u32, numbers.next() orelse unreachable, 10);
        const second = try std.fmt.parseInt(u32, numbers.next() orelse unreachable, 10);
        try addSorted(&leftList, first);
        try addSorted(&rightList, second);
    }

    for (leftList.items, 0..) |leftItem, i| {
        const rightItem = rightList.items[i];
        const diff = if (leftItem > rightItem) leftItem - rightItem else rightItem - leftItem;
        result += diff;
    }

    return result;
}

fn solve2(s: []const u8) !u32 {
    var gpa = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = gpa.allocator();

    var it = std.mem.tokenizeScalar(u8, s, '\n');
    var result: u32 = 0;

    var leftList = std.ArrayList(u32).init(allocator);
    var rightItems = std.AutoHashMap(u32, u32).init(allocator);
    defer leftList.deinit();
    defer rightItems.deinit();

    while (it.next()) |token| {
        var numbers = std.mem.split(u8, token, "   ");
        const first = try std.fmt.parseInt(u32, numbers.next() orelse unreachable, 10);
        const second = try std.fmt.parseInt(u32, numbers.next() orelse unreachable, 10);
        try leftList.append(first);
        const inMap = rightItems.get(second);
        if (inMap == null) {
            try rightItems.put(second, 1);
        } else {
            try rightItems.put(second, inMap.? + 1);
        }
    }

    for (leftList.items) |leftItem| {
        const rightCount = rightItems.get(leftItem);
        result += leftItem * if (rightCount != null) rightCount.? else 0;
    }

    return result;
}

fn addSorted(l: *std.ArrayList(u32), toAdd: u32) !void {
    if (l.items.len == 0) {
        try l.append(toAdd);
        return;
    }
    for (l.items, 0..) |it, i| {
        if (it >= toAdd) {
            try l.insert(i, toAdd);
            return;
        }
    }
    try l.append(toAdd);
    return;
}

test "addSorted" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var l = std.ArrayList(u32).init(allocator);
    defer l.deinit();

    try addSorted(&l, 1);
    try std.testing.expectEqual(1, l.items.len);

    try addSorted(&l, 2);
    try std.testing.expectEqual(2, l.items.len);
    try std.testing.expectEqual(1, l.items[0]);
    try std.testing.expectEqual(2, l.items[1]);

    try addSorted(&l, 0);
    try std.testing.expectEqual(3, l.items.len);
    try std.testing.expectEqual(0, l.items[0]);
    try std.testing.expectEqual(1, l.items[1]);
    try std.testing.expectEqual(2, l.items[2]);
}

test "part1" {
    const testInput =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;
    try std.testing.expectEqual(11, solve1(testInput));
}

test "part2" {
    const testInput =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;
    try std.testing.expectEqual(31, solve2(testInput));
}
