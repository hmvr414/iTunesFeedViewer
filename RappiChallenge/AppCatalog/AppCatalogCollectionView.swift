//
//  AppCatalogCollectionView.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 5/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit

@IBDesignable
class AppCatalogCollectionView : UICollectionView {
    @IBInspectable var blockColor: UIColor = UIColor.gray {
        didSet {
            backgroundColor = blockColor
        }
    }
}
