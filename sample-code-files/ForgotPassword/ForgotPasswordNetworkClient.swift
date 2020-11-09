//
//  ForgotPasswordAPIClient.swift
//  Platform

import Foundation

protocol AnyForgotPasswordNetworkClient {

    func recoverPassword(for email: String, completion: @escaping (NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>) -> Void)
}

extension AnyForgotPasswordNetworkClient {

    func recoverPassword(for email: String, completion: @escaping (NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>) -> Void) {
        API.Auth.RecoverPassword(email: email).run { result in
            completion(result)
        }
    }
}

struct ForgotPasswordNetworkClient: AnyForgotPasswordNetworkClient {
}
