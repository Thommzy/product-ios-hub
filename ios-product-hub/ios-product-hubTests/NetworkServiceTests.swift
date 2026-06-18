//
//  NetworkServiceTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

import XCTest
@testable import ios_product_hub

final class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    var mockSession: URLSession!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
        sut = NetworkService(session: mockSession)
    }

    func test_request_success_decodesResponse() async throws {
        let products = [Product.mock()]
        let response = ProductResponse(
            products: products, total: 1, skip: 0, limit: 20
        )
        let data = try JSONEncoder().encode(response)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        let result: ProductResponse = try await sut.request(
            .products(limit: 20, skip: 0)
        )
        XCTAssertEqual(result.products.count, 1)
    }

    func test_request_badStatusCode_throwsHTTPError() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        do {
            let _: ProductResponse = try await sut.request(
                .products(limit: 20, skip: 0)
            )
            XCTFail("Expected error")
        } catch NetworkError.httpError(let code) {
            XCTAssertEqual(code, 404)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    func test_request_invalidJSON_throwsDecodingError() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("invalid json".utf8))
        }
        do {
            let _: ProductResponse = try await sut.request(
                .products(limit: 20, skip: 0)
            )
            XCTFail("Expected decoding error")
        } catch NetworkError.decodingFailed {
            // pass
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
}
