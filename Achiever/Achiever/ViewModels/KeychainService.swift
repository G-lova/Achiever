//
//  KeychainService.swift
//  Achiever
//
//  Created by User on 21.02.2024.
//

import UIKit

class KeychainService {
    
    static let shared = KeychainService()
    
    // В связи с невозможностью активировать iCloud на виртуальной машине, база Keychain недоступна.
    // Основные функции, написанные с помощью Keychain, закомментированы и написаны с помощью UserDefaults.
    // При необходимости нужное раскомментировать/закомментировать.
    
    
    
    func savePassword(_ password: String, for account: String) {
        UserDefaults.standard.setValue(password, forKey: account)
    }
    
    func getPassword(forAccount account: String) -> String? {
        return UserDefaults.standard.string(forKey: account) ?? ""
    }
    
    func updatePassword(_ newPassword: String, forAccount account: String) {
        UserDefaults.standard.setValue(newPassword, forKey: account)
    }
    
    func deletePassword(_ password: String, forAccount account: String) {
        if password == getPassword(forAccount: account) {
            UserDefaults.standard.setValue(nil, forKey: account)
        }
    }
    
    
//    func savePassword(_ password: String, for account: String) {
//        let password = password.data(using: .utf8)!
//        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
//                                     kSecAttrAccount as String: account,
//                                     kSecValueData as String: password]
//        let status = SecItemAdd(query as CFDictionary, nil)
//        guard status == errSecSuccess else {
//            return print("save error")
//        }
//    }
//
//    func getPassword(forAccount account: String) -> String? {
//        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
//                                    kSecAttrAccount as String: kSecMatchLimitOne,
//                                    kSecReturnData as String: kCFBooleanTrue!]
//        var getData: AnyObject? = nil
//        let _ = SecItemCopyMatching(query as CFDictionary, &getData)
//        guard let data = getData as? Data else { return nil }
//        return String(data: data, encoding: String.Encoding.utf8)
//    }
//
//    func updatePassword(_ newPassword: String, forAccount account: String) {
//        let newPassword = [kSecValueData: newPassword.data(using: .utf8)!]
//        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
//                                     kSecAttrAccount as String: account]
//        SecItemUpdate(query as CFDictionary, newPassword as CFDictionary)
//    }
//
//    func deletePassword(_ password: String, forAccount account: String) {
//        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
//                                     kSecAttrAccount as String: account,
//                                     kSecValueData as String: password]
//        SecItemDelete(query as CFDictionary)
//    }
    
}
