const std = @import("std");

pub fn main() !void {
    var data = try getFileContents();

    std.mem.sort(u32, &data[0], {}, std.sort.asc(u32));
    std.mem.sort(u32, &data[1], {}, std.sort.asc(u32));

    var diff: u64 = 0;

    for (0.., data[0]) |i, elem| {
        const distance = @as(i64, elem) - @as(i64, data[1][i]);
        diff += @abs(distance);
    }

    std.debug.print("Difference: {}\n", .{diff});

    var similar: i64 = 0;
    for (data[0]) |elem| {
        for (data[1]) |elem2| {
            if (elem == elem2) {
                similar += elem2;
            }
        }
    }

    std.debug.print("Similar: {}\n", .{similar});
}

fn getFileContents() !struct { [1000]u32, [1000]u32 } {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1000]u8 = undefined;

    var first: [1000]u32 = undefined;
    var second: [1000]u32 = undefined;
    var count: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        first[count] = try std.fmt.parseInt(u32, line[0..5], 10);
        second[count] = try std.fmt.parseInt(u32, line[8..13], 10);
        count += 1;
    }
    return .{ first, second };
}
