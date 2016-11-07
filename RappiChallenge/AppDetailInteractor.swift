//
//  AppDetailInteractor.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 6/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import Foundation
import UIKit

protocol AppDetailInteractorInput : class {
    func setAppModel(_ appModel: FeedEntry)
    func loadAppImage()
    func getAppTitle() -> String
    func getAppAuthor() -> String
    func getAppSummary() -> String
}

protocol AppDetailInteractorOutput : class {
    func appImageLoaded(image:UIImage)
    func errorLoadingAppImage()
}

class AppDetailInteractor : AppDetailInteractorInput {
    
    var itunesFeedManager : ITunesFeedManager!
    weak var output : AppDetailInteractorOutput!
    var appModel:FeedEntry!
    
    func setAppModel(_ appModel: FeedEntry) {
        self.appModel = appModel
    }
    
    func loadAppImage() {
        itunesFeedManager.getImage(
            fromUrl: appModel.images[2].url,
            success: { image in
                if let image = image {
                    self.output.appImageLoaded(image: image)
                }
                else {
                    self.output.errorLoadingAppImage()
                }
            },
            fail: { error in
                self.output.errorLoadingAppImage()
            })
    }
    
    func getAppTitle() -> String {
        return appModel.title
    }
    
    func getAppAuthor() -> String {
        return appModel.artist
    }
    
    func getAppSummary() -> String {
        return appModel.summary
    }
}
