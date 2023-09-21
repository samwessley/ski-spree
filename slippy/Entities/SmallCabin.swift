//
//  SmallCabin.swift
//  slippy
//
//  Created by Sam Wessley on 2/9/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class SmallCabin: SKSpriteNode, Obstacle {
    var obstacleTexture: SKTexture
    var shadowTexture: SKTexture
    
    var obstacleSize: CGSize
    var shadowSize: CGSize
    
    init() {
        obstacleTexture = SKTexture(imageNamed: "cabin_small")
        shadowTexture = SKTexture(imageNamed: "cabin_small_shadow")
        
        obstacleSize = CGSize(width: 140, height: 144)
        shadowSize = CGSize(width: 160, height: 74)
        
        //Initialize the tree
        super.init(texture: obstacleTexture, color: UIColor.clear, size: obstacleSize)
        self.name = "smallCabin"
        
        initPhysics()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        //Create the shape of the physics body
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: -64, y: 35), CGPoint(x: -16, y: 62), CGPoint(x: 65, y: 23), CGPoint(x: 15, y: 0)])
        path.closeSubpath()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = PhysicsCategory.cabin
        self.physicsBody?.contactTestBitMask = PhysicsCategory.cabin | PhysicsCategory.snowman
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.collisionBitMask = 0
    }
    
    func createShadow() {
        let shadow = SKSpriteNode(texture: shadowTexture, color: UIColor.clear, size: shadowSize)
        shadow.zPosition = self.zPosition - 20
        shadow.position = CGPoint(x: -66, y: 34)
        shadow.alpha = 0.2
        self.addChild(shadow)
    }
}
