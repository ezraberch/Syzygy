//
//  Response.swift
//  

import Foundation

enum ResponseError : Error {
    case notDictionary
    case notArray
    case memberNotFound
}

///A representation of a JSON object, or a portion of the object.
///It can be traversed using dynamic member lookup and subscript notation.
///
///Used to store the response to a network request.
///
///Can instead hold an error if the response was unsuccessful.
@dynamicMemberLookup
public struct Response : CustomStringConvertible, Collection {
    public func index(after i: Int) -> Int {
        return i+1
    }

    public var startIndex: Int = 0

    public var endIndex: Int {
        if let data = data as? [Any] {
            return data.count
        }
        return 0
    }

    let data: Any?
    let error: Error?

    init(_ data: Any) {
        self.data = data
        self.error = nil
    }

    init(error: Error) {
        self.data = nil
        self.error = error
    }

    ///Traverse the JSON tree, returning a new Response representing an item in a JSON dictionary.
    ///
    ///Usage: response.member
    public subscript(dynamicMember member: String) -> Self {
        guard let data = data as? [String:Any] else {
            print("Error: not dictionary")
            return Response(error: ResponseError.notDictionary)
        }
        guard data.keys.contains(member) else {
            print("Error: member not found")
            return Response(error: ResponseError.memberNotFound)
        }
        return Response(data[member]!)

    }

    ///Traverse the JSON tree, returning a new Response representing an item in a JSON array.
    ///
    ///Usage: response[index]
    public subscript(index: Int) -> Self {
        guard let data = data as? [Any] else {
            print("Error: not array")
            return Response(error: ResponseError.notArray)
        }
        guard data.count > index && index >= 0 else {
            print("Error: member not found")
            return Response(error: ResponseError.memberNotFound)
        }
        return Response(data[index])
    }

    ///Return the data as a String optional.
    public func stringValue() -> String? {
        return data as? String
    }

    ///Return the data as a String, attempting to convert it if it's something else.
    public var description: String {
        if let data = data as? String {
            return data
        }
        if let data = data as? Int {
            return String(data)
        }
        if let data = data as? Double {
            return String(data)
        }
        if let data = data as? Bool {
            return String(data)
        }
        if let data = data as? [Any] {
            return data.description
        }
        if let data = data as? [String:Any] {
            return data.description
        }
        //Should be unreachable
        return ""
    }

    ///Return the data as an Int optional.
    public func intValue() -> Int? {
        return data as? Int
    }

    ///Return the data as a Double optional.
    public func doubleValue() -> Double? {
        return data as? Double
    }

    ///Return the data as aa boolean optional.
    func boolValue() -> Bool? {
        return data as? Bool
    }
}
