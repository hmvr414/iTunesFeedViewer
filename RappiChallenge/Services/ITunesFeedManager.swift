//
//  ITunesFeedManager.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 3/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import RealmSwift
import Alamofire
import AlamofireObjectMapper
import SDWebImage

protocol ITunesFeedManagerProtocol : class {
    
    func entriesAvaliable()
}

class ITunesFeedManager {
    let ITunesFeedEndpoint = "https://itunes.apple.com/us/rss/topfreeapplications/limit=%@/json"
    let feedLimit = "20"
    
    struct Errors {
        static let webserviceError = 1000
    }
    
    func fetchTopFreeAppsFromLocalStorage() {
        let realm = try! Realm()
        
        let apps = realm.objects(FeedEntry.self)
        
        for app in apps {
            print(app)
        }
    }
    
    func saveLocalStore(apps: List<FeedEntry>) {
        let realm = try! Realm()
        
        try! realm.write {
            
            // clear old top rank
            realm.deleteAll()
            
            // save the new rank
            for appEntry in apps {
                realm.add(appEntry)
            }
            
            print("Saved local store")
        }
    }
    
    func feetchAppsFromLocalStorage(searchText:String, _ callback: @escaping ([FeedEntry]?) -> Void) {
        let realm = try! Realm()
        
        var apps = realm.objects(FeedEntry.self)
        
        if searchText.characters.count > 0 {
            let predicate = NSPredicate(format: "name CONTAINS %@", searchText)
            apps = apps.filter(predicate)
        }
        
        let array = Array(apps)
        callback(array)
    }
    
    // get app data from webservice
    func fetchAppsFromWebservice(_ callback: @escaping (NSError?, [FeedEntry]?) -> Void) {
        let serviceParams: [CVarArg] = [feedLimit]
        let topFreeAppEndpoint:String = String(format: ITunesFeedEndpoint, arguments: serviceParams)
        
        Alamofire.request(topFreeAppEndpoint, method:.get)
            .responseObject { (response: DataResponse<ITunesFeed>) in
                if response.result.isSuccess {
                    
                    // if the requeset succeded save the data in local storage
                    let feedResponse = response.result.value
                    if let topFreeApps = feedResponse?.apps {
                        self.saveLocalStore(apps: topFreeApps)
                        let array = Array(topFreeApps)
                        callback(nil, array)
                    }
                } else {
                    
                    // return an error
                    let serviceError = NSError(
                        domain: "ItunesAppsFeed",
                        code: Errors.webserviceError,
                        userInfo: nil)
                    callback(serviceError, nil)
                }
        }
    }
    
    func fetchAppsFromWebservice() {
        let serviceParams: [CVarArg] = [feedLimit]
        let topFreeAppEndpoint:String = String(format: ITunesFeedEndpoint, arguments: serviceParams)

        Alamofire.request(topFreeAppEndpoint, method:.get)
            .responseObject { (response: DataResponse<ITunesFeed>) in
                if response.result.isSuccess {
                    let feedResponse = response.result.value
                    if let topFreeApps = feedResponse?.apps {
                        self.saveLocalStore(apps: topFreeApps)
                        
                    }
                } else {
                    
                }
                
                
            /*let feedResponse = response.result.value
            print(feedResponse?.apps ?? "undefined")
            
            if let topFreeApps = feedResponse?.apps {
                for appEntry in topFreeApps {
                    print(appEntry.name)
                }
            }*/
        }
    }
    
    func getImage(fromUrl urlString: String, success: @escaping (UIImage?)->Void, fail: @escaping (NSError?)->Void ) {
        let url = NSURL(string: urlString);
        SDWebImageManager.shared().downloadImage(with: url as URL!, options: .cacheMemoryOnly, progress: nil) { (image, error, cache, finished, withUrl) in
            if ((image != nil) && finished) {
                success(image)
            } else {
                fail(error as NSError?)
            }
        }
    }
}
