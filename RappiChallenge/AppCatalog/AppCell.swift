//
//  AppCell.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 5/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit


@IBDesignable
class AppCell : UICollectionViewCell {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appAuthor: UILabel!
    
    struct AppCellIdentifiers {
        static let appCell = "appCell"
        static let appCellIpad = "appCelliPad"
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

