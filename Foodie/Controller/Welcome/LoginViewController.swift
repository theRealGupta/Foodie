//
//  LoginViewController.swift
//  Foodie
//
//  Created by Mahmoud Alaa on 30/09/2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var emailField: UITextField!{
        didSet{
            emailField.layer.cornerRadius = 10
            emailField.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var passwordField: UITextField!{
        didSet{
            passwordField.layer.cornerRadius = 10
            passwordField.layer.masksToBounds = true
            passwordField.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var eyePassword: UIButton!{
        didSet{
            eyePassword.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    @IBOutlet weak var rememberCheck: UIButton!{
        didSet{
            rememberCheck.tintColor = .white
            rememberCheck.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.layer.cornerRadius = 15
            loginButton.layer.masksToBounds = true
        }
    }
    
    var isPasswordVisible: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Log In"
        emailField.becomeFirstResponder()
        
        // Customise navBarAppearance
        navigationController?.navigationBar.tintColor = UIColor(named: "NavigationBarTitle")
    }
    
    // Customize navigation bar
    func customizeNavigationBar(){
        
        // Use large title for navigation bar appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        if let apperance = navigationController?.navigationBar.standardAppearance {
            apperance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0){
                apperance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                apperance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")! ,.font: customFont]
            }
            navigationController?.navigationBar.standardAppearance = apperance
            navigationController?.navigationBar.scrollEdgeAppearance = apperance
            navigationController?.navigationBar.compactAppearance = apperance
        }
    }
    
    // Eye Password Button
    @IBAction func eyePasswordPressed(_ sender: UIButton) {
        isPasswordVisible.toggle()
        passwordField.isSecureTextEntry = isPasswordVisible
        
        let buttonImageName = isPasswordVisible ? "eye.slash.fill" : "eye.fill"
        eyePassword.setImage(UIImage(systemName: buttonImageName), for: .normal)
        
    }
    
    // Remeber Me
    @IBAction func remeberMe(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(systemName: "circle.fill"){
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            sender.tintColor = UIColor(named: "NavigationBarTitle")
        }else{
            sender.tintColor = .white
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }
    }
    
    
    // Login button
    @IBAction func loginPressed(_ sender: Any) {
        
        // validate the input
        guard let email = emailField.text ,email != "",
              let password = passwordField.text ,password != "" else{
            
            let alertController = UIAlertController(
                title: "LogIn Error",
                message: "Both fields must not blanck",
                preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okayAction)
            present(alertController ,animated: true)
            
            return
        }
        
        // Perform login with email
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let alertController = UIAlertController(
                    title: "Login Error",
                    message: "\(error.localizedDescription)",
                    preferredStyle: .alert)
                
                let okayAciton = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(okayAciton)
                
                self.present(alertController ,animated: true)
                return
            }
            
            guard let user = result?.user else{ return }
            
            // Email Verification
            //            guard let result = result ,result.user.isEmailVerified else{
            //                let alertController = UIAlertController(
            //                    title: "Login Error",
            //                    message: "You haven't confirmed your email address yet. We sent you a confirmation email when you sign up. Please click the verification link in that email. If you need us to send the confirmation email again, please tap Resend Email.",
            //                    preferredStyle: .alert)
            //
            //                let okayAction = UIAlertAction(title: "Resend Email", style: .default) { action in
            //                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
            //                }
            //
            //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            //
            //                alertController.addAction(okayAction)
            //                alertController.addAction(cancelAction)
            //                self.present(alertController ,animated: true)
            //
            //                return
            //            }
            
            // Dismiss the keyboard
            self.view.endEditing(true)
            
            // present the main view
            if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                DataPersistentManager.shared.userId = user.uid
                UIApplication.shared.keyWindow?.rootViewController = tabBarController
                self.dismiss(animated: true)
            }
        }
    }
    
    // Facebook login
    @IBAction func facebookLogin(_ sender: UIButton) {
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(
            permissions: ["public_profile", "email"],
            from: self) { result, error in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    return
                }
                
                guard let accessToken = AccessToken.current else{
                    print("Failed to get access token")
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login to by calling Firebase APIs
                Auth.auth().signIn(with: credential) { result, error in
                    if let error = error {
                        print("Error when login:\(error.localizedDescription)")
                        
                        let alert = UIAlertController(
                            title: "Login Error",
                            message: error.localizedDescription,
                            preferredStyle: .alert)
                        
                        let okayAction = UIAlertAction(title: "OK", style: .cancel)
                        
                        alert.addAction(okayAction)
                        self.present(alert ,animated: true)
                        return
                    }
                    
                    guard let userId = result?.user.uid else { return }
                    
                    DataPersistentManager.shared.userId = userId
                    
                    // Present the main view
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView"){
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true)
                    }
                }
                
            }
        
    }
    
    // Google login
    @IBAction func googleLogin(_ sender: UIButton) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else{
            return
        }
        
        let configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = configuration
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return
        }
        
        guard let rootVC = windowScene.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [unowned self] result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Login Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(okayAction)
                self.present(alert, animated: true)
                
                return
            }
            
            // Get the Google ID token and Google access token
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                
                print("Error: Missing Google ID token")
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            // Get the Firebase credential using the Google tokens
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // Sign in with Firebase using the Google credential
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase login error: \(error.localizedDescription)")
                    
                    let alert = UIAlertController(title: "Login Error",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okayAction)
                    self.present(alert, animated: true)
                    return
                }
                
                // Successfully signed in
                if let authResult = authResult {
                    let userId = authResult.user.uid
                    DataPersistentManager.shared.userId = userId
                    
                    if let vc = storyboard?.instantiateViewController(withIdentifier: "MainView"){
                        UIApplication.shared.keyWindow?.rootViewController = vc
                        self.dismiss(animated: true)
                    }
                    
                }
            }
            
        }
        
    }
}
