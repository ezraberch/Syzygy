//
//  Server.swift
//

import Foundation
import Combine

public enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}

///A struct representating an external server using a JSON API
@available(OSX 10.15, *)
@dynamicMemberLookup
@dynamicCallable
public struct Server {
    var request: URLRequest
    var components: URLComponents

    /// Initialze from a URL
    ///
    /// - Parameters:
    ///   - url: Base URL of the server. The only required argument.
    ///   - method: HTTP method to use. Default is GET.
    ///   - queryItems: Query items, if any, to add to all requests using this API.
    ///   - request: A custom URLRequest, if additional customization is needed.
    public init(_ url: URL,
         method: HTTPMethod = .get,
         queryItems: [URLQueryItem] = [],
         request: URLRequest? = nil) {
        if let request = request {
            self.request = request
            self.request.url = url
        } else {
            self.request = URLRequest(url: url)
            self.request.httpMethod = method.rawValue
        }
        components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        if queryItems.count > 0 {
            components.queryItems = queryItems
        }
    }
    /// Initialze from a url representate as a String
    ///
    /// - Parameters:
    ///   - url: Base url of the server, as a String. The only required argument.
    ///   - method: HTTP method to use. Default is GET.
    ///   - queryItems: Query items, if any, to add to all requests using this API.
    ///   - request: A custom URLRequest, if additional customization is needed.
    public init(_ url: String,
         method: HTTPMethod = .get,
         queryItems: [URLQueryItem] = [],
         request: URLRequest? = nil) {
        self.init(URL(string: url)!, method: method, queryItems: queryItems, request: request)
    }


    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, LosslessStringConvertible>) -> AnyPublisher<Response, Never> {
        var components = self.components
        var request = self.request

        if args.count > 0 {
            switch HTTPMethod(rawValue: request.httpMethod ?? "") {
            case .get, .head:
                components.queryItems = args.map {URLQueryItem(name: $0, value: $1.description)}
                request.url = components.url
            case .post, .put, .patch, .delete:
                request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")

                request.httpBody = try! JSONSerialization.data(withJSONObject: Dictionary<String, LosslessStringConvertible>(uniqueKeysWithValues: args.map {($0, $1)}), options: [])
            case .none:
                print("ERROR: Invalid method")
            }
        }
        
        let cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { response in
                do {
                    return Response(try JSONSerialization.jsonObject(with: response.data, options: .allowFragments))
                }
                catch {
                    return Response(error: error)
                }
            }
            .catch { (error) in
                Just(Response(error: error))
            }
            .eraseToAnyPublisher()
            return cancellable
    }

    /// Using dot notation, add a component to the URL of the server, returning a new Server with the data otherwise the same.
    ///
    /// For example, if 'example.com' is the URL stored in 'example', then 'example.path' will return a new Server with the URL 'example.com/path'
    public subscript(dynamicMember member:String) -> Self {
        return Server("\(self.components.url!)/\(member)", queryItems: self.components.queryItems ?? [], request: self.request)
    }
}
