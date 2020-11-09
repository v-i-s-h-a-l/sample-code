//
//  ForgotPasswordScreenState.swift
//  Platform
//
//  Created by Vishal Singh on 17/06/19.
//  Copyright © 2019 Gwynniebee. All rights reserved.
//

enum ForgotPasswordScreenState: Equatable {
    case enterEmail(_ emailError: String?), emailSent, loading
    
    static func == (lhs: ForgotPasswordScreenState, rhs: ForgotPasswordScreenState) -> Bool {
        switch (lhs, rhs) {
        case (.enterEmail(let e1), .enterEmail(let e2)):
            return e1 == e2
        case (.loading, .loading):
            return true
        case (.emailSent, .emailSent):
            return true
        default:
            return false
        }
    }
}
