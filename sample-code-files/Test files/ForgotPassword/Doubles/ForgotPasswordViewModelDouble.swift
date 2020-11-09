//
//  ForgotPasswordViewModelDouble.swift
//  PlatformTests
//
//  Created by Vishal Singh on 17/06/19.
//  Copyright © 2019 Gwynniebee. All rights reserved.
//

@testable import Platform

class ForgotPasswordViewModelDouble: ForgotPasswordPresentable {

    var state: ForgotPasswordScreenState = .enterEmail(nil)
    var viewDelegate: ForgotPasswordViewDelegate?
    var emailFromLogin: String?
    
    var isOnBackTapInvoked: Bool = false
    var email: String?
    var isOnReturnToLoginTapInvoked: Bool = false
    
    func onBackTap() {
        isOnBackTapInvoked = true
    }
    
    func onSendEmailTap(email: String?) {
        self.email = email
    }
    
    func onReturnToLoginTap() {
        isOnReturnToLoginTapInvoked = true
    }
}
