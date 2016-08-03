//
//  UIViewController+ViperModuleTransitionHandler.swift
//  EFS
//
//  Created by Alex Lavrinenko on 21.07.16.
//  Copyright © 2016 Sberbank. All rights reserved.
//

import UIKit

extension UIViewController: ViperModuleTransitionHandlerProtocol {
  public func openModuleUsingSegue(segueIdentifier: String) -> ViperOpenModulePromise {
    let promise = ViperOpenModulePromise()
    
    self.performSegueWithIdentifier(segueIdentifier, sender: promise) {
      segue in
      if let moduleInput = segue.destinationViewController as? ViperModuleInput {
        promise.moduleInput = moduleInput
      }
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
  
  public func presentViewController(vc: ViperModuleFactory) -> ViperOpenModulePromise {
    let promise = ViperOpenModulePromise()
    let vc = vc.instantiateModuleTransitionHandler() as! UIViewController
    guard let input = vc as? ViperModuleInput else {
      fatalError("Destination ViewController doesnot conform to ViperInputModule protocol")
    }
    promise.moduleInput = input
    dispatch_async(dispatch_get_main_queue()) {
      self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
    }
    return promise
  }
  
public func showPopoverViewController(vc: ViperModuleFactory, target: UIView,
                                        direction: UIPopoverArrowDirection) -> ViperOpenModulePromise {
    let promise = ViperOpenModulePromise()
    let vc = vc.instantiateModuleTransitionHandler() as! UIViewController
    vc.modalPresentationStyle = .Popover
    guard let popover = vc.popoverPresentationController else {
      fatalError("Not a popover. At all.")
    }
    popover.permittedArrowDirections = direction
    popover.sourceView = target
    popover.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    guard let input = vc as? ViperModuleInput else {
      fatalError("Destination ViewController doesnot conform to ViperInputModule protocol")
    }
    promise.moduleInput = input
    dispatch_async(dispatch_get_main_queue()) {
      self.presentViewController(vc as! UIViewController, animated: true, completion: nil)
    }
    return promise
  }
  
  struct AssociatedKey {
    static var ClosurePrepareForSegueKey = "ClosurePrepareForSegueKey"
    static var token: dispatch_once_t = 0
  }
  
  typealias ConfiguratePerformSegue = (UIStoryboardSegue) -> ()
  func performSegueWithIdentifier(identifier: String, sender: AnyObject?, configurate: ConfiguratePerformSegue?) {
    swizzlingPrepareForSegue()
    configuratePerformSegue = configurate
    performSegueWithIdentifier(identifier, sender: sender)
  }
  
  private func swizzlingPrepareForSegue() {
    dispatch_once(&AssociatedKey.token) {
      let originalSelector = #selector(UIViewController.prepareForSegue(_:sender:))
      let swizzledSelector = #selector(UIViewController.closurePrepareForSegue(_:sender:))
      
      let instanceClass = UIViewController.self
      let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)
      let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)
      
      let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                         method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
      
      if didAddMethod {
        class_replaceMethod(instanceClass, swizzledSelector,
                            method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
      } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
      }
    }
  }
  
  func closurePrepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    configuratePerformSegue?(segue)
    closurePrepareForSegue(segue, sender: sender)
    configuratePerformSegue = nil
  }
  
  var configuratePerformSegue: ConfiguratePerformSegue? {
    get {
      let box = objc_getAssociatedObject(self, &AssociatedKey.ClosurePrepareForSegueKey) as? Box
      return box?.value as? ConfiguratePerformSegue
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKey.ClosurePrepareForSegueKey,
                               Box(newValue),
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
}


extension UISplitViewController: ViperSplitModuleTransitionHandlerProtocol {
  public func showDetailViewController(vc: ViperModuleFactory) -> ViperOpenModulePromise {
    let promise = ViperOpenModulePromise()
    dispatch_async(dispatch_get_main_queue()) {
      self.showDetailViewController(vc.instantiateModuleTransitionHandler() as! UIViewController, sender: nil)
    }
    return promise
  }
}

class Box {
  let value: Any
  init(_ value: Any) {
    self.value = value
  }
}
