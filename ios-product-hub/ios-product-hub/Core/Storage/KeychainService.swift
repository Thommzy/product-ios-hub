//
//  KeychainService.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation
import Security

protocol KeychainServiceProtocol {
    func save(_ value: String, forKey key: String)
    func get(forKey key: String) -> String?
    func delete(forKey key: String)
}

final class KeychainService: KeychainServiceProtocol {
    private let queue = DispatchQueue(
        label: "com.producthub.keychain",
        attributes: .concurrent
    )

    func save(_ value: String, forKey key: String) {
        queue.async(flags: .barrier) {
            let data = Data(value.utf8)
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data
            ]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    func get(forKey key: String) -> String? {
        var result: String?
        queue.sync {
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecReturnData: true,
                kSecMatchLimit: kSecMatchLimitOne
            ]
            var item: AnyObject?
            SecItemCopyMatching(query as CFDictionary, &item)
            guard let data = item as? Data else { return }
            result = String(data: data, encoding: .utf8)
        }
        return result
    }

    func delete(forKey key: String) {
        queue.async(flags: .barrier) {
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key
            ]
            SecItemDelete(query as CFDictionary)
        }
    }
}
