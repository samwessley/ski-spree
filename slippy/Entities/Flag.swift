//
//  Flag.swift
//  slippy
//
//  Created by Sam Wessley on 2/2/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class Flag: SKSpriteNode {
    var obstacleTexture: SKTexture
    var shadowTexture: SKTexture
    
    var obstacleSize: CGSize
    var shadowSize: CGSize
    
    init(color: String) {
        if color == "red" {
            obstacleTexture = SKTexture(imageNamed: "flag_red")
        } else {
            obstacleTexture = SKTexture(imageNamed: "flag_blue")
        }
        shadowTexture = SKTexture(imageNamed: "flag_shadow")
        
        obstacleSize = CGSize(width: 20, height: 30)
        shadowSize = CGSize(width: 40, height: 3)
        
        //Initialize the flag
        super.init(texture: obstacleTexture, color: UIColor.clear, size: obstacleSize)
        self.name = "flag"
        
        initPhysics()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 5), center: CGPoint(x: 0, y: 2))
        self.physicsBody?.categoryBitMask = PhysicsCategory.flag
        self.physicsBody?.contactTestBitMask = PhysicsCategory.coin
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.pinned = true
    }
    
    func createShadow() {
        let shadow = SKSpriteNode(texture: shadowTexture, color: UIColor.clear, size: shadowSize)
        shadow.position = CGPoint(x: -12, y: 2)
        shadow.zPosition = self.zPosition - 20
        shadow.alpha = 0.2
        self.addChild(shadow)
    }
}
