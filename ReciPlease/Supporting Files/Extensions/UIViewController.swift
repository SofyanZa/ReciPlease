//
//  UIViewController.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import UIKit

extension UIViewController {
    
    // MARK: - Methods
    
    /// method to display an alert
    func alert(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    /// method called to manage button and activity controller together: true to hide button and show acticity indicator / false to show button and hide activity controller
    func manageActivityIndicator(activityIndicator: UIActivityIndicatorView, button: UIButton, showActivityIndicator: Bool){
        activityIndicator.isHidden = !showActivityIndicator
        button.isHidden = showActivityIndicator
    }
    /// method to load data from url
    func loadImageDataFromUrl(stringImageUrl: String) -> Data{
        guard let imageUrl = URL(string: stringImageUrl) else {return Data()}
        guard let data = try? Data(contentsOf: imageUrl) else {return Data()}
        return data
    }
}

