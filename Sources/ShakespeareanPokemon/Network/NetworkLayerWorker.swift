//
//  NetworkLayerWorker.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation   

// MARK: - Protocols

/// A protocol designed to abstract a network layer capable of making requests and returning raw `Data`.
protocol NetworkLayer: Sendable {
    /// Executes a network request for a given `Service`.
    ///
    /// - Parameter service: The `Service` describing the request.
    /// - Returns: The raw `Data` received from the response.
    /// - Throws: `NetworkError` or other thrown errors during request building or execution.
    func request(_ service: any Service) async throws -> Data

    /// Fetches raw `Data` directly from a given `URL`, without using a `Service` abstraction.
    ///
    /// This method is useful for downloading resources such as images, files, or performing lightweight requests
    /// that don't require headers, parameters, or HTTP method customization.
    ///
    /// - Parameter url: The `URL` to fetch data from.
    /// - Returns: The raw `Data` received from the response.
    /// - Throws: `NetworkError` or other thrown errors during execution.
    func fetchData(from url: URL) async throws -> Data
}

/// A protocol that abstracts the executor of the network call to allow more flexible and testable network interactions.
protocol NetworkSession: Sendable {
    /// Executes a data task for the specified `URLRequest`.
    ///
    /// - Parameter request: The request to be sent.
    /// - Returns: A tuple containing the `Data` and `URLResponse` received.
    /// - Throws: An error if the network request fails.
    func data(for request: URLRequest) async throws -> (data: Data, response: URLResponse)

    /// Executes a data task for the specified `URL`.
    ///
    /// This is a convenience method for simple requests that don’t require a custom `URLRequest`.
    ///
    /// - Parameter url: The URL to send the request to.
    /// - Returns: A tuple containing the `Data` and `URLResponse` received.
    /// - Throws: An error if the network request fails.
    func data(from url: URL) async throws -> (data: Data, response: URLResponse)
}

// MARK: - URLSession conformance

/// Extends `URLSession` to conform to `NetworkSession`, enabling dependency injection.
extension URLSession: NetworkSession {
    func data(from url: URL) async throws -> (data: Data, response: URLResponse) {
        print("🚀 Calling:", url.absoluteString ?? "nil")
        return try await data(from: url, delegate: nil)
    }
    
    func data(for request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        print("🚀 Calling:", request.url?.absoluteString ?? "nil")
        return try await data(for: request, delegate: nil)
    }
}

// MARK: - NetworkLayerWorker

/// An object responsible for building requests and handling responses for a given `Service`.
///
/// `NetworkLayerWorker` uses a `NetworkSession` (typically `URLSession`) and a `URLParameterEncoderType`
/// to decouple dependencies, allowing for flexible and testable networking code.
struct NetworkLayerWorker: NetworkLayer {
    private let session: any NetworkSession
    private let urlEncoder: any URLParameterEncoderType

    init(
        session: any NetworkSession = URLSession.shared,
        urlEncoder: any URLParameterEncoderType = URLParameterEncoder()
    ) {
        self.session = session
        self.urlEncoder = urlEncoder
    }

    /// Executes a network request and handles the response.
    ///
    /// - Parameter service: The `Service` to request.
    /// - Returns: The raw `Data` from the response.
    /// - Throws:
    ///   - `NetworkError.responseIssue` if the response contains an unsuccessful HTTP status code.
    ///   - `NetworkError.noData` if the response is empty.
    ///   - `NetworkError.unknownError` for any other error encountered during the request.
    func request(_ service: any Service) async throws -> Data {
        do {
            let request = try buildRequest(from: service)
            let response = try await session.data(for: request)
            return try handleResponse(response)
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.unknownError(error)
        }
    }

    /// Fetches raw `Data` directly from the specified `URL` using the underlying network session.
    ///
    /// This method is ideal for lightweight network operations that don't require request customization,
    /// such as downloading images or static files.
    ///
    /// - Parameter url: The URL to send the request to.
    /// - Returns: The raw `Data` received from the response.
    /// - Throws:
    ///   - `NetworkError.responseIssue` if the response contains an unsuccessful HTTP status code.
    ///   - `NetworkError.noData` if the response is empty.
    ///   - `NetworkError.unknownError` for any other error encountered during the request.
    func fetchData(from url: URL) async throws -> Data {
        do {
            let response = try await session.data(from: url)
            return try handleResponse(response)
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.unknownError(error)
        }
    }
}

// MARK: - Request building

private extension NetworkLayerWorker {
    /// Builds a `URLRequest` from a given `Service`.
    ///
    /// - Parameter service: The `Service` containing all the request details.
    /// - Returns: A fully configured `URLRequest`.
    /// - Throws: An error if encoding the parameters fails.
    func buildRequest(from service: any Service) throws(NetworkError) -> URLRequest {
        var request = URLRequest(url: service.endpoint,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        do throws(NetworkError) {
            try urlEncoder.encode(urlRequest: &request, with: service.parameters)
        } catch {
            throw error
        }
        return request
    }
}

// MARK: - Response Handling

private extension NetworkLayerWorker {
    /// Validates and interprets the network response.
    ///
    /// - Parameter result: A tuple of `Data` and `URLResponse` from the request.
    /// - Returns: The `Data` if the request was successful.
    /// - Throws:
    ///   - `NetworkError.responseIssue` if the response contains an unsuccessful HTTP status code.
    ///   - `NetworkError.noData` if the response is empty.
    func handleResponse(_ result: (data: Data, response: URLResponse)) throws(NetworkError) -> Data {
        guard let httpURLResponse = result.response as? HTTPURLResponse else { throw NetworkError.noData }
        let responseStatus = responseStatus(for: httpURLResponse)
        if responseStatus == .success {
            if !result.data.isEmpty {
                return result.data
            } else {
                throw NetworkError.noData
            }
        } else {
            throw NetworkError.responseIssue(responseStatus)
        }
    }

    /// Maps an `HTTPURLResponse` status code to a `NetworkResponse` enum.
    ///
    /// - Parameter response: The HTTP response to evaluate.
    /// - Returns: The corresponding `NetworkResponse` based on the status code.
    func responseStatus(for response: HTTPURLResponse) -> NetworkResponse {
        switch response.statusCode {
        case 200...299:
            return .success
        case 400:
            return .badRequest
        case 401, 403:
            return .authenticationError
        case 404, 405, 406:
            return .notFound
        case 500...599:
            return .serverError // server-side errors
        default:
            return .failed
        }
    }
}
