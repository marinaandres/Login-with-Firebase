//
//  RegisterViewController.swift
//  Login with Firebase
//
//  Created by Marina Andrés Aragón on 15/4/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet {
            registerButton.isEnabled = false
        }
    }
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield:
    UITextField!{
        didSet {
            passwordTextfield.isSecureTextEntry = true
        }
    }
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
            registerButton.isEnabled = isLoginEnable
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func didTapRegister(_ sender: Any) {
            Auth.auth().createUser(withEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? "") { user, error in
                if user != nil {
                    self.stackView.isHidden = true
                    
                    let alert = UIAlertController(title: "Registro", message: "Tu cuenta ha sido registrada", preferredStyle: .alert)
                    
                    let loginAction = UIAlertAction(title: "Iniciar sesión", style: .default) { _ in
                        let loginViewController = LoginViewController()
                        self.navigationController?.pushViewController(loginViewController, animated: true)
                    }
                    alert.addAction(loginAction)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    let alert = UIAlertController(title: "Error", message: "Error en el Registro", preferredStyle: .alert)
                    
                    let errorAction = UIAlertAction(title: "Inténtalo de nuevo", style: .default)
                    alert.addAction(errorAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

