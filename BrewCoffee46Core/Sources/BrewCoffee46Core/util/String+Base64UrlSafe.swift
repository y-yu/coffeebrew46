import Foundation

extension String {
    public func encodeUrlSafeBase64() -> String? {
        return self.data(using: .utf8)?.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    public func decodeUrlSafeBase64() -> Self? {
        var base64 =
            self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }

        return Data(base64Encoded: base64).flatMap { data in
            return String(data: data, encoding: .utf8)
        }
    }
}
