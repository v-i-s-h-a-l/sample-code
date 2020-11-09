//
//  ForgotPasswordViewControllerTests.swift
//  PlatformTests
//
//  Created by Vishal Singh on 17/06/19.
//  Copyright © 2019 Gwynniebee. All rights reserved.
//

import Nimble
@testable import Platform

class ForgotPasswordViewControllerTests: BaseUnitTest, TestsViewController {
    var viewController: UIViewController { return sut }
    
    var sut: ForgotPasswordViewController!
    var viewModelDouble: ForgotPasswordViewModelDouble!
    
    override func setUp() {
        super.setUp()

        setupEmptySut()
    }
    
    override func tearDown() {
        sut = nil
        viewModelDouble = nil
        
        super.tearDown()
    }
    
    // Tests
    
    func testInitializer() {
        // Then
        expect(self.sut).toNot(beNil())
        expect(self.sut.viewModel).toNot(beNil())
        expect(self.viewModelDouble.viewDelegate).toNot(beNil())
    }

    func testPassingEmailFromLoginSetsEmailInTextField() {
        // Given
        let email = TestData.LoginNegative.subscribedUser
        setupDummySut(with: email)
        
        // When
        invokeViewDidLoad()
        
        // Then
        expect(self.sut.emailTextField.text) == email
    }

    func testOutletsNotNil() {
        // When
        invokeViewDidLoad()
        
        // Then
        expect(self.sut.backButton).toNot(beNil())
        expect(self.sut.navigationTitleLabel).toNot(beNil())
        expect(self.sut.navigationSeparator).toNot(beNil())
        expect(self.sut.emailTextField).toNot(beNil())
        expect(self.sut.enterEmailPromptLabel).toNot(beNil())
        expect(self.sut.sendEmailButton).toNot(beNil())
        expect(self.sut.emailSentInfoLabel).toNot(beNil())
        expect(self.sut.returnToLoginButton).toNot(beNil())
    }

    func testBackButtonTappedInvokesViewModel() {
        // When
        sut.backButtonTapped(UIButton())

        // Then
        expect(self.viewModelDouble.isOnBackTapInvoked) == true
    }
    
    func testSendEmailButtonTappedInvokesViewModelWithEmail() {
        // Given
        let email = TestData.LoginNegative.subscribedUser
        setupDummySut(with: email)
        invokeViewDidLoad()

        // When
        sut.sendEmailButtonTapped(UIButton())
        
        // Then
        expect(self.viewModelDouble.email) == email
    }
    
    func testReturnToLoginTappedInvokesViewModel() {
        // When
        sut.returnToLoginButtonTapped(UIButton())
        
        // Then
        expect(self.viewModelDouble.isOnReturnToLoginTapInvoked) == true
    }
    
    func testStringsSetCorrectlyOnViewDidLoad() {
        // When
        invokeViewDidLoad()

        // Then
        expect(self.sut.navigationTitleLabel.attributedText?.string) == Asset.String.fonrgotPassword.capitalized
        
        expect(self.sut.enterEmailPromptLabel.attributedText?.string) == Asset.String.resetPasswordEnterEmailPrompt
        expect(self.sut.sendEmailButton.attributedTitle(for: .normal)?.string) == Asset.String.send.uppercased()
        expect(self.sut.returnToLoginButton.attributedTitle(for: .normal)?.string) == Asset.String.resetPasswordReturnToLogin.uppercased()
        expect(self.sut.emailSentInfoLabel.attributedText?.string) == Asset.String.resetPasswordEmailSent
    }

