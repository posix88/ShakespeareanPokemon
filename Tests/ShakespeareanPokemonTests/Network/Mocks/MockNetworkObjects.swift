//
//  MockNetworkObjects.swift
//  ShakespeareanPokemon
//
//  Created by Antonino Musolino on 18/04/25.
//

import Foundation
@testable import ShakespeareanPokemon

final class MockNetworkSession: NetworkSession {
    var invokedDataFromURL: Bool = false
    var invokedDataFromURLParameter: URL!
    var stubbedDataFromURLResult: (data: Data, response: URLResponse)!
    var stubbedDataFromURLError: Error?
    func data(from url: URL) async throws -> (data: Data, response: URLResponse) {
        invokedDataFromURL = true
        invokedDataFromURLParameter = url
        if let stubbedDataFromURLError {
            throw stubbedDataFromURLError
        }
        return stubbedDataFromURLResult
    }
    
    var invokedDataForRequest: Bool = false
    var invokedDataForRequestParameter: URLRequest!
    var stubbedDataForRequestResult: (data: Data, response: URLResponse)!
    var stubbedDataForRequestError: Error?

    func data(for request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        invokedDataForRequest = true
        invokedDataForRequestParameter = request
        if let stubbedDataForRequestError {
            throw stubbedDataForRequestError
        }
        return stubbedDataForRequestResult
    }
}

final class MockURLParameterEncoder: URLParameterEncoderType {
    var invokedEncode: Bool = false
    var invokedEncodeParameters: (request: URLRequest, parameters: ShakespeareanPokemon.Parameters?)!
    var stubbedError: NetworkError?
    func encode(urlRequest: inout URLRequest, with parameters: ShakespeareanPokemon.Parameters?) throws(NetworkError) {
        invokedEncode = true
        invokedEncodeParameters = (urlRequest, parameters)
        if let stubbedError {
            throw stubbedError
        }
    }
}


final class MockNetworkLayer: NetworkLayer {
    var requestInvoked: Bool = false
    var requestInvokedCount: Int = .zero
    var requestParameters: (any ShakespeareanPokemon.Service)!
    var stubbedRequestData: Data!
    var stubbedRequestError: NetworkError?
    func request(_ service: any ShakespeareanPokemon.Service) async throws -> Data {
        requestInvoked = true
        requestInvokedCount += 1
        requestParameters = service
        if let stubbedRequestError {
            throw stubbedRequestError
        }
        return stubbedRequestData
    }

    var fetchDataInvoked: Bool = false
    var fetchDataParameters: URL!
    var fetchDataStubbedData: Data!
    var stubbedFetchDataError: NetworkError?
    func fetchData(from url: URL) async throws -> Data {
        fetchDataInvoked = true
        fetchDataParameters = url
        if let stubbedFetchDataError {
            throw stubbedFetchDataError
        }
        return fetchDataStubbedData
    }
}
