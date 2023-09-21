//
//  Obstacle.swift
//  slippy
//
//  Created by Sam Wessley on 2/20/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

protocol Obstacle {
    var obstacleTexture: SKTexture {get set}
    var shadowTexture: SKTexture {get set}
    
    var obstacleSize: CGSize {get set}
    var shadowSize: CGSize {get set}

    func initPhysics()
    
    func createShadow()
}
