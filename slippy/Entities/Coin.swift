//
//  coin.swift
//  slippy
//
//  Created by Sam Wessley on 4/21/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    var coinTexture = SKTexture(imageNamed: "coin")
    var textures = [SKTexture]()
    var shadowTexture = SKTexture(imageNamed: "coin_shadow")
    
    let up = SKAction.moveBy(x: 0, y: 7, duration: 0.4)
    let down = SKAction.moveBy(x: 0, y: -7, duration: 0.4)
    
    init() {
        //Initialize the coin
        super.init(texture: coinTexture, color: UIColor.clear, size: CGSize(width: 14, height: 14))
        self.name = "coin"
        
        //Animate the coin
        let animation = SKAction.sequence([up, down])
        self.run(SKAction.repeatForever(animation))
        
        initPhysics()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysics(){
        //Create the shape of the physics body
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin
        self.physicsBody?.contactTestBitMask = PhysicsCategory.flag
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1
    }
    
    func createShadow() {
        let shadow = SKSpriteNode(texture: shadowTexture, color: UIColor.clear, size: CGSize(width: 10, height: 3))
        shadow.zPosition = self.zPosition - 1
        shadow.position = CGPoint(x: 0, y: -6)
        shadow.alpha = 0.2
        
        //Counteract the coin animation with opposite animation
        let animation = SKAction.sequence([down, up])
        shadow.run(SKAction.repeatForever(animation))
        
        self.addChild(shadow)
    }
}
