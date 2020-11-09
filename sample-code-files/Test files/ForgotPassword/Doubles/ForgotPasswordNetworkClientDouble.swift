//
//  ForgotPasswordNetworkClientDouble.swift
//  PlatformTests
//
//  Created by Vishal Singh on 13/04/20.
//  Copyright © 2020 Gwynniebee. All rights reserved.
//

import Foundation
@testable import Platform

struct ForgotPasswordAPIClientDouble: AnyForgotPasswordNetworkClient {
    
    var result: NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>
    
    init(with result: NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>) {
        self.result = result
    }

    func recoverPassword(for email: String, completion: @escaping (NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>) -> Void) {
        completion(self.result)
    }
}
