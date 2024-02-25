//
//  SignUpViewController.swift
//  Achiever
//
//  Created by User on 17.02.2024.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height * 2)
    }
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.textContentType = .username
        textField.textColor = UIColor(named: "PrimaryTextLabelColor")
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Адрес эл.почты"
        textField.textContentType = .emailAddress
        textField.textColor = UIColor(named: "PrimaryTextLabelColor")
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let errorEmailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.textContentType = .password
        textField.textColor = UIColor(named: "PrimaryTextLabelColor")
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Повторите пароль"
        textField.textContentType = .password
        textField.textColor = UIColor(named: "PrimaryTextLabelColor")
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordsMissmatchLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароли не совпадают"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "PrimaryTextButtonColor"), for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryButtonBackgroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Уже есть аккаунт?", for: .normal)
        button.setTitleColor(UIColor(named: "ComplementaryTextButtonColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImage)
        contentView.addSubview(registrationLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(errorEmailLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(repeatPasswordTextField)
        contentView.addSubview(passwordsMissmatchLabel)
        contentView.addSubview(signUpButton)
        contentView.addSubview(signInButton)
        
        setupConstraints()
        
        emailTextField.delegate = self
        
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 146/300),
            logoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            logoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            registrationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 40),
            registrationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registrationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            errorEmailLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorEmailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            errorEmailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            errorEmailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            repeatPasswordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordsMissmatchLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordsMissmatchLabel.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor),
            passwordsMissmatchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordsMissmatchLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50)
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let proposedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !emailTest.evaluate(with: proposedText) && proposedText != "" {
            // Неверный формат email
            errorEmailLabel.text = "Неверный формат email"
            errorEmailLabel.isHidden = false
            emailTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
            return false
        }
        errorEmailLabel.isHidden = true
//        emailTextField.layer.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
        return true
    }
    
    @objc private func didTapSignInButton() {
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    @objc private func didTapSignUpButton() {
        guard let userName = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        if password != repeatPasswordTextField.text {
            passwordsMissmatchLabel.isHidden = false
            repeatPasswordTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        }
        
        AuthViewModel.shared.signUp(userName: userName, email: email, password: password, errorHandler: {
            self.errorEmailLabel.text = "Данный email уже зарегистрирован"
            self.errorEmailLabel.isHidden = false
            self.emailTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        })
                
        let workspaceViewController = WorkspaceViewController()
        
        addChild(workspaceViewController)
        view.addSubview(workspaceViewController.view)
        workspaceViewController.didMove(toParent: self)
    }
}
