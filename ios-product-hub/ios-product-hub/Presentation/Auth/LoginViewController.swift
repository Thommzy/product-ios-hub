//
//  LoginViewController.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    var onLoginSuccess: (() -> Void)?

    // MARK: - UI
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "ProductHub"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to continue"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()

    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        return tf
    }()

    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Sign In"
        config.cornerStyle = .medium
        let btn = UIButton(configuration: config)
        return btn
    }()

    private let biometricButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "faceid")
        config.title = "Use Face ID"
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.cornerStyle = .medium
        let btn = UIButton(configuration: config)
        return btn
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Demo: emilys / emilyspass"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        return label
    }()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        biometricButton.isHidden = !viewModel.canUseBiometrics
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        usernameField.delegate = self
        passwordField.delegate = self

        let stack = UIStackView(arrangedSubviews: [
            logoLabel, subtitleLabel,
            usernameField, passwordField,
            errorLabel, loginButton,
            biometricButton, hintLabel,
            activityIndicator
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.setCustomSpacing(4, after: logoLabel)
        stack.setCustomSpacing(24, after: subtitleLabel)
        stack.setCustomSpacing(16, after: passwordField)
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            usernameField.heightAnchor.constraint(equalToConstant: 48),
            passwordField.heightAnchor.constraint(equalToConstant: 48),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            biometricButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        biometricButton.addTarget(self, action: #selector(biometricTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                self?.loginButton.isEnabled = !loading
                loading ? self?.activityIndicator.startAnimating()
                        : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.errorLabel.text = message
                self?.errorLabel.isHidden = message == nil
                if message != nil {
                    UIView.animate(withDuration: 0.3) {
                        self?.errorLabel.alpha = 1
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in self?.onLoginSuccess?() }
            .store(in: &cancellables)

        usernameField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }

    @objc private func loginTapped() {
        view.endEditing(true)
        viewModel.login()
    }

    @objc private func biometricTapped() {
        viewModel.loginWithBiometrics()
    }

    @objc private func usernameChanged() {
        viewModel.username = usernameField.text ?? ""
    }

    @objc private func passwordChanged() {
        viewModel.password = passwordField.text ?? ""
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField { passwordField.becomeFirstResponder() }
        else { textField.resignFirstResponder(); viewModel.login() }
        return true
    }
}
