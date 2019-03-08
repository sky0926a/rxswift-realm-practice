//
//  ViewControllerFlowProtocol.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/8.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation

@objc public protocol ViewControllerFlowProtocol: NSObjectProtocol {
    @objc optional func initMethod()
    @objc optional func setupNavigation()
    @objc optional func setupUI()
    @objc optional func setupLayout()
    @objc optional func reloadView()
    @objc optional func emptyData()
}
