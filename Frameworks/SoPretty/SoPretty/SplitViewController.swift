//
//  SplitViewController.swift
//  SoPretty
//
//  Created by Ben Kraus on 11/30/16.
//  Copyright © 2016 Instructure. All rights reserved.
//

import UIKit
import SoIconic

open class SplitViewController: UISplitViewController {
    public var shouldCollapseDetail: Bool = true

    public init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if let firstNav = viewControllers.first as? UINavigationController {
            return firstNav.navigationBar.barStyle == .black ? .lightContent : .default
        } else {
            return viewControllers.first!.preferredStatusBarStyle
        }
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    public func targetDisplayModeForAction(in svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        if svc.displayMode == .primaryOverlay || svc.displayMode == .primaryHidden {
            if let nav = svc.viewControllers.last as? UINavigationController {
                nav.topViewController?.navigationItem.leftBarButtonItem = prettyDisplayModeButtonItem
            }
            return .allVisible;
        } else {
            if let nav = svc.viewControllers.last as? UINavigationController {
                nav.topViewController?.navigationItem.leftBarButtonItem = prettyDisplayModeButtonItem
            }
            return .primaryHidden;
        }
    }

    public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Returns true, cuz on iPad we don't use overlay types (so far). It's either hidden or all. If that changes, change this and logic in EnrollmentsTab to handle everything correctly
        return shouldCollapseDetail
    }
}

extension UISplitViewController {
    open var prettyDisplayModeButtonItem: UIBarButtonItem {
        let defaultButton = self.displayModeButtonItem
        let icon: UIImage
        if displayMode == .primaryOverlay || displayMode == .primaryHidden {
            icon = .icon(.collapse)
        } else {
            icon = .icon(.expand)
        }
        let prettyButton = UIBarButtonItem(image: icon, style: .plain, target: defaultButton.target, action: defaultButton.action)
        return prettyButton
    }
}
