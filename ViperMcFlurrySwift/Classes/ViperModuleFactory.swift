//
//  ViperModuleFactory.swift
//  EFS
//
//  Created by Alex Lavrinenko on 21.07.16.
//  Copyright © 2016 Sberbank. All rights reserved.
//

import Foundation

public struct ViperModuleFactory {
  
  let storyboard: UIStoryboard
  let restorationId: String
  
  public init(storyboard: UIStoryboard, restorationId: String) {
    self.storyboard = storyboard
    self.restorationId = restorationId
  }
  
  public func instantiateModuleTransitionHandler() -> ViperModuleTransitionHandlerProtocol {
    let vc = storyboard.instantiateViewControllerWithIdentifier(restorationId)
    return vc
  }
}
