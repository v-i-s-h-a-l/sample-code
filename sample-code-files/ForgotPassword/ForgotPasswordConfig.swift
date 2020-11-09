//
//  ForgotPasswordConfig.swift
//  Platform
//
//  Created by Vishal Singh on 18/06/19.
//  Copyright © 2019 Gwynniebee. All rights reserved.
//

extension Style {
    static var forgotPasswordConfig: ForgotPasswordConfig = JSONHelper.mapFromJSON(to: ForgotPasswordConfig.self)!
}

struct ForgotPasswordConfig: Codable {
    
    var navigationTitleLabel: LabelStyle
    var emailTextField: TextFieldStyle
    var enterEmailPromptLabel: LabelStyle
    var emailErrorLabel: LabelStyle
    var sendEmailButton: ButtonStyle
    var returnToLoginButton: ButtonStyle
    var emailSentInfoLabel: LabelStyle
    
    enum CodingKeys: String, CodingKey {
        case navigationTitleLabel
        case emailTextField
        case enterEmailPromptLabel
        case emailErrorLabel
        case sendEmailButton
        case returnToLoginButton
        case emailSentInfoLabel
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        navigationTitleLabel = (try container.decodeIfPresent(String.self, forKey: .navigationTitleLabel))!.labelValue!
        emailTextField = (try container.decodeIfPresent(String.self, forKey: .emailTextField))!.textFieldValue!
        enterEmailPromptLabel = (try container.decodeIfPresent(String.self, forKey: .enterEmailPromptLabel))!.labelValue!
        emailErrorLabel = (try container.decodeIfPresent(String.self, forKey: .emailErrorLabel))!.labelValue!
        sendEmailButton = (try container.decodeIfPresent(String.self, forKey: .sendEmailButton))!.buttonValue!
        returnToLoginButton = (try container.decodeIfPresent(String.self, forKey: .returnToLoginButton))!.buttonValue!
        emailSentInfoLabel = (try container.decodeIfPresent(String.self, forKey: .emailSentInfoLabel))!.labelValue!
    }
    
    public func encode(to encoder: Encoder) throws {
    }
}
