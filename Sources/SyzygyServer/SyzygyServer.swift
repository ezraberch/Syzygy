import Foundation
import Vapor

public protocol SyzygyServer2 {
}

public protocol SyzygyServerProtocol {
    func configure(app: Application)
}

/// Used in code generation when response type isn't a simple type
public struct SyzygyResponse<T: Codable> : Content {
    public init(response: T) {
        self.response = response
    }
    public var response: T
}

public class SyzygyServer {
    public var app : Application

    /// Create a Syzygy Server using an existing Vapor Application
    ///
    /// - Parameters:
    ///   - server: Instance of the class which contains the endpoints of the server. Code generation will add protocol compliance.
    ///   - app: Existing Vapor Application to use
    public init(_ server: SyzygyServerProtocol, app: Application) {
        self.app = app
        server.configure(app: app)
    }

    /// Create a Syzygy server, creating a new Vapor application
    ///
    /// - Parameters:
    ///   - server: Instance of the class which contains the endpoints of the server. Code generation will add protocol compliance.
    public convenience init(_ server: SyzygyServerProtocol) {
        let env = try! Environment.detect()
        let app = Application(env)
        self.init(server, app: app)

    }

    deinit {
        app.shutdown()
    }
}
