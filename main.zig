const print = std.debug.print;
const std = @import("std");
const net = std.net;

pub fn main() anyerror!void {
    var server = net.StreamServer.init(.{});
    defer server.deinit();

    try server.listen(net.Address.parseIp("0.0.0.0", 3000) catch unreachable);

    while (true) {
        const conn: net.StreamServer.Connection = try server.accept();

        // バッファで、ここに読んだデータが入る。ポインタ使わない文化圏の私からすると変な感じする。
        var buff: [1024]u8 = undefined;

        const r = conn.stream.reader();
        _ = try r.read(buff[0..]);
        print("Request: {s}\n\n", .{buff});

        var w = conn.stream.writer();
        
        // \r\n\r\n はお約束的な感じ。どうでもいいわけじゃないよ！
        const msg = "HTTP/1.1 200 OK\r\n\r\nHello, World\n";
        try w.writeAll(msg);
        print("Response: {s}\n\n", .{msg});
    }
}