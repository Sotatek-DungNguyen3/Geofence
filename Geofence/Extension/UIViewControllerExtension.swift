//
//  UIViewControllerExtension.swift
//  Geofence
//
//  Created by Nguyen Tan Dung on 15/06/2021.
//

import UIKit

extension UIViewController {
    func showDefaultAlert(title: String,
                          message: String,
                          possitiveAction: ((UIAlertAction) -> Void)?,
                          negativeAction: ((UIAlertAction) -> Void)?) {
        showAlert(title: title, message: message, possitiveTitle: "OK", possitiveAction: possitiveAction, negativeTitle: "Cancel", negativeAction: negativeAction)
    }

    func showAlert(title: String,
                   message: String,
                   possitiveTitle: String,
                   possitiveAction: ((UIAlertAction) -> Void)?,
                   negativeTitle: String? = nil,
                   negativeAction: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: possitiveTitle, style: .default, handler: possitiveAction)
        if negativeTitle != nil {
            let cancelAction = UIAlertAction(title: negativeTitle, style: UIAlertAction.Style.cancel, handler: negativeAction)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String, okTitle: String, okAction: ((UIAlertAction) -> Void)?) {
        showAlert(title: title, message: message, possitiveTitle: okTitle, possitiveAction: okAction)
    }
}
