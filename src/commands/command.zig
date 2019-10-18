const std = @import("std");
const mem = std.mem;

pub const Command = struct {
    name: comptime []const u8,
    aliases: comptime [][]const u8,
    description: comptime []const u8,
    usage: comptime []const u8,
    execute: fn(allocator: *mem.Allocator, args: [][]const u8) anyerror!void,
};
