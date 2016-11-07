//
//  AppCatalogWireframe.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 6/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import Foundation
import UIKit

protocol AppCatalogWireframe : class {
    func navigateToAppDetail()
    func setupNextViewData(_ segue: UIStoryboardSegue)
}

class AppCatalogWireframeImpl : AppCatalogWireframe {
    
    struct AppCatalogSegues {
        static let ShowAppDetails = "ShowAppDetails"
    }
    
    weak var viewController: AppCatalogViewController!
    
    func navigateToAppDetail() {
        viewController.performSegue(withIdentifier: AppCatalogSegues.ShowAppDetails, sender: nil)
    }
    
    func setupNextViewData(_ segue: UIStoryboardSegue) {
        if segue.identifier == AppCatalogSegues.ShowAppDetails {
            if let selectedIndexPath = viewController.collectionView.indexPathsForSelectedItems?.first {
                let selectedApp = viewController.apps[selectedIndexPath.row]
                let appDetailViewController = segue.destination as! AppDetailViewController
                
                // get shared element frame
                let cell = viewController.collectionView.cellForItem(at: selectedIndexPath) as! AppCell
                
                print(cell.appIcon.frame)
                
                appDetailViewController.presenter.setAppModel(selectedApp)
            }
        }
    }
    
}
