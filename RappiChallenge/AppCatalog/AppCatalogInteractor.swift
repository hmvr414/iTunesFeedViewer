//
//  AppCatalogInteractor.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 4/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import Foundation
import ReachabilitySwift

protocol AppCatalogInteractorInput : class {
    func getApps(useWebservice: Bool, searchText: String)
    func setReachability(reachability: Reachability)
    func reload()
}

protocol AppCatalogInteractorOutput : class {
    func loadedApps(apps: [FeedEntry])
    func errorLoadingAppsFromWebservice()
    func internetNotAvailableError()
    func webserviceRequestSent()
    func webserviceResponseReceived()
}

class AppCatalogInteractor : AppCatalogInteractorInput {
    
    var itunesFeedManager : ITunesFeedManager!
    weak var output : AppCatalogInteractorOutput!
    
    var reachability : Reachability!
    var currentFilter = ""
        
    func setReachability(reachability: Reachability) {
        
        self.reachability = reachability
        /*reachability.whenReachable = { reachability in
            print("The device is connected")
            DispatchQueue.main.async {
                print("The device is connected")
            }
            //self.reachable = true;
        }
        reachability.whenUnreachable = { reachability in
            print("The device is not connected")
            DispatchQueue.main.async {
                print("The device is not connected")
            }

            //self.reachable = false;
        }*/
        /*try! reachability.startNotifier()*/
        /*if self.reachability.isReachable {
            print("internet reachable")
        }
        else {
            print("non reachable")
        }*/
    }
    
    func reload() {
        getApps(useWebservice: true, searchText: currentFilter)
    }
    
    func getApps(useWebservice: Bool = true, searchText:String) {
        
        currentFilter = searchText
        // load apps from local store first
        itunesFeedManager.feetchAppsFromLocalStorage(searchText: searchText, { localApps  in
            if let apps = localApps {
                self.output.loadedApps(apps: apps)
                
                // load apps from json service
                if useWebservice {
                    
                    if !self.reachability.isReachable {
                        self.output.internetNotAvailableError()
                        return;
                    }
                    self.output.webserviceRequestSent()
                    self.itunesFeedManager.fetchAppsFromWebservice({ (error, localApps) in
                        self.output.webserviceResponseReceived()
                        if error != nil {
                            self.output.errorLoadingAppsFromWebservice()
                        } else {
                            // the local storage is already populated with the current rank of free apps
                            print("Data loaded from webserivce")
                            self.getApps(useWebservice:false, searchText: searchText)
                        }
                    })
                }
            } else  {
                print("Local data unavailable")
                self.output.errorLoadingAppsFromWebservice()
            }
        });
    }
}
