//
//  BNRLoadingScreen.swift
//  Blog Nerd Ranch
//
//  Created by Jake Dunahee on 4/4/19.
//  Copyright © 2019 Chris Downie. All rights reserved.
//

import UIKit

class BNRLoadingScreen: UIView {
    
    // Public Vars
    public static let shared = BNRLoadingScreen()
    
    // Private Vars
    private var blurView: UIVisualEffectView?
    private var indicator: UIActivityIndicatorView?
    private var loadingView: BNRLoadingScreen?
    
    // MARK: Public Functions
    
    public func showLoadingScreen(forView view: UIView) {
        if loadingView == nil {
            loadingView = UINib(nibName: "BNRLoadingScreen", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? BNRLoadingScreen
        }
        
        if !view.subviews.contains(loadingView!) {
            loadingView?.frame = view.frame
            view.addSubview(loadingView!)
        }
    }
    
    public func hideLoadingScreen() {
        self.loadingView?.removeFromSuperview()
    }
    
}
