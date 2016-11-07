//
//  AppDetailDependencies.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 6/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import Foundation

class AppDetailDependencies {
    
    class func setup(_ appDetailViewController: AppDetailViewController) {
        let itunesFeedManager = ITunesFeedManager()
        let interactor = AppDetailInteractor()
        let presenter = AppDetailPresenterImpl()
        
        interactor.itunesFeedManager = itunesFeedManager
        presenter.interactor = interactor
        presenter.appDetailView = appDetailViewController
        interactor.output = presenter
        appDetailViewController.presenter = presenter
    }
}
