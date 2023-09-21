//
//  Skier.swift
//  slippy
//
//  Created by Sam Wessley on 12/9/18.
//  Copyright © 2018 Sam Wessley. All rights reserved.
//

import SpriteKit

class Skier: SKSpriteNode {
    
    var playerTexture = SKTexture(imageNamed: "skier")
    var playerSize = CGSize(width: 16, height: 34)
    
    var shadowTexture = SKTexture(imageNamed: "player_shadow")
    var shadowSize = CGSize(width: 32, height: 6)
    var shadow = SKSpriteNode()

    var sound = SKAudioNode()
    
    //Current ride
    var currentRide = "skis"
    
    //Available rides
    let skisUnlocked = true
    var snowtubeUnlocked = false
    var snowboardUnlocked = false
    var tobogganUnlocked = false
    var snowmobileUnlocked = false
    var hoverboardUnlocked = false
    
    //Add ons
    var defaultSnowLeft: SKEmitterNode?
    var defaultSnowRight: SKEmitterNode?
    var snowmobileSnow: SKEmitterNode?
    var hoverboardFire: SKEmitterNode?
    var hoverboardWindLeft: SKEmitterNode?
    var hoverboardWindRight: SKEmitterNode?
    
    init () {
        super.init(texture: playerTexture, color: UIColor.clear, size: playerSize)
        self.name = "player"
        setPhysics()
        setSound()
        createShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhysics(){
        //First remove any old particle emitters
        removeParticleEmitters()
        
        switch currentRide {
        case "skis":
            self.texture = SKTexture(imageNamed: "skier")
            self.size = CGSize(width: 16, height: 34)
            
            shadow.size = CGSize(width: 24, height: 6)
            shadow.position = CGPoint(x: -16, y: -14)
            shadow.texture = SKTexture(imageNamed: "player_shadow")
            
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 24), center: CGPoint(x: 0, y: -8))
            self.physicsBody?.mass = 0.05
        case "snowtube":
            self.texture = SKTexture(imageNamed: "snowtube")
            self.size = CGSize(width: 28, height: 32)
            
            shadow.size = CGSize(width: 24, height: 6)
            shadow.position = CGPoint(x: -21, y: -14)
            shadow.texture = SKTexture(imageNamed: "player_shadow")
            
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 12), center: CGPoint(x: 0, y: -10))
            self.physicsBody?.mass = 0.0485
        case "snowboard":
            self.texture = SKTexture(imageNamed: "snowboard")
            self.size = CGSize(width: 17, height: 39)
            
            shadow.size = CGSize(width: 24, height: 6)
            shadow.position = CGPoint(x: -16, y: -14)
            shadow.texture = SKTexture(imageNamed: "player_shadow")
            
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: 26), center: CGPoint(x: -1, y: -10))
            self.physicsBody?.mass = 0.047
        case "toboggan":
            self.texture = SKTexture(imageNamed: "toboggan")
            self.size = CGSize(width: 22, height: 58)
            
            shadow.size = CGSize(width: 20, height: 44)
            shadow.position = CGPoint(x: -14, y: -34)
            shadow.texture = SKTexture(imageNamed: "toboggan_shadow")
            
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 13, height: 46), center: CGPoint(x: 0, y: -12))
            self.physicsBody?.mass = 0.06
        case "snowmobile":
            self.texture = SKTexture(imageNamed: "snowmobile")
            self.size = CGSize(width: 24, height: 46)
            
            shadow.size = CGSize(width: 44, height: 30)
            shadow.position = CGPoint(x: -12, y: -21)
            shadow.texture = SKTexture(imageNamed: "snowmobile_shadow")
            
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 13, height: 36), center: CGPoint(x: 0, y: -8))
            self.physicsBody?.mass = 0.052
        case "hoverboard":
            self.texture = SKTexture(imageNamed: "hoverboard")
            self.size = CGSize(width: 20, height: 35)
            
            shadow.size = CGSize(width: 26, height: 8)
            shadow.position = CGPoint(x: -28, y: -30)
            shadow.texture = SKTexture(imageNamed: "hoverboard_shadow")
            
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 14, height: 6), center: CGPoint(x: 0, y: -21))
            self.physicsBody?.mass = 0.03
            
            addHoverboardFire()
            addHoverboardWind()
        default:
            return
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.6)
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.tree | PhysicsCategory.rock | PhysicsCategory.cabin | PhysicsCategory.snowman | PhysicsCategory.goal | PhysicsCategory.flag
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.linearDamping = 1.0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    func createShadow() {
        shadow.zPosition = self.zPosition - 1
        shadow.anchorPoint = CGPoint(x: 0.5, y: 0)
        shadow.alpha = 0.15
        self.addChild(shadow)
    }
    
    func setSound() {
        sound = SKAudioNode(fileNamed: "swoosh.mp3")
        sound.autoplayLooped = false
        self.addChild(sound)
    }
    
    func runCrashedAnimation() {
        let animation = SKEmitterNode(fileNamed: "crashed")
        animation?.zPosition = self.zPosition - 1
        self.addChild(animation!)
        
        let animation2 = SKEmitterNode(fileNamed: "crash_cloud")
        animation2?.position = CGPoint(x: 0, y: -10)
        self.addChild(animation2!)
    }
    
    func addDefaultSnow() {
        defaultSnowLeft = SKEmitterNode(fileNamed: "default_snow_trail")
        defaultSnowLeft!.zRotation = 0.349066
        defaultSnowLeft!.zPosition = self.zPosition - 1
        
        defaultSnowRight = SKEmitterNode(fileNamed: "default_snow_trail")
        defaultSnowRight!.zPosition = self.zPosition - 1
        
        if currentRide == "skis" {
            defaultSnowLeft!.position = CGPoint(x: -5, y: -19)
            defaultSnowRight!.position = CGPoint(x: 5, y: -19)
        } else if currentRide == "snowtube" {
            defaultSnowLeft!.position = CGPoint(x: -12, y: -15)
            defaultSnowRight!.position = CGPoint(x: 12, y: -15)
        } else if currentRide == "snowboard" {
            defaultSnowLeft!.position = CGPoint(x: -6, y: -19)
            defaultSnowRight!.position = CGPoint(x: 4, y: -19)
        } else if currentRide == "toboggan" {
            defaultSnowLeft!.position = CGPoint(x: -8, y: -30)
            defaultSnowRight!.position = CGPoint(x: 8, y: -30)
        } else if currentRide == "snowmobile" {
            defaultSnowLeft!.position = CGPoint(x: -11, y: -27)
            defaultSnowRight!.position = CGPoint(x: 11, y: -27)
        }

        self.addChild(defaultSnowLeft!)
        self.addChild(defaultSnowRight!)
    }
    
    func addSnowmobileSnow() {
        snowmobileSnow = SKEmitterNode(fileNamed: "snowmobile_snow")
        snowmobileSnow!.position = CGPoint(x: 0, y: 10)
        snowmobileSnow!.zPosition = self.zPosition - 1
        self.addChild(snowmobileSnow!)
    }
    
    func addHoverboardWind() {
        hoverboardWindLeft = SKEmitterNode(fileNamed: "hoverboard_wind")
        hoverboardWindLeft!.position = CGPoint(x: -2, y: -35)
        hoverboardWindLeft!.zRotation = 3.14159
        hoverboardWindLeft!.zPosition = self.zPosition - 1
        self.addChild(hoverboardWindLeft!)
        
        hoverboardWindRight = SKEmitterNode(fileNamed: "hoverboard_wind")
        hoverboardWindRight!.position = CGPoint(x: 2, y: -35)
        hoverboardWindRight!.zPosition = self.zPosition - 1
        self.addChild(hoverboardWindRight!)
    }
    
    func addHoverboardFire() {
        hoverboardFire = SKEmitterNode(fileNamed: "fire")
        hoverboardFire!.position = CGPoint(x: 0, y: -20)
        hoverboardFire!.zPosition = self.zPosition - 1
        self.addChild(hoverboardFire!)
    }
    
    func removeParticleEmitters() {
        if defaultSnowLeft != nil {
            defaultSnowLeft?.removeFromParent()
        }
        if defaultSnowRight != nil {
            defaultSnowRight?.removeFromParent()
        }
        if snowmobileSnow != nil {
            snowmobileSnow?.removeFromParent()
        }
        if hoverboardFire != nil {
            hoverboardFire?.removeFromParent()
        }
        if hoverboardWindLeft != nil {
            hoverboardWindLeft?.removeFromParent()
        }
        if hoverboardWindRight != nil {
            hoverboardWindRight?.removeFromParent()
        }
    }
}
