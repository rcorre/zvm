const std = @import("std");
const json = std.json;
const mem = std.mem;

const fetch = @import("../fetch.zig").fetch;
const Command = @import("./command.zig").Command;
const Releases = @import("../releases.zig").Releases;

const exposed_commands = @import("../commands.zig").exposed_commands;

pub const help_command = Command{
    .name = "help",
    .aliases = [_][]const u8{ "h", "hlp", },
    .description = "shows the help information",
    .usage = "zvm help [command]",
    .execute = execute_help,
};

fn execute_help(allocator: *mem.Allocator, args: [][]const u8) anyerror!void {
    if (args.len > 1) {
        std.debug.warn(help_command.usage);
        return;
    }

    if (args.len == 1) {
        const cmd_arg = args[0];

        inline for (exposed_commands) |command| {
            if (mem.eql(u8, command.name, cmd_arg)) {
                std.debug.warn(command.usage);
                return;
            }

            inline for (command.aliases) |command_alias| {
                if (mem.eql(u8, command_alias, cmd_arg)) {
                    std.debug.warn(command.usage);
                    return;
                }
            }
        }

        std.debug.warn(help_command.usage);
        return;
    }

    std.debug.warn("Usage: zvm <command>\n\n");

    std.debug.warn("Commands:\n\n");

    inline for (exposed_commands) |command| {
        std.debug.warn("\t{}\n\n", command.usage);
        std.debug.warn("\t\t{}\n\n\n", command.description);
    }
}
