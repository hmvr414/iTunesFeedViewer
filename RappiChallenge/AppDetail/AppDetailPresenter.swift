//
//  AppDetailPresenter.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 6/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit

protocol AppDetailPresenter : class {
    func setAppModel(_ appModel:FeedEntry)
    func loadContent()
}

class AppDetailPresenterImpl : AppDetailPresenter, AppDetailInteractorOutput {
    
    weak var appDetailView : AppDetailView!
    var interactor : AppDetailInteractorInput!
    var appModel:FeedEntry!
    
    func setAppModel(_ appModel:FeedEntry) {
        interactor.setAppModel(appModel)
    }
    
    func loadContent() {
        interactor.loadAppImage()
        appDetailView.updateAppTitle(interactor.getAppTitle())
        appDetailView.updateAppAuthor(interactor.getAppAuthor())
        appDetailView.updateAppSummary(interactor.getAppSummary())
    }
    
    func appImageLoaded(image:UIImage) {
        appDetailView.updateAppImage(image)
    }
    
    func errorLoadingAppImage() {
        appDetailView.displayError("Se ha producido un error")
    }
}
