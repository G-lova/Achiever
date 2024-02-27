//
//  SignInViewController.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import UIKit
import MessageUI

class SignInViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
    
    let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let authorizationLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизация"
        label.textAlignment = .center
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Адрес эл.почты"
        textField.borderStyle = .roundedRect
        textField.textContentType = .username
        textField.keyboardType = .emailAddress
        textField.textColor = UIColor(named:"PrimaryTextLabelColor")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
//        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.textColor = UIColor(named:"PrimaryTextLabelColor")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let forgetPasswordButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Забыли пароль?", for: .normal)
//        button.setTitleColor(UIColor(named: "ComplementaryTextButtonColor"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor(named: "PrimaryTextButtonColor"), for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryButtonBackgroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
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
        contentView.addSubview(authorizationLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(errorLabel)
//        contentView.addSubview(forgetPasswordButton)
        contentView.addSubview(signInButton)
        contentView.addSubview(registrationButton)
        
        setupConstraints()
        
        signInButton.addTarget(self, action: #selector(didSignInButtonTapped), for: .touchUpInside)
        
        registrationButton.addTarget(self, action: #selector(didRegistrationButtonTapped), for: .touchUpInside)
        
//        forgetPasswordButton.addTarget(self, action: #selector(didResetPasswordButtonTaped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 146/300),
            logoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            logoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            authorizationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            authorizationLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 40),
            authorizationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorizationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: authorizationLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            forgetPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            forgetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
//            forgetPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            forgetPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            signInButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 10),
            signInButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            registrationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registrationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            
        ])
    }
    
    @objc private func didResetPasswordButtonTaped() {
        guard let email = emailTextField.text else { return }
        let passwordResetViewController = PasswordResetViewController()
        passwordResetViewController.emailTextField.text = email
        navigationController?.pushViewController(passwordResetViewController, animated: true)
    }
    
    @objc private func didSignInButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        AuthViewModel.shared.signIn(email: email, password: password, completionHandler: {
            let workspaceViewController = UINavigationController(rootViewController: WorkspaceViewController())
            
            self.addChild(workspaceViewController)
            self.view.addSubview(workspaceViewController.view)
            workspaceViewController.didMove(toParent: self)
            
        }, errorHandler: { (error) in
            let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.errorLabel.text = error
                self.errorLabel.isHidden = false
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    @objc private func didRegistrationButtonTapped() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}

