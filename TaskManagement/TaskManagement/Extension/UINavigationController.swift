//
//  UINavigationController.swift
//

import UIKit

// MARK: - For 'Back' gesture 
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = nil
    }
}

