//
//  ViewController.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 2/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let manager = ITunesFeedManager()
        
        //manager.fetchTopFreeAppsFromWebservice()
        manager.fetchTopFreeAppsFromLocalStorage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

