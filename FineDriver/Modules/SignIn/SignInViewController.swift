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

protocol SignInViewControllerProtocol: class {
    
}

final class SignInViewController: UIViewController {
    
    // MARK: - Private outlet
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var appleView: UIView!
    
    // MARK: - Private property
    private let defaults = UserDefaults.standard
    
    // MARK: - Public properties
    var presenter: SignInPresenterProtocol?
    
    // LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Private methods
    private func setupFacebookSignIn() {
        
        let facebookButton = FBLoginButton()
        facebookButton.center = view.center
        view.addSubview(facebookButton)
        
        // TODO: - Constraint for test
        NSLayoutConstraint.activate([facebookButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 30),
                                     facebookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
                                     facebookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                                     facebookButton.heightAnchor.constraint(equalToConstant: 50)])
        
        facebookButton.delegate = self
        facebookButton.permissions = ["public_profile", "email"]
        
    }
    
    @available(iOS 13.0, *)
    private func setupAppleSignIn() {
        
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        view.addSubview(appleButton)
        
        // TODO: - Constraint for test
        NSLayoutConstraint.activate([appleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
                                     appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
                                     appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                                     appleButton.heightAnchor.constraint(equalToConstant: 50)])
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
                  let userId = user.userID,
                  let firstName = user.profile.givenName,
                  let familyName = user.profile.familyName,
                  let email = user.profile.email,
                  let tokenId = user.authentication.idToken else { return }
            
            defaults.register(defaults: [.user: userId,
                                         .firstName: firstName,
                                         .familyName: familyName,
                                         .email: email,
                                         .tokenId: tokenId])
        }
    }
}

// MARK: - Facebook auth delegate methods
extension SignInViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields": "email, name"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        request.start { (connection, result, error) in
            print("\(result)") // TODO: - Logic for auth success/error
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
            guard let tokenId = appleIDCredential.authorizationCode else { return }
            
            defaults.register(defaults: [.user: appleIDCredential.user,
                                         .firstName: firstName,
                                         .familyName: familyName,
                                         .email: email,
                                         .tokenId: tokenId])
            
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

// MARK: - Protocol methods
extension SignInViewController: SignInViewControllerProtocol {
    
}
