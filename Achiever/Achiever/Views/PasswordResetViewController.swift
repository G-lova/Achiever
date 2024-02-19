//
//  PasswordResetViewController.swift
//  Achiever
//
//  Created by User on 18.02.2024.
//

import UIKit
import MessageUI

class PasswordResetViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
//    var authViewModel = AuthViewModel()
    
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
    
    private let resetLabel: UILabel = {
        let label = UILabel()
        label.text = "Восстановление пароля"
        label.textAlignment = .center
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Адрес эл.почты"
        textField.textColor = UIColor(named:"PrimaryTextLabelColor")
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendResetPasswordCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить код подтверждения", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "PrimaryTextButtonColor"), for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryButtonBackgroundColor")
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
        contentView.addSubview(resetLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(sendResetPasswordCodeButton)
        
        setupConstraints()
        
        sendResetPasswordCodeButton.addTarget(self, action: #selector(didResetPasswordButtonTaped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 146/300),
            logoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            logoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            resetLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resetLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 40),
            resetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resetLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: resetLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sendResetPasswordCodeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sendResetPasswordCodeButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50),
            sendResetPasswordCodeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sendResetPasswordCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didResetPasswordButtonTaped() {
        guard let email = emailTextField.text else { return }
        
        AuthViewModel.shared.sendResetCode(email: email, completion: { code in
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([email])
            mailComposer.setSubject("Код для восстановления пароля")
            mailComposer.setMessageBody("Ваш код для восстановления пароля: \(code)", isHTML: false)
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposer, animated: true, completion: nil)
            } else {
                print("Mail services are not available")
            }
        })
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
