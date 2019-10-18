const std = @import("std");
const json = std.json;
const mem = std.mem;

const fetch = @import("../fetch.zig").fetch;
const Command = @import("./command.zig").Command;
const Releases = @import("../releases.zig").Releases;

pub const use_command = Command{
    .name = "use",
    .aliases = [_][]const u8{ "ls", "lst", },
    .description = "changes the currently used version of the Zig compiler.",
    .usage = "zvm use <version>",
    .execute = execute_use,
};

fn execute_use(allocator: *mem.Allocator, args: [][]const u8) anyerror!void {
    std.debug.warn(use_command.usage);
}
