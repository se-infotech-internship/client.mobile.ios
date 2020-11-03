//
//  SignInViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 23.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices
import Kingfisher

final class SignInViewController: BaseViewController {
    
    // MARK: - Private outlet
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    
    // MARK: - Private property
    fileprivate var statusBarStyle = UIStatusBarStyle.lightContent {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    fileprivate lazy var facebookButton = FBLoginButton(frame: .zero, permissions: [.email, .publicProfile])
    
    // MARK: - Public properties
    override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }
    var presenter: SignInPresenterProtocol?
    
    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.resetToken()
        presenter?.defaultDistaceLocationToCamera()
    }
    
    // MARK: - Private methods
    private func setupFacebookSignIn() {
        view.addSubview(facebookButton)
        facebookButton.delegate = self
        facebookButton.permissions = ["public_profile", "email"]
    }
    
    @available(iOS 13.0, *)
    private func setupAppleSignIn() {
        
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        view.addSubview(appleButton)
    }
    
    @objc private func didTapAppleButton() {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    // MARK: - Private action
    @IBAction private func didTapRegisterButton(_ sender: Any) {
        presenter?.routeToMap()
    }
    
    @IBAction private func didTapGoogleButton(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}

// MARK: - Google auth delegate methods

extension SignInViewController: GIDSignInDelegate {
    
    private func signIn(_ signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func signIn(_ signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if error == nil {
            
            guard let user = user,
                  let login = user.userID,
                  let firstName = user.profile.givenName,
                  let familyName = user.profile.familyName,
                  let email = user.profile.email,
                  let tokenId = user.authentication.idToken,
                  let avatarURL = user.profile.imageURL(withDimension: 100) else { return }
            
            presenter?.saveToUserDefaults(login: login,
                                          firstName: firstName,
                                          familyName: familyName,
                                          email: email,
                                          tokenId: tokenId,
                                          avatarURL: avatarURL)
            
            presenter?.routeToMap()
        }
    }
}

// MARK: - Facebook auth delegate methods

extension SignInViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields": "email, first_name, id, user, family_name"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        
        request.start { [self] (connection, result, error) in
            
        guard let fields = result as? [String: Any],
              let firstName = fields["first_name"] as? String,
              let id = fields["id"] as? String,
              let user = fields["user"] as? String,
              let familyName = fields["family_name"] as? String,
              let email = fields["email"] as? String else { return }
        
        presenter?.saveToUserDefaults(login: user,
                                   firstName: firstName,
                                   familyName: familyName,
                                   email: email,
                                   tokenId: id,
                                   avatarURL: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // TODO: - Logic for log out
    }
}

// MARK: - Apple auth delegates methods
@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // MARK: - ASAuthorizationControllerDelegate methods
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let firstName = appleIDCredential.fullName?.givenName else { return }
            guard let familyName = appleIDCredential.fullName?.familyName else { return }
            guard let email = appleIDCredential.email else { return }
            guard let autorizationCode = appleIDCredential.authorizationCode else { return }
            let tokenId = String(decoding: autorizationCode, as: UTF8.self)
            
            presenter?.saveToUserDefaults(login: appleIDCredential.user,
                                       firstName: firstName,
                                       familyName: familyName,
                                       email: email,
                                       tokenId: tokenId,
                                       avatarURL: nil)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - Logic for error auth
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding method
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = view.window else { return ASPresentationAnchor() }
        return window
    }
}

// MARK: - SignInViewControllerProtocol

extension SignInViewController: SignInViewControllerProtocol {
    
}
