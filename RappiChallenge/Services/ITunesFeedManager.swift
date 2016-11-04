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

protocol ITunesFeedManaProtocol : class {
    
    // called after the data from fixer.io has been loaded
    func currencyExchangeDidLoad()
    
    // called if an error occurred loading the currency data from fixer.io
    func currencyExchangeDidLoadWithError()
}

class ITunesFeedManager {
    let ITunesFeedEndpoint = "https://itunes.apple.com/us/rss/topfreeapplications/limit=%@/json"
    let feedLimit = "20"
    
    func checkConnection() {
    
    }
    
    func loadFeedEntries(jsonString: String) {
        print("Feeds \(jsonString)");
    }
    
    func fetchTopFreeAppsFromLocalStorage() {
        
    }
    
    func saveLocalStore(apps: List<FeedEntry>) {
        let realm = try! Realm()
        
        try! realm.write {
            
            // clear old top 20 rank
            realm.deleteAll()
            
            // save the new rank
            for appEntry in apps {
                realm.add(appEntry)
            }
            
            print("Saved local store")
        }
    }
    
    func fetchTopFreeAppsFromWebservice() {
        let serviceParams: [CVarArg] = [feedLimit]
        let topFreeAppEndpoint:String = String(format: ITunesFeedEndpoint, arguments: serviceParams)

        Alamofire.request(topFreeAppEndpoint, method:.get)
            .responseObject { (response: DataResponse<ITunesFeed>) in
            
                let feedResponse = response.result.value
                if let topFreeApps = feedResponse?.apps {
                    self.saveLocalStore(apps: topFreeApps)
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
}
