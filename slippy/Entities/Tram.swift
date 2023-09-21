//
//  Tram.swift
//  slippy
//
//  Created by Sam Wessley on 4/6/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit

class Tram: SKSpriteNode {
    var shadowTexture: SKTexture
    var shadowSize: CGSize
    
    init() {
        shadowTexture = SKTexture(imageNamed: "tram_shadow")
        shadowSize = CGSize(width: 181, height: 52)
        
        super.init(texture: SKTexture(imageNamed: "tram"), color: UIColor.clear, size: CGSize(width: 120, height: 191))
        self.name = "tram"
        
        initPhysics()
        createShadow()
        addCable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCable() {
        let cable = SKSpriteNode(texture: nil, color: UIColor(red:0.30, green:0.30, blue:0.36, alpha:1.0), size: CGSize(width: 1220, height: 3))
        cable.position = CGPoint(x: 0, y: self.position.y + 83)
        cable.zPosition = self.zPosition + 1
        cable.zRotation = 0.4
        self.addChild(cable)
    }
    
    func initPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.tram
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.density = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.collisionBitMask = 0
    }
    
    func createShadow() {
        //Create tram shadow
        let shadow = SKSpriteNode(texture: shadowTexture, color: UIColor.clear, size: shadowSize)
        shadow.position = CGPoint(x: -220, y: -220)
        shadow.alpha = 0.2
        self.addChild(shadow)
        
        //Create cable shadow
        let cableShadow = SKSpriteNode(texture: nil, color: UIColor(red:0.04, green:0.05, blue:0.38, alpha:0.06), size: CGSize(width: 1220, height: 3))
        cableShadow.position = CGPoint(x: 0, y: -95)
        cableShadow.zRotation = 0.4
        self.addChild(cableShadow)
    }
}
