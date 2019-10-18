const std = @import("std");
const json = std.json;
const mem = std.mem;

const fetch = @import("../fetch.zig").fetch;
const Command = @import("./command.zig").Command;
const Releases = @import("../releases.zig").Releases;

pub const list_command = Command{
    .name = "list",
    .aliases = [_][]const u8{ "ls", "lst", },
    .description = "lists available Zig versions",
    .usage = "zvm list",
    .execute = execute_list,
};

fn execute_list(allocator: *mem.Allocator, args: [][]const u8) anyerror!void {
    const body = try fetch(allocator, "https://ziglang.org/download/index.json");
    defer allocator.free(body);

    var json_parser = json.Parser.init(allocator, false);
    defer json_parser.deinit();

    var value = try json_parser.parse(body);
    defer value.deinit();

    const releases = try Releases.create(allocator, value.root);
    defer releases.destroy();

    for (releases.toSliceConst()) |release| {
        std.debug.warn("version: {}\n", release.version);
    }
}
