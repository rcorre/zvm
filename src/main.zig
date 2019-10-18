const std = @import("std");
const mem = std.mem;
const json = std.json;
const heap = std.heap;

const commands = @import("./commands.zig");
const exposed_commands = commands.exposed_commands;
const default_command = commands.default_command;

pub fn main() anyerror!void {
    var arena_allocator = heap.ArenaAllocator.init(heap.direct_allocator);
    defer arena_allocator.deinit();

    var allocator = &arena_allocator.allocator;

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    var all_args = args[1..];

    if (all_args.len < 1) {
        return default_command.execute(allocator, [_][]const u8{});
    }

    var cmd_arg = all_args[0];
    var cmd_args = all_args[1..];

    inline for (exposed_commands) |command| {
        if (mem.eql(u8, command.name, cmd_arg)) {
            return command.execute(allocator, cmd_args);
        }

        inline for (command.aliases) |command_alias| {
            if (mem.eql(u8, command_alias, cmd_arg)) {
                return command.execute(allocator, cmd_args);
            }
        }
    }

    return default_command.execute(allocator, cmd_args);
}
