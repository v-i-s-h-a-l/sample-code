//
//  ForgotPasswordViewModel.swift
//  Platform

protocol ForgotPasswordViewDelegate: class {
    func updateState(_ state: ForgotPasswordScreenState)
}

protocol ForgotPasswordPresentable: class {
    var state: ForgotPasswordScreenState { get set }
    var viewDelegate: ForgotPasswordViewDelegate? { get set }
    var emailFromLogin: String? { get }
    func onBackTap()
    func onSendEmailTap(email: String?)
    func onReturnToLoginTap()
}

class ForgotPasswordViewModel: ForgotPasswordPresentable {
    
    weak var delegate: CoordinatesLogin?
    weak var viewDelegate: ForgotPasswordViewDelegate?
    var networkClient: AnyForgotPasswordNetworkClient
    
    var emailFromLogin: String?
    
    var state: ForgotPasswordScreenState = .enterEmail(nil) {
        didSet {
            viewDelegate?.updateState(state)
        }
    }
    
    init(with email: String?, networkClient: AnyForgotPasswordNetworkClient = ForgotPasswordNetworkClient()) {
        self.emailFromLogin = email
        self.networkClient = networkClient
    }
    
    func onBackTap() {
        GAHelper.shared.sendAnalytic(event: AnalyticsActionFactory.forgotPassword(action: .TapBack))
        delegate?.goBack(animated: true)
    }
    
    func onSendEmailTap(email: String?) {
        GAHelper.shared.sendAnalytic(event: AnalyticsActionFactory.forgotPassword(action: .TapSend))
        if let error = EmailValidator.validate(string: email ?? "") {
            state = .enterEmail(error.localizedDescription)
        } else {
            state = .loading
            networkClient.recoverPassword(for: email ?? "") { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .failure:
                    if Reachability.forInternetConnection()?.currentReachabilityStatus() == NotReachable {
                        AlertView.showNetworkError(actionConfirm: {})
                        self.state = .enterEmail(nil)
                    } else {
                        self.state = .enterEmail(Asset.String.accountDoesNotExist)
                    }
                case .success:
                    self.state = .emailSent
                }
            }
        }
    }
    
    func onReturnToLoginTap() {
        GAHelper.shared.sendAnalytic(event: AnalyticsActionFactory.forgotPassword(action: .TapReturnToLogin))
        delegate?.goBack(animated: true)
    }
}
