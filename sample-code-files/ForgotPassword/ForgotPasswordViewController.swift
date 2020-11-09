//
//  ForgotPasswordViewController.swift
//  Platform

import UIKit

class ForgotPasswordViewController: PortraitViewController, ContentLoadable, AccessibilityIdentifierSetter {
    
    var viewModel: ForgotPasswordPresentable!
    let config = Style.forgotPasswordConfig

    init(with viewModel: ForgotPasswordPresentable) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ForgotPasswordViewController.self), bundle: nil)
        extendedLayoutIncludesOpaqueBars = true
        self.viewModel.viewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel! {
        didSet {
            navigationTitleLabel.text = Asset.String.fonrgotPassword
        }
    }
    // Might be used to change color
    @IBOutlet weak var navigationSeparator: UIView!
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var enterEmailPromptLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var returnToLoginButton: UIButton!
    @IBOutlet weak var emailSentInfoLabel: UILabel!
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyling()

        emailTextField.text = viewModel.emailFromLogin
        let isEnabled = !(viewModel.emailFromLogin?.isEmpty ?? true)
        sendEmailButton.setEnabled(isEnabled, with: config.sendEmailButton)
        updateState(viewModel.state)
        view.addGestureRecognizer(tapGestureRecognizer)

        setupAccessebilityIds()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        enableSwipeToGoBack()
        GAHelper.shared.set(screen: .PasswordReset, loggedInStatus: .NonLoggedIn)
    }
    
    private func setupAccessebilityIds() {
        typealias Id = AccessibilityIdentifier.ForgotPasswordViewController
        setupAccessibilityIdentifiers(from: [
            (backButton, Id.backButton),
            (navigationTitleLabel, Id.navigationTitleLabel),
            (navigationSeparator, Id.navigationSeparator),
            (emailTextField, Id.emailTextField),
            (enterEmailPromptLabel, Id.enterEmailPromptLabel),
            (sendEmailButton, Id.sendEmailButton),
            (returnToLoginButton, Id.returnToLoginButton),
            (emailSentInfoLabel, Id.emailSentInfoLabel),
            ])
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        viewModel.onBackTap()
    }
    
    @IBAction func sendEmailButtonTapped(_ sender: Any) {
        viewModel.onSendEmailTap(email: emailTextField.text)
    }
    
    @IBAction func returnToLoginButtonTapped(_ sender: Any) {
        viewModel.onReturnToLoginTap()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(true)
    }

    func setupStyling() {
        navigationTitleLabel.applyStyle(config.navigationTitleLabel, text: Asset.String.fonrgotPassword.capitalized, textAlignment: .center)
        emailTextField.applyStyle(config.emailTextField, placeholder: Asset.String.email.capitalized)
        enterEmailPromptLabel.applyStyle(config.enterEmailPromptLabel, text: Asset.String.resetPasswordEnterEmailPrompt, textAlignment: .center)
        sendEmailButton.applyStyle(config.sendEmailButton, text: Asset.String.send.uppercased())
        returnToLoginButton.applyStyle(config.returnToLoginButton, text: Asset.String.resetPasswordReturnToLogin.uppercased())
        emailSentInfoLabel.applyStyle(config.emailSentInfoLabel, text: Asset.String.resetPasswordEmailSent, textAlignment: .center)
    }
}

extension ForgotPasswordViewController: ForgotPasswordViewDelegate {
    
    fileprivate func updateEmailTextFieldWithError(_ emailError: String?) {
        let config = Style.forgotPasswordConfig
        emailErrorLabel.applyStyle(config.emailErrorLabel, text: emailError ?? "", textAlignment: .right)
        emailTextField.updateErrorStatus(hasError: emailError != nil, with: config.emailTextField)
    }
    
    fileprivate func updateVisibilityOfSubviews(_ isEmailSent: Bool?) {
        guard let isEmailSent = isEmailSent else { return }
        backButton.isHidden = isEmailSent
        enterEmailPromptLabel.isHidden = isEmailSent
        emailTextField.isHidden = isEmailSent
        sendEmailButton.isHidden = isEmailSent
        
        emailSentInfoLabel.isHidden = !isEmailSent
        returnToLoginButton.isHidden = !isEmailSent
    }
    
    func updateState(_ state: ForgotPasswordScreenState) {
        var emailError: String?
        let isEmailSent: Bool? = {
            switch state {
            case .enterEmail(let error):
                indicateStopLoadingWithGrayBackground()
                emailError = error
                return false
            case .loading:
                view.endEditing(true)
                indicateStartLoadingWithGrayBackground()
                return nil
            case .emailSent:
                view.endEditing(true)
                disableSwipeToGoBack()
                indicateStopLoadingWithGrayBackground()
                return true
            }
        }()
        updateVisibilityOfSubviews(isEmailSent)
        updateEmailTextFieldWithError(emailError)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        GAHelper.shared.sendAnalytic(event: AnalyticsActionFactory.forgotPassword(action: .TapEnterEmail))
        tapGestureRecognizer.isEnabled = true
        updateEmailTextFieldWithError(nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let email = emailTextField.text, !email.isEmpty {
            viewModel.onSendEmailTap(email: email)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tapGestureRecognizer.isEnabled = false
        let isEnabled = !(textField.text?.isEmpty ?? true)
        sendEmailButton.setEnabled(isEnabled, with: config.sendEmailButton)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            let isEnabled = !updatedText.isEmpty
            sendEmailButton.setEnabled(isEnabled, with: config.sendEmailButton)
        }
        return true
    }
}
