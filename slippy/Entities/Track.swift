//
//  Track.swift
//  slippy
//
//  Created by Sam Wessley on 3/2/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class Track: SKSpriteNode {
    init() {
        super.init(texture: nil, color: SKColor(red:0.79, green:0.86, blue:0.93, alpha:1.0), size: CGSize(width: 4, height: 4))
        self.name = "track"
        initPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.track
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.mass = 0
    }
}
