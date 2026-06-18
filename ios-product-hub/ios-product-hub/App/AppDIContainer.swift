//
//  AppDIContainer.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

final class AppDIContainer {
    private let lock = NSRecursiveLock()

    // MARK: - Core Services

    private var _networkService: NetworkServiceProtocol?
    var networkService: NetworkServiceProtocol {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _networkService { return existing }
        let new = NetworkService()
        _networkService = new
        return new
    }

    private var _keychainService: KeychainServiceProtocol?
    var keychainService: KeychainServiceProtocol {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _keychainService { return existing }
        let new = KeychainService()
        _keychainService = new
        return new
    }

    private var _swiftDataStack: SwiftDataStack?
    var swiftDataStack: SwiftDataStack {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _swiftDataStack { return existing }
        let new = SwiftDataStack()
        _swiftDataStack = new
        return new
    }

    // MARK: - Data Sources

    private var _productRemoteDataSource: ProductRemoteDataSource?
    var productRemoteDataSource: ProductRemoteDataSource {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _productRemoteDataSource { return existing }
        let new = ProductRemoteDataSourceImpl(networkService: networkService)
        _productRemoteDataSource = new
        return new
    }

    private var _productLocalDataSource: ProductLocalDataSource?
    var productLocalDataSource: ProductLocalDataSource {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _productLocalDataSource { return existing }
        let new = ProductLocalDataSourceImpl(stack: swiftDataStack)
        _productLocalDataSource = new
        return new
    }

    private var _favoritesLocalDataSource: FavoritesLocalDataSource?
    var favoritesLocalDataSource: FavoritesLocalDataSource {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _favoritesLocalDataSource { return existing }
        let new = FavoritesLocalDataSourceImpl(stack: swiftDataStack)
        _favoritesLocalDataSource = new
        return new
    }

    // MARK: - Repositories

    private var _productRepository: ProductRepositoryProtocol?
    var productRepository: ProductRepositoryProtocol {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _productRepository { return existing }
        let new = ProductRepository(remote: productRemoteDataSource, local: productLocalDataSource)
        _productRepository = new
        return new
    }

    private var _authRepository: AuthRepositoryProtocol?
    var authRepository: AuthRepositoryProtocol {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _authRepository { return existing }
        let new = AuthRepository(keychainService: keychainService)
        _authRepository = new
        return new
    }

    private var _favoritesRepository: FavoritesRepositoryProtocol?
    var favoritesRepository: FavoritesRepositoryProtocol {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _favoritesRepository { return existing }
        let new = FavoritesRepository(local: favoritesLocalDataSource)
        _favoritesRepository = new
        return new
    }

    // MARK: - Use Cases

    private var _fetchProductsUseCase: FetchProductsUseCase?
    var fetchProductsUseCase: FetchProductsUseCase {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _fetchProductsUseCase { return existing }
        let new = FetchProductsUseCaseImpl(repository: productRepository)
        _fetchProductsUseCase = new
        return new
    }

    private var _searchProductsUseCase: SearchProductsUseCase?
    var searchProductsUseCase: SearchProductsUseCase {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _searchProductsUseCase { return existing }
        let new = SearchProductsUseCaseImpl(repository: productRepository)
        _searchProductsUseCase = new
        return new
    }

    private var _loginUseCase: LoginUseCase?
    var loginUseCase: LoginUseCase {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _loginUseCase { return existing }
        let new = LoginUseCaseImpl(repository: authRepository)
        _loginUseCase = new
        return new
    }

    private var _biometricUseCase: BiometricUseCase?
    var biometricUseCase: BiometricUseCase {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _biometricUseCase { return existing }
        let new = BiometricUseCaseImpl()
        _biometricUseCase = new
        return new
    }

    private var _favoritesUseCase: FavoritesUseCase?
    var favoritesUseCase: FavoritesUseCase {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _favoritesUseCase { return existing }
        let new = FavoritesUseCaseImpl(repository: favoritesRepository)
        _favoritesUseCase = new
        return new
    }

    private var _crudUseCase: ProductCRUDUseCase?
    var crudUseCase: ProductCRUDUseCase {
        lock.lock()
        defer { lock.unlock() }
        if let existing = _crudUseCase { return existing }
        let new = ProductCRUDUseCaseImpl(repository: productRepository)
        _crudUseCase = new
        return new
    }
}
