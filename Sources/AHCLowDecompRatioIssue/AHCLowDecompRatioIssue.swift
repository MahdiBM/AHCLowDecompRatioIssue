import AsyncHTTPClient

@main
enum Entrypoint {
    static func main() async throws {
        let client = HTTPClient(
            configuration: .init(
                decompression: .enabled(limit: .ratio(10)) /// Current setting: fails
//                decompression: .enabled(limit: .ratio(11)) /// Doesn't fail
            )
        )
        defer {
            try! client.syncShutdown()
        }
        var request = HTTPClientRequest(
            url:  "https://api.github.com/repos/vapor/sql-kit/contributors"
        )
        request.headers.add(name: "User-Agent", value: "AHC-test")
        let response = try await client.execute(request, timeout: .seconds(10))
        let body = try await response.body.collect(upTo: .max)
        print("Success!", String(buffer: body))
    }
}
