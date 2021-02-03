//
//  TestServer.swift
//  

//To update generated file, use sourcery --sources TestServer.swift --templates ../../Sources/SyzygyServer/ServerTemplate.swifttemplate

import Foundation
import SyzygyServer

class User : Codable
{
    var name: String
    var id: Int
}

// sourcery: SyzygyServer
class TestServer : SyzygyServer2 {
    func test() -> String {
        return "test"
    }

    func makeUser() -> User {
        return User(name: "test", id: -1)
    }

    func sum(x: Int, y: Int) -> Int {
        return x+y
    }
}
