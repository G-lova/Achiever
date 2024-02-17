//
//  SignInViewController.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import UIKit

class SignInViewController: UIViewController {
    
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
    
    private let authorizationLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизация"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Адрес эл.почты"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(UIColor(named: "ComplementaryColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ComplementaryColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(UIColor(named: "ComplementaryColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImage)
        contentView.addSubview(authorizationLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(forgetPasswordButton)
        contentView.addSubview(signInButton)
        contentView.addSubview(registrationButton)
        
        setupConstraints()
        
        registrationButton.addTarget(self, action: #selector(didTapRegistrationButton), for: .touchUpInside)
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
            forgetPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forgetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 10),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            registrationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registrationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            
        ])
    }
    
    @objc private func didTapRegistrationButton() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }

}

