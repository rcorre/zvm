pub usingnamespace @import("./commands/command.zig");

pub const help_command = @import("./commands/help.zig").help_command;
pub const install_command = @import("./commands/install.zig").install_command;
pub const list_installed_command = @import("./commands/list_installed.zig").list_installed_command;
pub const list_command = @import("./commands/list.zig").list_command;
pub const use_command = @import("./commands/use.zig").use_command;

pub const exposed_commands = comptime [_]Command{
    help_command,
    install_command,
    list_installed_command,
    list_command,
    use_command,
};

pub const default_command = help_command;
