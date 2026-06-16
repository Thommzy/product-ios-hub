//
//  AppDIContainer.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

final class AppDIContainer {
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var keychainService: KeychainServiceProtocol = KeychainService()
    lazy var swiftDataStack: SwiftDataStack = SwiftDataStack()

    lazy var productRemoteDataSource: ProductRemoteDataSource =
        ProductRemoteDataSourceImpl(networkService: networkService)
    lazy var productLocalDataSource: ProductLocalDataSource =
        ProductLocalDataSourceImpl(stack: swiftDataStack)
    lazy var favoritesLocalDataSource: FavoritesLocalDataSource =
        FavoritesLocalDataSourceImpl(stack: swiftDataStack)

    lazy var productRepository: ProductRepositoryProtocol =
        ProductRepository(remote: productRemoteDataSource, local: productLocalDataSource)
    lazy var authRepository: AuthRepositoryProtocol =
        AuthRepository(keychainService: keychainService)
    lazy var favoritesRepository: FavoritesRepositoryProtocol =
        FavoritesRepository(local: favoritesLocalDataSource)

    lazy var fetchProductsUseCase: FetchProductsUseCase =
        FetchProductsUseCaseImpl(repository: productRepository)
    lazy var searchProductsUseCase: SearchProductsUseCase =
        SearchProductsUseCaseImpl(repository: productRepository)
    lazy var loginUseCase: LoginUseCase =
        LoginUseCaseImpl(repository: authRepository)
    lazy var biometricUseCase: BiometricUseCase =
        BiometricUseCaseImpl()
    lazy var favoritesUseCase: FavoritesUseCase =
        FavoritesUseCaseImpl(repository: favoritesRepository)
    lazy var crudUseCase: ProductCRUDUseCase =
        ProductCRUDUseCaseImpl(repository: productRepository)
}
