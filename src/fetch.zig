const std = @import("std");
const mem = std.mem;
const ChildProcess = std.ChildProcess;

pub fn fetch(allocator: *mem.Allocator, url: []const u8) ![]const u8 {
    const args = [3][]const u8{
        "curl",
        "-s",
        url,
    };

    var result = try ChildProcess.exec(allocator, args, null, null, 2 * 1024 * 1024);
    errdefer allocator.free(result.stderr);

    return result.stdout;
}
