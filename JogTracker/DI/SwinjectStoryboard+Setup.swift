//
//  SwinjectStoryboard+Setup.swift
//  JogTracker
//
//  Created by Александр on 6/21/20.
//  Copyright © 2020 AlexandrMazurov. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc
    class func setup() {
        if SceneDelegate.dependencyRegistry == nil {
            SceneDelegate.dependencyRegistry = DependencyRegistry(container: defaultContainer)
        }
        
        let dependencyRegistry: DependencyRegistryProtocol = SceneDelegate.dependencyRegistry
        
        func main() {
            // TODO: make storyboardInitCompleted
        }
        
        main()
    }
}
