const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "raylib_example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const ray_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
    });

    const ray_tc = b.addTranslateC(.{
        .root_source_file = b.addWriteFiles().add("include.h",
            \\#include "raylib.h"
        ),
        .target = target,
        .optimize = optimize,
    });
    ray_tc.addIncludePath(ray_dep.path("src"));

    exe.linkLibrary(ray_dep.artifact("raylib"));
    exe.root_module.addImport("rl", ray_tc.createModule());

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_exe_tests.step);
}
