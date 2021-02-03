import XCTest
@testable import Syzygy

final class SyzygyTests: XCTestCase {
    func testExample() {
        let expect = expectation(description: "test")
        let expect2 = expectation(description: "test2")

        let e = Server(URL(string: "https://jsonplaceholder.typicode.com")!)
        let p = e.posts(title: "qui est esse")

        //Expected warning
        let s = p.sink { response in

            for x in response {
                XCTAssertEqual(x.title.stringValue(), "qui est esse")
                XCTAssertEqual(x.id.intValue(), 2)
            }
            expect.fulfill()
        }
        let e2 = Server(URL(string: "https://jsonplaceholder.typicode.com")!, method: .post)
        let p2 = e2.posts(title: "Title", body: "The Body", userId: 1)
        let s2 = p2.sink { response in
            XCTAssertEqual(response.title.stringValue(), "Title")
            XCTAssertEqual(response.id.intValue(), 101)
            XCTAssertEqual(response.userId.intValue(), 1)
            XCTAssertEqual(response.body.stringValue(), "The Body")
            expect2.fulfill()
        }
        waitForExpectations(timeout: 10000)
    }

    func testStringURL() {
        let expect = expectation(description: "test")

        let e = Server("https://jsonplaceholder.typicode.com")
        let p = e.posts(title: "qui est esse")

        //Expected warning\
        let s = p.sink { response in

            for x in response {
                XCTAssertEqual(x.title.stringValue(), "qui est esse")
                XCTAssertEqual(x.id.intValue(), 2)
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 10000)
    }

    func testServer() {
        let expect = expectation(description: "test")
        let s = Server(URL(string: "http://127.0.0.1:8080")!)
        let ss = s.x().sink { response in
            print(response.x.intValue()!)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10000)
    }

    static var allTests = [
        ("testExample", testExample),
        ("testStringURL", testStringURL),
        ("testServer", testServer),
    ]
}
