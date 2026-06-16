//
//  LoginViewController.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import UIKit
import Combine
import SwiftUI

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    var onLoginSuccess: (() -> Void)?
    private var logoHostingController: UIHostingController<AnimatedLogoView>?

    // MARK: - UI

    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "username".localized
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password".localized
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        return tf
    }()

    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "sign_in".localized
        config.cornerStyle = .medium
        let btn = UIButton(configuration: config)
        return btn
    }()

    private let biometricButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "faceid")
        config.title = "use_face_id".localized
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

        // SwiftUI logo via UIHostingController
        let logoView = AnimatedLogoView()
        let hostingVC = UIHostingController(rootView: logoView)
        logoHostingController = hostingVC

        addChild(hostingVC)
        hostingVC.view.backgroundColor = .clear
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingVC.view)
        hostingVC.didMove(toParent: self)

        usernameField.delegate = self
        passwordField.delegate = self

        let formStack = UIStackView(arrangedSubviews: [
            usernameField,
            passwordField,
            errorLabel,
            loginButton,
            biometricButton,
            activityIndicator
        ])
        formStack.axis = .vertical
        formStack.spacing = 12
        formStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(formStack)

        NSLayoutConstraint.activate([
            // SwiftUI logo at top
            hostingVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            hostingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingVC.view.heightAnchor.constraint(equalToConstant: 160),

            // Form below logo
            formStack.topAnchor.constraint(equalTo: hostingVC.view.bottomAnchor, constant: 32),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

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
