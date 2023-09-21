//
//  LargeCabin.swift
//  slippy
//
//  Created by Sam Wessley on 2/2/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class LargeCabin: SKSpriteNode, Obstacle {
    var obstacleTexture: SKTexture
    var shadowTexture: SKTexture
    
    var obstacleSize: CGSize
    var shadowSize: CGSize
    
    init() {
        obstacleTexture = SKTexture(imageNamed: "cabin_large")
        shadowTexture = SKTexture(imageNamed: "cabin_large_shadow")
        
        obstacleSize = CGSize(width: 200, height: 168)
        shadowSize = CGSize(width: 156, height: 91)
        
        //Initialize the tree
        super.init(texture: obstacleTexture, color: UIColor.clear, size: obstacleSize)
        self.name = "largeCabin"
        
        initPhysics()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        //Create the shape of the physics body
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: -87, y: 40), CGPoint(x: 6, y: 85), CGPoint(x: 88, y: 42), CGPoint(x: -3, y: 0)])
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
        shadow.position = CGPoint(x: -80, y: 39)
        shadow.alpha = 0.2
        self.addChild(shadow)
    }
}
