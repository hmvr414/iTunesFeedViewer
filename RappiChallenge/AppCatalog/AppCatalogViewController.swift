//
//  AppCatalogViewController.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 4/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit
import ReachabilitySwift
import SDWebImage

protocol AppCatalogView: class {
    func showError(_ message:String)
    func updateAppList(apps: [FeedEntry])
    func startProcessing()
    func endProcessing()
}

class AppCatalogViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIView!
    
    var presenter:AppCatalogPresenterInput!
    var apps: [FeedEntry] = []
    
    var refreshControl:UIRefreshControl!
    
    var lastAnimatedCell = -1
    
    var titleView:UIView!
    var searchBar:UISearchBar!
    
    var searchMode = false
    
    var selectedIndex:IndexPath!
    
    var ipad = false
    
    func toggleSearchBar(_ sender: Any) {
        
        if searchMode {
            searchModeOff()
        } else {
            searchModeOn()
        }
    }
    
    func searchModeOn() {
        navigationItem.titleView = searchBar
        searchBar.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
        addCloseSearchButton()
        searchMode = true
    }
    
    func searchModeOff() {
        navigationItem.titleView = titleView
        addSearchButton()
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBar.alpha = 0
        })
        searchMode = false
    }
    
    
    override func awakeFromNib() {
        AppCatalogDependencies.setup(viewController: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        
        setupSearchBar()
        
        presenter.reloadData()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            ipad = true
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
    }
    
    override var shouldAutorotate: Bool {
        //get {
            return true
        //}
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //get {
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("is ipad landscape")
                return UIInterfaceOrientationMask.landscapeLeft
            } else {
                print("is iphone portrait")
                return UIInterfaceOrientationMask.portrait
            }
        //}
    }
    
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
    func setupSearchBar() {
        titleView = self.navigationItem.titleView
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: -44, width: self.view.frame.size.width, height: 44))
        searchBar.delegate = self
        searchMode = false
        
        addSearchButton()
    }
    
    func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(toggleSearchBar(_:)))
    }
    func addCloseSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(toggleSearchBar(_:)))
    }
    
    func refresh(_ sender: UIRefreshControl) {
        presenter.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.delegate = self
        searchModeOff()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.setupNextViewData(segue)
    }
    
    func errorLoadingAppsFromWebservice()
    {
        print("ViewController: Error occurred in the iterator")
    }
}

extension AppCatalogViewController : UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if operation == UINavigationControllerOperation.push {
            let animator = PushAnimator()
            
            
            let cell = collectionView.cellForItem(at: self.selectedIndex) as! AppCell
            let imageFrame = cell.appIcon.frame
            
            
            let cellAttributes = collectionView.layoutAttributesForItem(at: self.selectedIndex)
            
            var cellFrameInSuperview = collectionView.convert((cellAttributes?.frame)!, to: collectionView.superview)
            
            let frameinsidecell = cell.convert(imageFrame, to: self.view)
            
            cellFrameInSuperview = CGRect(x: cellFrameInSuperview.origin.x + imageFrame.origin.x, y: cellFrameInSuperview.origin.y + imageFrame.origin.y, width: imageFrame.size.width, height: imageFrame.size.height)
            
                print("seting origin frame to \(frameinsidecell) for selected index \(self.selectedIndex.row)")
                animator.originFrame = frameinsidecell
            
            
            return animator
        }
        
        if operation == UINavigationControllerOperation.pop {
            return PopAnimator();
        }
        
        return nil;
    }
}

extension AppCatalogViewController : PushAnimatorView {
    func performPushAnimations(originFrame: CGRect, duration: TimeInterval) {
        // nothing :(
    }
}

extension AppCatalogViewController : AppCatalogView {
    func startProcessing() {
        
    }
    func endProcessing() {
        self.dismissAllActivityIndicators()
    }
    func showError(_ message:String) {
        view.makeToast(message: message)
        dismissAllActivityIndicators()
    }
    
    func updateAppList(apps: [FeedEntry]) {
        print("Loaded app data from interactor \(apps.count)")
        
        self.apps = apps
        collectionView.reloadData()
    }
    
    func dismissAllActivityIndicators() {
        refreshControl.endRefreshing()
        if activityIndicator != nil {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.activityIndicator.alpha = 0
                }, completion: { finished in
                    self.activityIndicator = nil
                })
            
            
        }
    }
}

extension AppCatalogViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        //presenter.reloadData();
        presenter.getApps(filter: "")
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        presenter.getApps(filter: searchBar.text!)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searching apps with name \(searchBar.text)")
        presenter.getApps(filter: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.getApps(filter: "")
    }
}

extension AppCatalogViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count;
    }
    
    func applyCellAnimations(_ cell:AppCell, row: Int) {
        if row > lastAnimatedCell {
            let finalCellFrame = cell.frame;
            cell.alpha = 0
            cell.frame = CGRect(x: UIScreen.main.bounds.width, y: finalCellFrame.origin.y, width: finalCellFrame.size.width, height: finalCellFrame.size.height)
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.frame = finalCellFrame
                cell.alpha = 1
            })
            lastAnimatedCell = row
        }
    }
    
    func loadCellContent(_ cell: AppCell, row: Int) {
        let app = self.apps[row]
        cell.appIcon.alpha = 0
        cell.appName.text = app.name
        cell.appAuthor.text = app.artist
        
        // TODO: move image loading to to iterator
        cell.appIcon.sd_setImage(with: NSURL(string:app.images[2].url)! as URL) { (image, error, cache, url) in
            cell.appIcon.image = image
            UIView.animate(withDuration: 0.2, animations: {
                cell.appIcon.alpha = 1.0
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var reusableIdentifier = AppCell.AppCellIdentifiers.appCell
        
        if ipad {
            reusableIdentifier = AppCell.AppCellIdentifiers.appCellIpad
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reusableIdentifier, for: indexPath as IndexPath) as! AppCell
        
        applyCellAnimations(cell, row: indexPath.row)
        
        cell.backgroundColor = UIColor.white
        
        loadCellContent(cell, row: indexPath.row)
        
        return cell
    }
}

extension AppCatalogViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        presenter.showDetailsForApp()
    }
}

extension AppCatalogViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellHeight:CGFloat = 112.0
        var itemSize: CGSize
        //let length = (UIScreen.main.bounds.width) / 3 - 1
        var cellWidth = UIScreen.main.bounds.width - 20
        
        if ipad {
            cellHeight = 170.0
            cellWidth = (UIScreen.main.bounds.width) / 4 - 20
        }
        
        //let cellAttributes = collectionView.layoutAttributesForItem(at: indexPath)
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        
        return itemSize
    }
}
