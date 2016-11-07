//
//  AppCatalogDependencies.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 4/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import Foundation
import ReachabilitySwift


class AppCatalogDependencies {
    class func setup(viewController: AppCatalogViewController) {
        print("Configuring dependencies for viewcontroller");
        
        let appCatalogDataManager = ITunesFeedManager()
        let reachability = Reachability()!
        let interactor = AppCatalogInteractor()
        let wireframe = AppCatalogWireframeImpl()
        let presenter = AppCatalogPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        wireframe.viewController = viewController
        interactor.itunesFeedManager = appCatalogDataManager
        interactor.setReachability(reachability: reachability)
    }
}
