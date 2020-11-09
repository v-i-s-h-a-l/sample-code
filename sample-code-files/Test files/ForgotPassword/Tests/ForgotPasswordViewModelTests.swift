//
//  ForgotPasswordViewModelTests.swift
//  PlatformTests
//
//  Created by Vishal Singh on 17/06/19.
//  Copyright © 2019 Gwynniebee. All rights reserved.
//

import Nimble
@testable import Platform

class ForgotPasswordViewModelTests: BaseUnitTest {
    
    var sut: ForgotPasswordViewModel!
    var viewDelegateDouble: ForgotPasswordViewDelegateDouble!
    var delegateDouble: LoginCoordinatorDouble!
    
    private let dummyError: NetworkRequestResult = NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>.failure(NetworkDataProvider.ResponseError(reason: NetworkDataProvider.ResponseError.Reason.server(message: "EMAIL_NOT_MATCH")))
    private let dummySuccessfulResponse: NetworkRequestResult = NetworkRequestResult<API.Auth.RecoverPassword.FetchResult>.success(())
    
    override func setUp() {
        super.setUp()

        setupDummySut()
    }
    
    override func tearDown() {
        sut = nil
        delegateDouble = nil
        viewDelegateDouble = nil

        super.tearDown()
    }
    
    // Tests
    
    func testInitializer() {
        // Given
        let testEmail = TestData.string(withNumber: 1)
        
        // When
        setupDummySut(with: testEmail)
        
        // Then
        expect(self.sut).toNot(beNil())
        expect(self.sut.emailFromLogin) == testEmail
    }
    
    func testSettingStateInvokesViewDelegate() {
        // Given
        let state = ForgotPasswordScreenState.emailSent
        setupViewDelegate()
        
        // When
        sut.state = state
        
        // Then
        expect(self.viewDelegateDouble.updatedState) == state
    }

    func testOnBackTapInvokesDelegate() {
        // Given
        setupDelegate()
        
        // When
        sut.onBackTap()
        
        // Then
        expect(self.delegateDouble.isGoBackInvoked) == true
    }
    
    func testSendEmailWithInvalidEmailSetsEnterEmailStateWithError() {
        // Given
        let email = TestData.string(withNumber: 1)
        let errorMessage = EmailValidator.validate(string: email)?.localizedDescription
        let expectedState = ForgotPasswordScreenState.enterEmail(errorMessage)
        
        // When
        sut.onSendEmailTap(email: email)
        
        // Then
        expect(self.sut.state) == expectedState
    }

    func testSendEmailWithValidEmailSetsLoadingStateBeforeNetworkResponse() {
        // Given
        let email = TestData.LoginNegative.unregisteredEmail
        
        // When
        sut.onSendEmailTap(email: email)
        
        // Then
        expect(self.sut.state) == .loading
    }

    func testSendEmailWithNonExistingEmailAfterNetworkResponse() {
        // Given
        let email = TestData.LoginNegative.unregisteredEmail
        sut = ForgotPasswordViewModel(with: email, networkClient: ForgotPasswordAPIClientDouble(with: dummyError))

        // When
        sut.onSendEmailTap(email: email)
        
        // Then
        expect(self.sut.state) == .enterEmail(Asset.String.accountDoesNotExist)
    }

    func testSendEmailWithExistingEmailAfterNetworkResponse() {
        // Given
        let email = TestData.LoginNegative.subscribedUser
        sut = ForgotPasswordViewModel(with: email, networkClient: ForgotPasswordAPIClientDouble(with: dummySuccessfulResponse))

        // When
        sut.onSendEmailTap(email: email)
        
        // Then
        expect(self.sut.state) == .emailSent
    }
    
    func testOnReturnToLoginTapInvokesDelegate() {
        // Given
        setupDelegate()
        
        // When
        sut.onReturnToLoginTap()
        
        // Then
        expect(self.delegateDouble.isGoBackInvoked) == true
    }
}

extension ForgotPasswordViewModelTests {
    
    fileprivate func setupDummySut(with email: String? = nil) {
        sut = ForgotPasswordViewModel(with: email)
    }

    fileprivate func setupDelegate() {
        delegateDouble = LoginCoordinatorDouble()
        sut.delegate = delegateDouble
    }

    fileprivate func setupViewDelegate() {
        viewDelegateDouble = ForgotPasswordViewDelegateDouble()
        sut.viewDelegate = viewDelegateDouble
    }
}
