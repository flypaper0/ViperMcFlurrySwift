//
//  ViperModuleTransitionHandlerProtocol.swift
//  EFS
//
//  Created by Alex Lavrinenko on 21.07.16.
//  Copyright © 2016 Sberbank. All rights reserved.
//


public typealias ModuleTransitionBlock = (sourceModuleTransitionHandler: ViperModuleTransitionHandlerProtocol, destinationModuleTransitionHandler: ViperModuleTransitionHandlerProtocol) -> Void

public protocol ViperModuleTransitionHandlerProtocol: class {
//  var moduleInput: ViperModuleInput? {get set}
  
  func performSegue(segueIdentifier: String)
  func openModuleUsingSegue(segueIdentifier: String) -> ViperOpenModulePromise 
  func closeCurrentModule(animated: Bool)
  func presentViewController(vc: ViperModuleFactory) -> ViperOpenModulePromise
}

public extension ViperModuleTransitionHandlerProtocol {
  public func performSegue(segueIdentifier: String) {
    
  }
  
  public func openModuleUsingSegue(segueIdentifier: String) -> ViperOpenModulePromise {
    return ViperOpenModulePromise()
  }
  
  public func closeCurrentModule(animated: Bool) {
    
  }
  
  func presentViewController(vc: ViperModuleFactory) -> ViperOpenModulePromise {
    return ViperOpenModulePromise()
  }
}

public protocol ViperSplitModuleTransitionHandlerProtocol: ViperModuleTransitionHandlerProtocol {
  func showDetailViewController(vc: ViperModuleFactory) -> ViperOpenModulePromise
}
