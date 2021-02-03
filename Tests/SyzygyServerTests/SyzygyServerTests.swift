import XCTVapor
@testable import SyzygyServer

final class SyzygyServerTests: XCTestCase {
    func testSimple() {
        let expect = expectation(description: "test")
        let server = SyzygyServer(TestServer())
        let app = server.app

        try! app.test(.POST, "test", afterResponse:  { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "\"test\"")
            expect.fulfill()
        })

        waitForExpectations(timeout: 10000)
    }

    func testCustomApp() {
        let expect = expectation(description: "testCustomApp")
        let app = Application(.testing)

        //Expected warning
        let server = SyzygyServer(TestServer(), app: app)

        try! app.test(.POST, "test", afterResponse:  { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "\"test\"")
            expect.fulfill()
        })

        waitForExpectations(timeout: 10000)
    }

    func testComplexReturn() {
        let expect = expectation(description: "testComplexReturn")
        let server = SyzygyServer(TestServer())
        let app = server.app

        try! app.test(.POST, "makeUser", afterResponse:  { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "{\"name\":\"test\",\"id\":-1}")
            expect.fulfill()
        })

        waitForExpectations(timeout: 10000)
    }

    func testArguments() {
        let expect = expectation(description: "testArguments")
        let server = SyzygyServer(TestServer())
        let app = server.app

        try! app.test(.POST, "sum", beforeRequest: { req in
            try req.content.encode(["x":2, "y":3])
        }, afterResponse:  { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "5")
            expect.fulfill()
        })

        waitForExpectations(timeout: 10000)
    }

    func testInvalidArgument() {
        let expect = expectation(description: "testInvalidArgument")
        let server = SyzygyServer(TestServer())
        let app = server.app

        try! app.test(.POST, "sum", beforeRequest: { req in
            try req.content.encode(["x":"two", "y":"three"])
        }, afterResponse:  { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(res.body.string, "{\"error\":true,\"reason\":\"Value of type 'Int' required for key 'x'.\"}")
            expect.fulfill()
        })

        waitForExpectations(timeout: 10000)
    }

    static var allTests = [
        ("testSimple", testSimple),
        ("testCustomApp", testCustomApp),
        ("testComplexReturn", testComplexReturn),
        ("testArguments", testArguments),
        ("testInvalidArgument", testInvalidArgument),
    ]
}
