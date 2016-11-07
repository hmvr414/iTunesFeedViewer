//
//  AppDetailViewController.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 6/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit
import IBAnimatable

protocol AppDetailView : class {
    func updateAppImage(_ image: UIImage)
    func updateAppTitle(_ title: String)
    func updateAppAuthor(_ author: String)
    func updateAppSummary(_ summary: String)
    func displayError(_ message: String)
    
}

class AppDetailViewController : UIViewController {
    
    var presenter:AppDetailPresenterInput!
    
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var appAuthor: UILabel!
    @IBOutlet weak var appSummary: UITextView!
    @IBOutlet weak var headBackground: AnimatableView!
    
    override func awakeFromNib() {
        AppDetailDependencies.setup(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.appSummary.setContentOffset(CGPoint.zero, animated: false)
    }
    override func viewDidLoad() {
        presenter.loadContent()
        self.navigationController?.delegate = self
    }
}

extension AppDetailViewController : AppDetailView {
    
    func updateAppImage(_ image: UIImage) {
        self.appImage.image = image
    }
    
    func updateAppTitle(_ title: String) {
        //self.appTitle.text = title
        
        
        self.navigationItem.title = title
    }
    
    func updateAppAuthor(_ author: String) {
        self.appAuthor.text = author
    }
    
    func updateAppSummary(_ summary: String) {
        self.appSummary.text = summary
        self.appSummary.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func displayError(_ message: String) {
        view.makeToast(message: message)
    }
}

extension AppDetailViewController : UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            return PushAnimator()
        }
        
        if operation == UINavigationControllerOperation.pop {
            return PopAnimator();
        }
        
        
        return nil;
    }
}

extension AppDetailViewController : PushAnimatorView {
    
    func animateAppIcon(originFrame: CGRect, duration: TimeInterval) {
        let targetFrame = CGRect(x: (UIScreen.main.bounds.width - appImage.frame.size.width) / 2.0,
                                 y: appImage.frame.origin.y,
                                 width: appImage.frame.size.width,
                                 height: appImage.frame.size.height)
        
        let imageView = UIImageView(frame: originFrame)
        imageView.image = appImage.image
        imageView.layer.zPosition = 1;
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(imageView)
        appImage.alpha = 0;
        headBackground.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            imageView.frame = targetFrame
        }, completion: { finished in
            self.appImage.alpha = 1;
            self.headBackground.alpha = 1
            self.animateHeadBackground(duration: 0.4)
            imageView.removeFromSuperview()
        })
    }
    
    func animateHeadBackground(duration: TimeInterval) {
        let originFrame = CGRect(x: UIScreen.main.bounds.width / 2 ,
                                 y: headBackground.frame.origin.y,
                                 width: 1,
                                 height: headBackground.frame.size.height)
        
        let targetFrame = headBackground.frame
        
        headBackground.frame = originFrame
        
        UIView.animate(withDuration: duration, animations: {
            self.headBackground.frame = targetFrame
        })
    }
    
    func performPushAnimations(originFrame: CGRect, duration: TimeInterval) {
        //self.view.translatesAutoresizingMaskIntoConstraints = true
        animateAppIcon(originFrame: originFrame, duration: duration)
        /*let targetFrame = appImage.frame
        //appImage.frame = originFrame
        appImage.alpha = 0;
        //appImage.layer.zPosition = 1;
        
        let imageView = UIImageView(frame: originFrame)
        imageView.image = appImage.image
        imageView.layer.zPosition = 1;
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(imageView)
        //self.headBackground.zoom(.in)
        UIView.animate(withDuration: duration, animations: {
            //self.appImage.frame = targetFrame
            imageView.frame = CGRect(x: (UIScreen.main.bounds.width - targetFrame.size.width) / 2.0, y: targetFrame.origin.y, width: targetFrame.size.width, height: targetFrame.size.height)// self.appImage.frame
        }, completion: { finished in
            self.appImage.alpha = 1;
            self.headBackground.zoom(.in)
            imageView.removeFromSuperview()
        })*/
    }
}
