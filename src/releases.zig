const std = @import("std");
const builtin = @import("builtin");
const mem = std.mem;
const json = std.json;
const ArrayList = std.ArrayList;

const release_bin = switch (builtin.os) {
    .windows => "x86_64-windows",
    .linux => "x86_64-linux",
    .kfreebsd => "x86_64-freebsd",
    .macosx => "x86_64-macos",
    else => @compileError("unsuported compile " ++ @memberName(builtin.os, @enumToInt(builtin.os))),
};

pub const Releases = struct {
    const Self = @This();

    allocator: *mem.Allocator,
    releases: []const Release,

    pub fn create(allocator: *mem.Allocator, value: json.Value) !*Self {
        var self = try allocator.create(Self);
        errdefer allocator.destroy(self);

        self.allocator = allocator;
        self.releases = try self.convert(value);

        return self;
    }

    pub fn destroy(self: *Self) void {
        self.allocator.free(self.releases);
        self.allocator.destroy(self);
    }

    pub fn forVersion(self: *const Self, version: []const u8) ?Release {
        for (self.releases) |release| {
            if (mem.eql(u8, release.version, version)) {
                return release;
            }
        }

        return null;
    }

    pub fn toSliceConst(self: *const Self) []const Release {
        return self.releases;
    }

    fn convert(self: *Self, value: json.Value) ![]const Release {
        var allocator = self.allocator;
        var releases = ArrayList(Release).init(allocator);
        errdefer releases.deinit();

        if (value != .Object) {
            return error.Inconvertible;
        }

        var it = value.Object.iterator();

        while (it.next()) |kv| {
            try releases.append(self.convert_release(kv.key, kv.value) catch |e| switch (e) {
                error.UnsupportedBuildHost => continue,
                else => return e,
            });
        }

        return releases.toOwnedSlice();
    }

    fn convert_release(self: *Self, version: []const u8, value: json.Value) !Release {
        if (value != .Object) {
            return error.Inconvertible;
        }

        var release: Release = undefined;

        release.version = version;

        if (value.Object.getValue("date")) |date| {
            if (date != .String) {
                return error.Inconvertible;
            }

            release.date = date.String;
        } else {
            return error.Inconvertible;
        }

        if (value.Object.getValue("docs")) |docs| {
            if (docs != .String) {
                return error.Inconvertible;
            }

            release.docs = docs.String;
        } else {
            return error.Inconvertible;
        }

        if (value.Object.getValue("notes")) |notes| {
            if (notes != .String) {
                return error.Inconvertible;
            }

            release.notes = notes.String;
        }

        if (value.Object.getValue("src")) |src| {
            release.src = try self.convert_artifact(src);
        } else {
            return error.Inconvertible;
        }

        if (value.Object.getValue(release_bin)) |bin| {
            release.bin = try self.convert_artifact(bin);
        } else {
            return error.UnsupportedBuildHost;
        }

        return release;
    }

    fn convert_artifact(self: *Self, value: json.Value) !Artifact {
        if (value != .Object) {
            return error.Inconvertible;
        }

        var artifact: Artifact = undefined;

        if (value.Object.getValue("tarball")) |tarball| {
            if (tarball != .String) {
                return error.Inconvertible;
            }

            artifact.tarball = tarball.String;
        } else {
            return error.Inconvertible;
        }

        if (value.Object.getValue("shasum")) |shasum| {
            if (shasum != .String) {
                return error.Inconvertible;
            }

            artifact.shasum = shasum.String;
        } else {
            return error.Inconvertible;
        }

        if (value.Object.getValue("size")) |size| {
            if (size != .String) {
                return error.Inconvertible;
            }

            artifact.size = size.String;
        } else {
            return error.Inconvertible;
        }

        return artifact;
    }
};

pub const Release = struct {
    version: []const u8,
    date: []const u8,
    docs: []const u8,
    notes: ?[]const u8,
    src: Artifact,
    bin: Artifact,
};

pub const Artifact = struct {
    tarball: []const u8,
    shasum: []const u8,
    size: []const u8,
};


