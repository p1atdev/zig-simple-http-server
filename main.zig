const print = std.debug.print;
const std = @import("std");
const net = std.net;

pub fn main() anyerror!void {
    var server = net.StreamServer.init(.{});
    defer server.deinit();

    try server.listen(net.Address.parseIp("0.0.0.0", 3000) catch unreachable);

    while (true) {
        const conn: net.StreamServer.Connection = try server.accept();
        var buff: [1024]u8 = undefined;
        const r = conn.stream.reader();
        _ = try r.read(buff[0..]);
        print("Request: {s}\n\n", .{buff});

        var w = conn.stream.writer();

        const msg = "HTTP/1.1 200 OK\r\n\r\nHello, World\n";
        try w.writeAll(msg);
        print("Response: {s}\n\n", .{msg});
    }
}