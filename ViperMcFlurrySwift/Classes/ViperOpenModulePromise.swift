//
//  ViperOpenModulePromise.swift
//  EFS
//
//  Created by Alex Lavrinenko on 21.07.16.
//  Copyright © 2016 Sberbank. All rights reserved.
//

import Foundation

public typealias PostLinkActionBlock = () -> Void

public typealias ViperModuleLinkBlock = (moduleInput: ViperModuleInput) -> (ViperModuleOutput?)

public class ViperOpenModulePromise {
  public var moduleInput: ViperModuleInput? {
    didSet {
      performLink()
    }
  }
  
  public var postLinkActionBlock: PostLinkActionBlock?
  
  private var linkBlock: ViperModuleLinkBlock?
  
  
  public func thenChainUsingBlock(linkBlock: ViperModuleLinkBlock) {
    self.linkBlock = linkBlock
    performLink()
  }
  
  private func performLink() {
    guard let moduleInput = moduleInput,
    let postLinkActionBlock = postLinkActionBlock,
    let linkBlock = linkBlock else {
      return
    }
//    let moduleOutput: ViperModuleOutput = linkBlock(moduleInput: moduleInput)!
//    moduleInput.setModuleOutput(moduleOutput)
    postLinkActionBlock()
  }
}