    fileprivate func verifySubviews(state: ForgotPasswordScreenState, isEmailSent: Bool, isEmailError: Bool, emailErrorString: String?) {
        invokeViewDidLoad()
        
        // When
        sut.updateState(state)
        
        // Then
        expect(self.sut.backButton.isHidden) == isEmailSent
        expect(self.sut.enterEmailPromptLabel.isHidden) == isEmailSent
        expect(self.sut.emailTextField.isHidden) == isEmailSent
        expect(self.sut.sendEmailButton.isHidden) == isEmailSent
        
        expect(self.sut.emailSentInfoLabel.isHidden) == !isEmailSent
        expect(self.sut.returnToLoginButton.isHidden) == !isEmailSent
        
        expect(self.sut.emailErrorLabel.attributedText?.string) == emailErrorString ?? ""
    }
    
    func testUpdateStateWithEnterEmailWithoutErrorState() {
        // Given
        let emailError: String? = nil
        let state = ForgotPasswordScreenState.enterEmail(emailError)
        let isEmailSent = false
        let isEmailError = false
        
        // Then
        verifySubviews(state: state, isEmailSent: isEmailSent, isEmailError: isEmailError, emailErrorString: emailError)
    }

    func testUpdateStateWithEnterEmailWithErrorInEmail() {
        // Given
        let emailError: String? = "Invalid Email"
        let state = ForgotPasswordScreenState.enterEmail(emailError)
        let isEmailSent = false
        let isEmailError = true

        // Then
        verifySubviews(state: state, isEmailSent: isEmailSent, isEmailError: isEmailError, emailErrorString: emailError)
    }

    func testUpdateStateWithEmailSentState() {
        // Given
        let emailError: String? = nil
        let state = ForgotPasswordScreenState.emailSent
        let isEmailSent = true
        let isEmailError = false
        
        // Then
        verifySubviews(state: state, isEmailSent: isEmailSent, isEmailError: isEmailError, emailErrorString: emailError)
    }

    func testTextFieldDidBeginEditingEnablesTapGesture() {
        // Given
        invokeViewDidLoad()
        
        // When
        sut.textFieldDidBeginEditing(UITextField())

        // Then
        expect(self.sut.tapGestureRecognizer.isEnabled) == true
    }

    func testTextFieldShouldReturnWhenEmailFieldNotEmptyInvokesViewModel() {
        // Given
        let text = "A"
        invokeViewDidLoad()
        sut.emailTextField.text = text
        
        // When
        _ = sut.textFieldShouldReturn(UITextField())
        
        // Then
        expect(self.viewModelDouble.email) == text
    }

    func testTextFieldShouldReturnWhenEmailFieldEmptyDoesNotInvokeViewModel() {
        // Given
        let text = ""
        invokeViewDidLoad()
        sut.emailTextField.text = text
        
        // When
        _ = sut.textFieldShouldReturn(UITextField())
        
        // Then
        expect(self.viewModelDouble.email).to(beNil())
    }

    func testTextFieldDidEndEditingWithNoTextDisablesSendButton() {
        // Given
        let text = ""
        invokeViewDidLoad()
        sut.emailTextField.text = text
        
        // When
        _ = sut.textFieldDidEndEditing(sut.emailTextField)
        
        // Then
        expect(self.sut.tapGestureRecognizer.isEnabled) == false
        expect(self.sut.sendEmailButton.isEnabled) == false
    }

    func testTextFieldDidEndEditingWithSomeTextEnablesSendButton() {
        // Given
        let text = "ABC"
        invokeViewDidLoad()
        sut.emailTextField.text = text
        
        // When
        _ = sut.textFieldDidEndEditing(sut.emailTextField)
        
        // Then
        expect(self.sut.tapGestureRecognizer.isEnabled) == false
        expect(self.sut.sendEmailButton.isEnabled) == true
    }
}

extension ForgotPasswordViewControllerTests {
    
    fileprivate func setupEmptySut() {
        viewModelDouble = ForgotPasswordViewModelDouble()
        sut = ForgotPasswordViewController(with: viewModelDouble)
    }
    
    fileprivate func setupDummySut(with email: String = "") {
        viewModelDouble = ForgotPasswordViewModelDouble()
        viewModelDouble.emailFromLogin = email
        sut = ForgotPasswordViewController(with: viewModelDouble)
    }
}
