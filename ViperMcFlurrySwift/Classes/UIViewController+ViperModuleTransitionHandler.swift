//
//  UIViewController+ViperModuleTransitionHandler.swift
//  EFS
//
//  Created by Alex Lavrinenko on 21.07.16.
//  Copyright © 2016 Sberbank. All rights reserved.
//

import UIKit

class ViperViewController: UIViewController {
  //  var moduleInput: ViperModuleInput?
}

extension UIViewController: ViperModuleTransitionHandlerProtocol {
  public func openModuleUsingSegue(segueIdentifier: String) -> ViperOpenModulePromise {
    let promise = ViperOpenModulePromise()
    dispatch_async(dispatch_get_main_queue()) {
      self.performSegueWithIdentifier(segueIdentifier, sender: promise)
    }
    return promise
  }
  
  public func closeCurrentModule(animated: Bool) {
    guard let isNavigationStack = parentViewController?
      .isKindOfClass(UINavigationController.classForCoder()) else {
        return
    }
    let hasBigStack = isNavigationStack ?
      (self.parentViewController as! UINavigationController)
        .childViewControllers.count > 1 : false
    if isNavigationStack && hasBigStack {
      let navigationController = self.parentViewController as! UINavigationController
      navigationController.popViewControllerAnimated(animated)
    }
    else if let _ = self.presentingViewController {
      self.dismissViewControllerAnimated(animated, completion: nil)
    } else if let _ = self.view.superview {
      self.removeFromParentViewController()
      self.view.removeFromSuperview()
    }
  }
}