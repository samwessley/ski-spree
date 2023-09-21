//
//  LargeRock.swift
//  slippy
//
//  Created by Sam Wessley on 2/9/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class SmallRock: SKSpriteNode, Obstacle {
    var obstacleTexture: SKTexture
    var shadowTexture: SKTexture
    
    var obstacleSize: CGSize
    var shadowSize: CGSize
    
    init() {
        obstacleTexture = SKTexture(imageNamed: "rock_small")
        shadowTexture = SKTexture(imageNamed: "rock_small_shadow")
        
        obstacleSize = CGSize(width: 50, height: 39)
        shadowSize = CGSize(width: 54, height: 24)
        
        //Initialize the rock
        super.init(texture: obstacleTexture, color: UIColor.clear, size: obstacleSize)
        self.name = "largeRock"
        
        initPhysics()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        //Create the shape of the physics body
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: -24, y: 10), CGPoint(x: -24, y: 16), CGPoint(x: 3, y: 28), CGPoint(x: 20, y: 20), CGPoint(x: 24, y: 8), CGPoint(x: 9, y: 1), CGPoint(x: -11, y: 4)])
        path.closeSubpath()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = PhysicsCategory.rock
        self.physicsBody?.contactTestBitMask = PhysicsCategory.rock | PhysicsCategory.cabin | PhysicsCategory.snowman
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.collisionBitMask = 0
    }
    
    func createShadow() {
        let shadow = SKSpriteNode(texture: shadowTexture, color: UIColor.clear, size: shadowSize)
        shadow.zPosition = self.zPosition - 20
        shadow.position = CGPoint(x: -16, y: 12)
        shadow.alpha = 0.2
        self.addChild(shadow)
    }
}
