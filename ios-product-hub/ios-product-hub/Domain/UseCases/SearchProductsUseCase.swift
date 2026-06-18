//
//  SearchProductsUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//
import Foundation

protocol SearchProductsUseCase {
    func execute(query: String, limit: Int, skip: Int) async throws -> ProductResponse
}

final class SearchProductsUseCaseImpl: SearchProductsUseCase {
    private let repository: ProductRepositoryProtocol
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    func execute(query: String, limit: Int, skip: Int) async throws -> ProductResponse {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw SearchError.emptyQuery
        }
        guard query.count >= 2 else {
            throw SearchError.queryTooShort
        }
        return try await repository.searchProducts(
            query: query.trimmingCharacters(in: .whitespaces),
            limit: limit,
            skip: skip
        )
    }
}

enum SearchError: LocalizedError {
    case emptyQuery
    case queryTooShort

    var errorDescription: String? {
        switch self {
        case .emptyQuery: return "Search query cannot be empty"
        case .queryTooShort: return "Search query must be at least 2 characters"
        }
    }
}
