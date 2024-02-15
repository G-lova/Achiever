//
//  UIIntegrationStrategy.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit
class UIIntegrationStrategy {
    
    var userActionsDelegate: UserActionsDelegate
    
    init(userActionsDelegate: UserActionsDelegate) {
        self.userActionsDelegate = userActionsDelegate
    }
    
    func configureUI() {
        
    }
}
