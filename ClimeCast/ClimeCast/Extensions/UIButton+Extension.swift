//
//  UIButton+Extension.swift
//  ClimeCast
//
//  Created by Timothy Obeisun on 09/03/2024.
//
import UIKit

extension UIButton {
    func showLoader() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .label
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        activityIndicator.startAnimating()
        self.setTitle(nil, for: .normal)
        self.isUserInteractionEnabled = false
    }

    func hideLoader(title: String) {
        for view in subviews {
            if let activityIndicator = view as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }

        self.setTitle(title, for: .normal)
        self.isUserInteractionEnabled = true
    }
}
