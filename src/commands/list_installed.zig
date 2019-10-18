const std = @import("std");
const json = std.json;
const mem = std.mem;

const fetch = @import("../fetch.zig").fetch;
const Command = @import("./command.zig").Command;
const Releases = @import("../releases.zig").Releases;

pub const list_installed_command = Command{
    .name = "list-installed",
    .aliases = [_][]const u8{ "ls", "lst", },
    .description = "lists installed Zig versions",
    .usage = "zvm list-installed",
    .execute = execute_list_installed,
};

fn execute_list_installed(allocator: *mem.Allocator, args: [][]const u8) anyerror!void {
    std.debug.warn(list_installed_command.usage);
}
