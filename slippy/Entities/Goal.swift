//
//  Goal.swift
//  slippy
//
//  Created by Sam Wessley on 3/27/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class Goal: SKSpriteNode {
    var flag1 = SKSpriteNode()
    var flag2 = SKSpriteNode()
    
    var passed = false
    
    init(width: Int, color: String) {
        //Initialize and set up the goal
        super.init(texture: nil, color: .clear, size: CGSize(width: width, height: 5))
        self.name = "goal"
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        initPhysics()
        addFlags(color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: 0, y: self.size.height/2))
        self.physicsBody?.categoryBitMask = PhysicsCategory.goal
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategory.coin
    }
    
    func addFlags(color: String) {
        flag1 = Flag(color: color)
        flag2 = Flag(color: color)
        
        flag1.position = CGPoint(x: -self.size.width/2 - flag1.size.width/2, y: 0)
        flag2.position = CGPoint(x: self.size.width/2 + flag2.size.width/2, y: 0)
        
        self.addChild(flag1)
        self.addChild(flag2)
    }
}
