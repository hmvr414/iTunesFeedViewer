//
//  AppCatalogPresenter.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 4/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import Foundation
import UIKit

protocol AppCatalogPresenterInput: class {
    func reloadData()
    func getApps(filter: String)
    func showDetailsForApp()
    func setupNextViewData(_ segue: UIStoryboardSegue)
}

class AppCatalogPresenter : AppCatalogPresenterInput, AppCatalogInteractorOutput {
    
    weak var view: AppCatalogView!
    var interactor: AppCatalogInteractorInput!
    var wireframe:AppCatalogWireframe!
    
    func reloadData() {
        interactor.reload()
    }
    
    func getApps(filter: String) {
        interactor.getApps(useWebservice: true, searchText:filter)
    }
    
    func loadedApps(apps: [FeedEntry]) {
        view.updateAppList(apps: apps)
    }
    func errorLoadingAppsFromWebservice() {
        view.showError("Error consultando iTunes")
    }
    func internetNotAvailableError() {
        view.showError("Verifica tu conexión a internet")
    }
    func webserviceRequestSent() {
        
    }
    func webserviceResponseReceived() {
        view.endProcessing()
    }
    func showDetailsForApp() {
        self.wireframe.navigateToAppDetail()
    }
    
    func setupNextViewData(_ segue: UIStoryboardSegue) {
        self.wireframe.setupNextViewData(segue)
    }
}
