// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import SyzygyServer

extension User : Content {}

extension TestServer: SyzygyServerProtocol {
    public func configure(app: Application) {

        app.post("test") { req -> String in
            return "\"\(self.test())\""
        }
    
        app.post("makeUser") { req -> User in
            return self.makeUser()
        }
    
        app.post("sum") { req -> Int in
            struct Arguments : Content {
                let x :  Int
                let y :  Int
            }
            
            let args = try req.content.decode(Arguments.self)
            return self.sum(x: args.x,y: args.y)
        }
    
    }
}
