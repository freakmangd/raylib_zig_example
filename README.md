run with `zig build run`

## DIY
1. create a zig project with `zig init -m`
2. you will get this directory structure:
```
.
├── build.zig
└── build.zig.zon
```
3. fetch latest raylib with `zig fetch --save git+https://github.com/raysan5/raylib`
4. set up your `build.zig`, it mentions `src/main.zig` which we will make in step 7:
```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "raylib_example",
        .root_module = b.createModule(.{
            // program entry file
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
            // add more headers here if you need, such as `\\#include "raymath.h"`
            \\#include "raylib.h"
        ),
        .target = target,
        .optimize = optimize,
    });
    ray_tc.addIncludePath(ray_dep.path("src"));

    exe.linkLibrary(ray_dep.artifact("raylib"));
    // change the import name here if you want
    exe.root_module.addImport("rl", ray_tc.createModule());

    b.installArtifact(exe);
}
```
5. you can now use `@import("rl")` to access any of raylib's functions
6. minimal `main.zig` for a visible window:
```zig
const std = @import("std");
const rl = @import("rl");

pub fn main() !void {
    rl.InitWindow(800, 600, "window");
    defer rl.CloseWindow();

    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        defer rl.EndDrawing();
    }
}
```
