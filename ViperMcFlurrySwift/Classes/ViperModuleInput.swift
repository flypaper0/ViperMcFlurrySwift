//
//  ViperModuleInput.swift
//  EFS
//
//  Created by Alex Lavrinenko on 21.07.16.
//  Copyright © 2016 Sberbank. All rights reserved.
//

import Foundation

public protocol ViperModuleInput: class {
  func setModuleOutput(moduleOutput: [String: Any])
}