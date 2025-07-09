//
//  UIViewController+.swift
//  Shared
//
//  Created by ParkJunHyuk on 4/11/25.
//

import Foundation
import UIKit

// MARK: - 화면밖 터치시 키보드를 내려 주는 메서드

public extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - ViewController 미리보기

#if canImport(SwiftUI) && DEBUG
import SwiftUI

public extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    }

    func showPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
