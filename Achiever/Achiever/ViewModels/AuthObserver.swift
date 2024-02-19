//
//  AuthObserver.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit

class AuthObserver {
    
    var authViewModel: AuthViewModelDelegate
    
    init(authViewModel: AuthViewModelDelegate) {
        self.authViewModel = authViewModel
    }
    
    func startObserving() {
        
    }
}
