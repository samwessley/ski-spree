//
//  SmallRock.swift
//  slippy
//
//  Created by Sam Wessley on 2/2/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class LargeRock: SKSpriteNode, Obstacle {
    var obstacleTexture: SKTexture
    var shadowTexture: SKTexture
    
    var obstacleSize: CGSize
    var shadowSize: CGSize
    
    init() {
        obstacleTexture = SKTexture(imageNamed: "rock_large")
        shadowTexture = SKTexture(imageNamed: "rock_large_shadow")

        obstacleSize = CGSize(width: 47, height: 74)
        shadowSize = CGSize(width: 76, height: 26)
        
        //Initialize the rock
        super.init(texture: obstacleTexture, color: UIColor.clear, size: obstacleSize)
        self.name = "smallRock"
        
        initPhysics()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        //Create the shape of the physics body
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: -24, y: 6), CGPoint(x: -24, y: 14), CGPoint(x: 0, y: 30), CGPoint(x: 23, y: 11), CGPoint(x: 7, y: 0), CGPoint(x: -10, y: 0)])
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
        shadow.position = CGPoint(x: -30, y: 13)
        shadow.alpha = 0.2
        self.addChild(shadow)
    }
}
