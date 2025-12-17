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
