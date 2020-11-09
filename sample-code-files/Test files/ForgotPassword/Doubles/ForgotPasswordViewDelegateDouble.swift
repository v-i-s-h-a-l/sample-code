//
//  ForgotPasswordViewDelegateDouble.swift
//  PlatformTests
//
//  Created by Vishal Singh on 17/06/19.
//  Copyright © 2019 Gwynniebee. All rights reserved.
//

@testable import Platform

class ForgotPasswordViewDelegateDouble: ForgotPasswordViewDelegate {

    var updatedState: ForgotPasswordScreenState?
    
    func updateState(_ state: ForgotPasswordScreenState) {
        updatedState = state
    }
}
