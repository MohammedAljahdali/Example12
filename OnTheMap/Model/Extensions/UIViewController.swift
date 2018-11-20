//
//  UIViewController.swift
//  OnTheMap
//
//  Created by Ammar AlTahhan on 20/11/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
}
