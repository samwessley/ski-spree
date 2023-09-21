//
//  Obstacle.swift
//  slippy
//
//  Created by Sam Wessley on 11/24/18.
//  Copyright © 2018 Sam Wessley. All rights reserved.
//

import SpriteKit

class Tree: SKSpriteNode, Obstacle {
    var obstacleTexture: SKTexture
    var shadowTexture: SKTexture
    
    var obstacleSize: CGSize
    var shadowSize: CGSize
    
    let rand: Int
    
    init() {
        rand = Int(arc4random_uniform(UInt32(3)))
        if rand == 0 {
            obstacleTexture = SKTexture(imageNamed: "tree_small")
            obstacleSize = CGSize(width: 44, height: 94)
            shadowTexture = SKTexture(imageNamed: "tree_small_shadow")
            shadowSize = CGSize(width: 90, height: 19)
        } else if rand == 1 {
            obstacleTexture = SKTexture(imageNamed: "tree_medium")
            obstacleSize = CGSize(width: 58, height: 150)
            shadowTexture = SKTexture(imageNamed: "tree_medium_shadow")
            shadowSize = CGSize(width: 130, height: 25)
        } else {
            obstacleTexture = SKTexture(imageNamed: "tree_large")
            obstacleSize = CGSize(width: 60, height: 164)
            shadowTexture = SKTexture(imageNamed: "tree_large_shadow")
            shadowSize = CGSize(width: 140, height: 32)
        }
        
        //Initialize the tree
        super.init(texture: obstacleTexture, color: UIColor.clear, size: obstacleSize)
        self.name = "tree"
        
        initPhysics()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func initPhysics() {
        //Create the shape of the physics body
        let path = CGMutablePath()
        if rand == 0 {
            path.addLines(between: [CGPoint(x: -10, y: 18), CGPoint(x: 0, y: 32), CGPoint(x: 10, y: 18), CGPoint(x: 0, y: 0)])
        } else {
            path.addLines(between: [CGPoint(x: -14, y: 22), CGPoint(x: 0, y: 40), CGPoint(x: 14, y: 22), CGPoint(x: 0, y: 0)])
        }
        path.closeSubpath()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = PhysicsCategory.tree
        self.physicsBody?.contactTestBitMask = PhysicsCategory.tree | PhysicsCategory.rock | PhysicsCategory.cabin | PhysicsCategory.snowman
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.collisionBitMask = 0
    }
    
    func createShadow() {
        let shadow = SKSpriteNode(texture: shadowTexture, color: UIColor.clear, size: shadowSize)
        shadow.zPosition = self.zPosition - 20
        
        if rand == 0 {
            shadow.position = CGPoint(x: -39, y: 2)
        } else if rand == 1 {
            shadow.position = CGPoint(x: -58, y: 3)
        } else {
            shadow.position = CGPoint(x: -63, y: 5)
        }
        
        shadow.alpha = 0.2
        self.addChild(shadow)
    }
}
