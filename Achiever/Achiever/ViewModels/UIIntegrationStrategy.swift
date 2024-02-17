//
//  UIIntegrationStrategy.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit
class UIIntegrationStrategy {
    
    var userActionsDelegate: UserActionsDelegate
    
    init(userActionsDelegate: UserActionsDelegate) {
        self.userActionsDelegate = userActionsDelegate
    }
    
    func signInViewConfigureUI(view: UIView) {
        
        let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.frame = view.bounds
            scrollView.contentSize = contentSize
            return scrollView
        }()
        
        let contentView: UIView = {
            let contentView = UIView()
            contentView.frame.size = contentSize
            return contentView
        }()
        
        var contentSize: CGSize {
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
            label.font = UIFont.systemFont(ofSize: 30)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let emailTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Адрес эл.почты"
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        let passwordTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Пароль"
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        let forgetPasswordButton: UIButton = {
            let button = UIButton()
            button.setTitle("Забыли пароль?", for: .normal)
            button.setTitleColor(UIColor(named: "ComplementaryColor"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let signInButton: UIButton = {
            let button = UIButton()
            button.setTitle("Войти", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(named: "ComplementaryColor")
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let registrationButton: UIButton = {
            let button = UIButton()
            button.setTitle("Регистрация", for: .normal)
            button.setTitleColor(UIColor(named: "ComplementaryColor"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

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
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 146/300),
            logoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            logoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            authorizationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            authorizationLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
            authorizationLabel.heightAnchor.constraint(equalToConstant: 80),
            authorizationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorizationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: authorizationLabel.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            forgetPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            forgetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgetPasswordButton.widthAnchor.constraint(equalToConstant: 30),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 10),
            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            registrationButton.widthAnchor.constraint(equalToConstant: 30),
            registrationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registrationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
               
    }
}
