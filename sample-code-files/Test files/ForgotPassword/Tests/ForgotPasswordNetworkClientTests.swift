//
//  ForgotPasswordNetworkClientTests.swift
//  PlatformTests
//
//  Created by Vishal Singh on 13/04/20.
//  Copyright © 2020 Gwynniebee. All rights reserved.
//

import Nimble
@testable import Platform

class ForgotPasswordNetworkClientTests: BaseUnitTest {

    var sut: ForgotPasswordNetworkClient!

    override func setUp() {
        super.setUp()

        setupEmptySut()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testErrorReceivedForUnregisteredEmail() {
        let expectedError = NetworkDataProvider.ResponseError(reason: NetworkDataProvider.ResponseError.Reason.server(message: "EMAIL_NOT_MATCH"))
        var receivedError: NetworkDataProvider.ResponseError?

        let expectation = self.expectation(description: "Response Received")
        sut.recoverPassword(for: TestData.LoginNegative.unregisteredEmail) { response in
            switch response {
            case .failure(let error): receivedError = error
            case .success: receivedError = nil
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)

        expect(receivedError) == expectedError
    }

    func testErrorReceivedForRegisteredEmail() {
        let expectedResult: NetworkRequestResult<API.Auth.RecoverPassword.FetchResult> = .success(())
        var receivedResult: NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>?

        let expectation = self.expectation(description: "Response Received")
        sut.recoverPassword(for: TestData.LoginNegative.subscribedUser) { response in
            switch response {
            case .failure: receivedResult = nil
            case .success: receivedResult = response
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)

        expect(receivedResult?.isSuccess) == expectedResult.isSuccess
    }
}

extension ForgotPasswordNetworkClientTests {
    
    fileprivate func setupEmptySut() {
        sut = ForgotPasswordNetworkClient()
    }
}
