const std = @import("std");
const json = std.json;
const mem = std.mem;

const fetch = @import("../fetch.zig").fetch;
const Command = @import("./command.zig").Command;
const Releases = @import("../releases.zig").Releases;

pub const install_command = Command{
    .name = "install",
    .aliases = [_][]const u8{ "i", },
    .description = "installs an available Zig version",
    .usage = "zvm install <version>",
    .execute = execute_install,
};

fn execute_install(allocator: *mem.Allocator, args: [][]const u8) anyerror!void {
    std.debug.warn(install_command.usage);
}
