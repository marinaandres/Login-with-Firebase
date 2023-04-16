

import UIKit
import FirebaseAuth 
import FacebookLogin


class LoginViewController: UIViewController {
    
    @IBOutlet weak var appleButton: UIButton!
    
    
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var forgottenLabel: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    private var isEmailEmpty: Bool = true {
        didSet {
            isLoginEnable = !isEmailEmpty && !isPasswordEmpty
        }
    }
    private var isPasswordEmpty: Bool = true {
        didSet {
            isLoginEnable = !isEmailEmpty && !isPasswordEmpty
        }
    }
    
    private var isLoginEnable: Bool = false {
        didSet {
            loginButton.isEnabled = isLoginEnable
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
        forgottenLabel.isHidden = true
        
        emailTextfield.addTarget(self, action: #selector(didChangeTextfield), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(didChangeTextfield), for: .editingChanged)
    }
    
    @objc func didChangeTextfield( sender:UITextField){
        if sender == emailTextfield {
            isEmailEmpty = sender.text?.isEmpty ?? true
        }
        
        if sender == passwordTextfield {
            isPasswordEmpty = sender.text?.isEmpty ?? true
        }
        
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        loginButton.isEnabled = false
        Auth.auth().signIn(withEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? ""){ user, error in
            if user != nil {
                let homeViewController = HomeViewController()
                self.navigationController?.pushViewController(homeViewController, animated: true)
            } else {
                self.forgottenLabel.isHidden = false
                let alert = UIAlertController(title: "Error", message: "El correo o contraseña no son correctos", preferredStyle: .alert)
                
                let errorAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(errorAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
        
    }
    
   
    @IBAction func didTapLoginFacebook(_ sender: Any) {
    let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], viewController: self) { loginResult in
            switch loginResult {
            case .success(granted: _, declined: _, token: let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken?.tokenString ?? "")
                Auth.auth().signIn(with: credential) { authResult, error in
                    // Handle login result here
                }
            case .cancelled:
                // Handle cancelled login here
                break
            case .failed(_):
                // Handle failed login here
                break
            }
        }
    }
}

