

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
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
        let registerViewController =
           navigationController?.pushViewController(RegisterViewController, animated: true)
        
    }
}
