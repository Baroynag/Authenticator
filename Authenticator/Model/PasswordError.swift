//
//  PasswordError.swift
//  Authenticator
//
//  Created by Anzhela Baroyan on 18.07.2020.
//  Copyright © 2020 Anzhela Baroyan. All rights reserved.
//

import Foundation

enum PasswordError: Error {
    case emptyPassword
    case notConfirmedPassword
    case differentPasswords
}



extension PasswordError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .emptyPassword:
                return NSLocalizedString("Пароль не может быть пустым", comment: "")
            case .notConfirmedPassword:
                return NSLocalizedString("Введие подтверждение пароля!", comment: "")
            case .differentPasswords:
                return NSLocalizedString("Введенные пароли не совпадают", comment: "")
       }
    }
    
    
    static public func cheackPassword(passOne: String?, passTwo: String?) throws -> Bool {
        
        guard let passOne = passOne else {
            throw PasswordError.emptyPassword
        }
        
        if passOne == "" {
            throw PasswordError.emptyPassword
        }
        
        guard let passTwo = passTwo else{
            throw PasswordError.notConfirmedPassword
        }
        
        if passTwo == "" {
            throw PasswordError.notConfirmedPassword
        }
        
        if passOne != passTwo {
            throw PasswordError.differentPasswords
        }
        
        return true
    }
    

}
