//
//  GameElements.swift
//  slippy
//
//  Created by Sam Wessley on 3/21/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit
import GameplayKit
import StoreKit

struct PhysicsCategory {
    static let player:UInt32 = 0x1 << 0
    static let world:UInt32 = 0x1 << 1
    static let tree:UInt32 = 0x1 << 2
    static let rock:UInt32 = 0x1 << 3
    static let cabin:UInt32 = 0x1 << 4
    static let snowman:UInt32 = 0x1 << 5
    static let goal:UInt32 = 0x1 << 6
    static let flag:UInt32 = 0x1 << 7
    static let track:UInt32 = 0x1 << 8
    static let tram:UInt32 = 0x1 << 9
    static let coin:UInt32 = 0x1 << 10
}

extension GameScene {
    func buildMap() {
        //Generate a random seed for the map
        let rand = randomInRange(lo: 0, hi: 47)
        map = GKNoiseMap(noise, size: vector2(Double(self.frame.size.width), 1), origin: (vector2(Double(rand), 0)), sampleCount: vector2(50, 50), seamless: false)
    }
    
    func getIAPproducts() {
        products = []
        
        SkiSpreeProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
                if success {
                    self.products = products!
                }
        }
    }
    
    func searchProductArray(productIdentifier: String) -> SKProduct? {
        for product in products {
            if product.productIdentifier == productIdentifier {
                return product
            }
        }
        displayErrorMakingPurchaseAlert()
        return nil
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String
        else { return }
        
        switch productID {
        case "com.eudeon.skispree.7500_coinpack":
            addCoins(coins: 7500)
        case "com.eudeon.skispree.45000_coinpack":
            addCoins(coins: 45000)
        case "com.eudeon.skispree.90000_coinpack":
            addCoins(coins: 90000)
        case "com.eudeon.skispree.180000_coinpack":
            addCoins(coins: 180000)
        case "com.eudeon.skispree.500000_coinpack":
            addCoins(coins: 500000)
        case "com.eudeon.skispree.1200000_coinpack":
            addCoins(coins: 1200000)
        default:
            return
        }
        //Save the coins
        UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
        
        updateCoinsLabel()
        dismissSpinner()
        print("purchase of" + productID + " was successful!")
    }
    
    @objc func handlePurchaseFailedNotification(_ notification: Notification) {
        dismissSpinnerOnFailedPurchase()
    }
    
    @objc func handlePurchaseCancelledNotification(_ notification: Notification) {
        dismissSpinner()
    }
    
    func addCoins(coins: Int) {
        totalCoins = totalCoins + coins
    }
    
    func spawnPlayer() {
        player.position = CGPoint(x: 0, y: -110)
        player.zPosition = -100
        
        player.setPhysics()
        
        world.addChild(player)
    }
    
    func spawnObstacle() {
        var obstacle: SKSpriteNode
        
        //Determine what type of obstacle is generated
        let x = randomNumber(probabilities: [0.912, 0.02, 0.04, 0.005, 0.018, 0.005])
        if x == 0 {
            obstacle = Tree()
        } else if x == 1 {
            obstacle = LargeRock()
        } else if x == 2 {
            obstacle = SmallRock()
        } else if x == 3 {
            obstacle = LargeCabin()
        } else if x == 4 {
            obstacle = SmallCabin()
        } else {
            obstacle = Snowman()
        }
        
        //Generate a random x position for the obstacle
        var randomX = randomInRange(lo: -(self.size.width / 2), hi: (self.size.width / 2))
        while randomX > (currentPoint - (currentWidth / 2) - (obstacle.size.width) - 20) && randomX < (currentPoint + (currentWidth / 2) + (obstacle.size.width) + 20) {
            randomX = randomInRange(lo: -(self.size.width / 2), hi: (self.size.width / 2))
        }
        
        //Set the obstacle's properties
        obstacle.position = CGPoint(x: randomX, y: -(self.size.height / 2) - 300)
        obstacle.physicsBody?.velocity = currentSceneVelocity
        
        obstacle.zPosition = zPositionCounter
        
        world.addChild(obstacle)
    }
    
    func spawnInitialObstacle() {
        var obstacle: SKSpriteNode
        
        //Determine what type of obstacle is generated
        let x = randomNumber(probabilities: [0.955, 0.01, 0.03, 0.005])
        if x == 0 {
            obstacle = Tree()
        } else if x == 1 {
            obstacle = LargeRock()
        } else if x == 2 {
            obstacle = SmallRock()
        } else {
            obstacle = Snowman()
        }
        
        //Generate a random position
        var randomX = randomInRange(lo: -(self.size.width / 2), hi: (self.size.width / 2))
        var randomY = randomInRange(lo: -self.size.height/2 - 180, hi: self.size.height/2)
        while randomX > -130 && randomX < 130 && randomY < -80 {
            randomX = randomInRange(lo: -(self.size.width / 2), hi: (self.size.width / 2))
            randomY = randomInRange(lo: -self.size.height/2, hi: self.size.height/2)
        }

        //Set the obstacle's properties
        obstacle.position = CGPoint(x: randomX, y: randomY)
        obstacle.zPosition = -randomY*5
        
        world.addChild(obstacle)
    }
    
    func createShopButton() {
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            shopButton.size = CGSize(width: 90, height: 81)
        } else {
            shopButton.size = CGSize(width: 60, height: 54)
        }
        shopButton.anchorPoint = CGPoint(x: 0, y: 0)
        shopButton.position = CGPoint(x: -getAdjustedSceneWidth()/2 - 100, y: -self.size.height/2 + 120)
        cam.addChild(shopButton)
        shopButton.run(SKAction.move(to: CGPoint(x: -getAdjustedSceneWidth()/2 + 20, y: -self.size.height/2 + 120), duration: 0.1))
    }
    
    func createRankingsButton() {
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            rankingsButton.size = CGSize(width: 90, height: 81)
        } else {
            rankingsButton.size = CGSize(width: 60, height: 54)
        }
        rankingsButton.anchorPoint = CGPoint(x: 1, y: 0)
        rankingsButton.position = CGPoint(x: -getAdjustedSceneWidth()/2 - 100, y: -self.size.height/2 + 120)
        cam.addChild(rankingsButton)
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            rankingsButton.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 214), duration: 0.1))
        } else {
            rankingsButton.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 194), duration: 0.1))
        }
    }
    
    func createSettingsButton() {
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            settingsButton.size = CGSize(width: 90, height: 81)
        } else {
            settingsButton.size = CGSize(width: 60, height: 54)
        }
        settingsButton.anchorPoint = CGPoint(x: 1, y: 0)
        settingsButton.position = CGPoint(x: getAdjustedSceneWidth()/2 + 100, y: -self.size.height/2 + 120)
        cam.addChild(settingsButton)
        settingsButton.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120), duration: 0.1))
    }
    
    func spawnNoiseTracker() {
        let tracker = Track()
        tracker.position = CGPoint(x: currentPoint, y: -(self.size.height / 2) - 300)
        world.addChild(tracker)
        
        let tracker1 = Track()
        tracker1.zPosition = player.zPosition - 1
        tracker1.color = SKColor(red:0.84, green:0.90, blue:0.96, alpha:1.0)
        tracker1.position = CGPoint(x: currentPoint - 4, y: -(self.size.height / 2) - 300)
        //world.addChild(tracker1)
        
        let tracker2 = Track()
        tracker2.zPosition = player.zPosition - 1
        tracker2.color = SKColor(red:0.84, green:0.90, blue:0.96, alpha:1.0)
        tracker2.position = CGPoint(x: currentPoint + 4, y: -(self.size.height / 2) - 300)
        world.addChild(tracker2)
    }
    
    func spawnGoal() {
        var goal = Goal(width: goalWidth, color: "red")
        let rotationAmount = (randomInRange(lo: 0, hi: goalRotationMax)) * 3.14/180
        
        //Alternate the color of the goal
        if goalColorTracker {
            goal = Goal(width: goalWidth, color: "blue")
            goalRotation = rotationAmount
        } else {
            goalRotation = -rotationAmount
        }
        
        goal.position = CGPoint(x: currentPoint, y: -(self.frame.height / 2) - 300)
        goal.zRotation = goalRotation
        goal.flag1.zRotation = -goalRotation
        goal.flag2.zRotation = -goalRotation
        goal.zPosition = zPositionCounter - 6
        goal.physicsBody?.velocity = currentSceneVelocity
        goalColorTracker = !goalColorTracker
        
        world.addChild(goal)
    }
    
    func spawnTrack() {
        if player.currentRide == "skis" {
            let track1 = Track()
            let track2 = Track()
            
            track1.position = CGPoint(x: player.position.x - 3, y: player.position.y)
            track2.position = CGPoint(x: player.position.x + 3, y: player.position.y)
            
            track1.zPosition = CGFloat(Int.min)
            track2.zPosition = CGFloat(Int.min)
            
            track1.physicsBody?.velocity = currentSceneVelocity
            track2.physicsBody?.velocity = currentSceneVelocity
            
            world.addChild(track1)
            world.addChild(track2)
        }
        
        if player.currentRide == "snowtube" {
            let track1 = Track()
            
            track1.size = CGSize(width: 12, height: 12)
            track1.position = CGPoint(x: player.position.x, y: player.position.y)
            track1.zPosition = CGFloat(Int.min)
            track1.physicsBody?.velocity = currentSceneVelocity
            
            world.addChild(track1)
        }
        
        if player.currentRide == "snowboard" {
            let track1 = Track()
            
            track1.size = CGSize(width: 7, height: 7)
            track1.position = CGPoint(x: player.position.x - 1, y: player.position.y)
            track1.zPosition = CGFloat(Int.min)
            track1.physicsBody?.velocity = currentSceneVelocity
            
            world.addChild(track1)
        }
        
        if player.currentRide == "toboggan" {
            let track1 = Track()
            
            track1.size = CGSize(width: 10, height: 10)
            track1.position = CGPoint(x: player.position.x, y: player.position.y)
            track1.zPosition = CGFloat(Int.min)
            track1.physicsBody?.velocity = currentSceneVelocity
            
            world.addChild(track1)
        }
        
        if player.currentRide == "snowmobile" {
            let track1 = Track()
            let track2 = Track()
            let track3 = Track()
            
            track1.size = CGSize(width: 8, height: 8)
            track1.position = CGPoint(x: player.position.x, y: player.position.y - 10)
            track1.zPosition = CGFloat(Int.min)
            track1.physicsBody?.velocity = currentSceneVelocity
            
            track2.size = CGSize(width: 3, height: 3)
            track2.position = CGPoint(x: player.position.x - 10, y: player.position.y - 10)
            track2.zPosition = CGFloat(Int.min)
            track2.physicsBody?.velocity = currentSceneVelocity
            
            track3.size = CGSize(width: 3, height: 3)
            track3.position = CGPoint(x: player.position.x + 10, y: player.position.y - 10)
            track3.zPosition = CGFloat(Int.min)
            track3.physicsBody?.velocity = currentSceneVelocity
            
            world.addChild(track1)
            world.addChild(track2)
            world.addChild(track3)
        }
    }
    
    func spawnTrams() {
        let wait = SKAction.wait(forDuration: 17, withRange: 8)
        let spawn = SKAction.run {
            let tram = Tram()
            let randomX = self.randomInRange(lo: -self.size.width/2 + 100, hi: self.size.width/2 - 2*tram.size.width/3)
            tram.position = CGPoint(x: randomX, y: -(self.size.height / 2) - 600)
            tram.physicsBody?.velocity = CGVector(dx: 0, dy: self.currentSceneVelocity.dy * 1.07)
            tram.zPosition = self.zPositionCounter + 100
            self.world.addChild(tram)
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence), withKey: "spawnTrams")
    }
    
    func createLogo() {
        let logoTexture = SKTexture(imageNamed: "logo")
        logo = SKSpriteNode(texture: logoTexture)
        logo.size = CGSize(width: 241, height: 133)
        logo.position = CGPoint(x: -getAdjustedSceneWidth()/2 - logo.size.width, y: 110)
        logo.zPosition = 1000
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            logo.setScale(1.5)
        }
        
        self.addChild(logo)
        logo.run(SKAction.move(to: CGPoint(x: 0, y: 110), duration: 0.2))
        
        //Play woosh sound
        playSound(name: wooshSound)
    }
    
    func createScoreLabel() {
        //Create background
        scoreLabelBg = SKSpriteNode(color: UIColor.clear, size: CGSize.zero)
        scoreLabelBg.anchorPoint = CGPoint(x: 0, y: 1)
        scoreLabelBg.position = CGPoint(x: -getAdjustedSceneWidth()/2 + 20, y: self.size.height/2 - 70)
        
        //Configure shadow
        scoreLabelShadow.fontName = "Quick"
        scoreLabelShadow.attributedText = NSAttributedString(string: String(score), attributes: scoreLabelShadowAttributes)
        scoreLabelShadow.fontColor = UIColor(red:0.37, green:0.78, blue:1.00, alpha:1.0)
        scoreLabelShadow.position = CGPoint(x: -9, y: 9)
        scoreLabelShadow.horizontalAlignmentMode = .left
        scoreLabelShadow.verticalAlignmentMode = .top
        
        //Configure score label
        scoreLabel.fontName = "Quick"
        scoreLabel.text = "0"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 0, y: 0)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
    
        //Add labels
        scoreLabelBg.addChild(scoreLabelShadow)
        scoreLabelBg.addChild(scoreLabel)
        cam.addChild(scoreLabelBg)
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            scoreLabelBg.position = CGPoint(x: -getAdjustedSceneWidth()/2 + 30, y: self.size.height/2 - 40)
            
            scoreLabel.setScale(1.2)
            scoreLabelBg.setScale(1.2)
            scoreLabelShadow.setScale(1.2)
            
            scoreLabelShadow.position = CGPoint(x: -10.5, y: 10.5)
        }
    }
    
    func updateScoreLabel() {
        scoreLabel.text = String(score)
        scoreLabelShadow.attributedText = NSAttributedString(string: String(score), attributes: scoreLabelShadowAttributes)
    }
    
    func createCoinsLabel() {
        //Create background
        coinsLabelBg = SKSpriteNode(color: UIColor.clear, size: CGSize.zero)
        coinsLabelBg.anchorPoint = CGPoint(x: 1, y: 1)
        coinsLabelBg.position = CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: self.size.height/2 - 70)
        
        //Configure coin icon
        let coinIconTexture = SKTexture(imageNamed: "coin_border")
        let coinIcon = SKSpriteNode(texture: coinIconTexture, color: .clear, size: CGSize(width: 16, height: 16))
        coinIcon.anchorPoint = CGPoint(x: 0, y: 1)
        coinIcon.position = CGPoint(x: 1, y: -1.5)
        
        //Configure shadow
        coinsLabelShadow.attributedText = NSAttributedString(string: String(totalCoins), attributes: coinsLabelShadowAttributes)
        coinsLabelShadow.position = CGPoint(x: -3, y: 13)
        coinsLabelShadow.horizontalAlignmentMode = .right
        coinsLabelShadow.verticalAlignmentMode = .top
        
        //Configure coins label
        coinsLabel.fontName = "Quick"
        coinsLabel.text = String(totalCoins)
        coinsLabel.fontSize = 20
        coinsLabel.fontColor = .white
        coinsLabel.position = CGPoint(x: -16, y: 0)
        coinsLabel.horizontalAlignmentMode = .right
        coinsLabel.verticalAlignmentMode = .top
        
        //Add labels
        coinsLabel.addChild(coinIcon)
        coinsLabelBg.addChild(coinsLabelShadow)
        coinsLabelBg.addChild(coinsLabel)
        cam.addChild(coinsLabelBg)
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            coinsLabelBg.position = CGPoint(x: getAdjustedSceneWidth()/2 - 30, y: self.size.height/2 - 40)
            coinsLabel.fontSize = 30
            coinsLabelShadowAttributes.updateValue(UIFont(name: "Quick", size: 30)!, forKey: .font)
            coinIcon.size = CGSize(width: coinIcon.size.width * 1.5, height: coinIcon.size.height * 1.5)
            coinsLabelShadow.position = CGPoint(x: -3, y: 13)
        }
    }
    
    func updateCoinsLabel() {
        coinsLabel.text = String(totalCoins)
        coinsLabelShadow.attributedText = NSAttributedString(string: String(totalCoins), attributes: coinsLabelShadowAttributes)
    }
    
    func removeScoreAndCoinsLabels() {
        //Remove the score labels from the top of the screen
        scoreLabelBg.removeFromParent()
        //coinsLabelBg.removeFromParent()
    }
    
    func restart() {
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        self.view?.presentScene(newScene)
    }
    
    func runFadeInEffect() {
        let fade = SKSpriteNode(color: .black, size: self.size)
        fade.position = .zero
        cam.addChild(fade)
        let fadeEffect = SKAction.fadeOut(withDuration: 0.8)
        let remove = SKAction.run {
            fade.removeFromParent()
        }
        let sequence = SKAction.sequence([fadeEffect, remove])
        fade.run(sequence)
    }
    
    func spawnCoins() {
        //Spawn a burst of coins
        let spawnSequence = SKAction.run {
            //Number of coins to spawn in a given burst
            let numberOfCoins = self.randomInt(lower: 6, upper: 16)
            
            //Spawn the coin
            let spawn = SKAction.run {
                let coin = Coin()
                coin.position = CGPoint(x: self.currentPoint, y: -(self.size.height / 2) - 300)
                coin.physicsBody?.velocity = CGVector(dx: 0, dy: self.currentSceneVelocity.dy)
                self.world.addChild(coin)
            }
            
            //Gap between each individual coin
            let gap = SKAction.wait(forDuration: 0.07, withRange: 0)
            
            self.run(SKAction.repeat(SKAction.sequence([spawn, gap]), count: numberOfCoins), withKey: "spawnCoins")
            print("coins spawned")
        }
        
        //Wait between burst of coins
        let wait = SKAction.wait(forDuration: 4, withRange: 4)
        
        let sequence = SKAction.sequence([wait, spawnSequence])
        self.run(SKAction.repeatForever(sequence))
    }

    //Generates a random integer within a given range
    func randomInt(lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    //Generates a random float in a given range
    func randomInRange(lo: CGFloat, hi : CGFloat) -> CGFloat {
        return lo + CGFloat(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    //Generates a random integer from 0 to the length of the parameter array
    //with probabilities of each corresponding integer to its value in the array
    func randomNumber(probabilities: [Double]) -> Int {
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = Double.random(in: 0.0 ..< sum)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }
    
    func playSound(name: SKAction) {
        if soundEnabled {
            self.removeAction(forKey: "playSound")
            run(name, withKey: "playSound")
        }
    }
    
    func resetButtonToDefault(button: Button, height: CGFloat) {
        button.texture = button.defaultTexture
        button.size.height = height
        button.isTouched = false
        
        //Check if on iPad or larger screen and reset buttons to correct size for those screens
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            if button.isUnlocked != nil  {
                if button.isUnlocked! {
                    if button.isActive {
                        button.texture = button.activatedTexture
                        button.size.height = 49
                    }
                } else {
                    button.texture = button.defaultLockedTexture
                    button.size.height = 52
                }
            } else {
                if button.name == "music_toggle" {
                    if !musicEnabled {
                        button.texture = button.activatedTexture
                        button.size.height = 78
                    } else {
                        button.texture = button.defaultTexture
                        button.size.height = 81
                    }
                } else if button.name == "sound_toggle" {
                    if !soundEnabled {
                        button.texture = button.activatedTexture
                        button.size.height = 78
                    } else {
                        button.texture = button.defaultTexture
                        button.size.height = 81
                    }
                } else if button.name == "vibration_toggle" {
                    if !vibrationEnabled {
                        button.texture = button.activatedTexture
                        button.size.height = 78
                    } else {
                        button.texture = button.defaultTexture
                        button.size.height = 81
                    }
                } else if button.name == "$0.99_coin_button" ||
                    button.name == "$4.99_coin_button" ||
                    button.name == "$8.99_coin_button" ||
                    button.name == "$14.99_coin_button" ||
                    button.name == "$34.99_coin_button" ||
                    button.name == "$59.99_coin_button" {
                    button.texture = button.defaultTexture
                    button.size.height = 52
                } else if button.name == "acceptAdButton" {
                    button.size.height = 54
                } else if button.name == "cancelAdButton" {
                    button.size.height = 26
                } else if button.isActive {
                    button.texture = button.activatedTexture
                    button.size.height = 78
                } else {
                    button.texture = button.defaultTexture
                    button.size.height = 81
                }
            }
        }
        //Else, reset buttons to the correct size on normal screens
        else {
            if button.isUnlocked != nil  {
                if button.isUnlocked! {
                    if button.isActive {
                        button.texture = button.activatedTexture
                        button.size.height = 49
                    }
                } else {
                    button.texture = button.defaultLockedTexture
                    button.size.height = 52
                }
            } else {
                if button.name == "music_toggle" {
                    if !musicEnabled {
                        button.texture = button.activatedTexture
                    } else {
                        button.texture = button.defaultTexture
                    }
                } else if button.name == "sound_toggle" {
                    if !soundEnabled {
                        button.texture = button.activatedTexture
                    } else {
                        button.texture = button.defaultTexture
                    }
                } else if button.name == "vibration_toggle" {
                    if !vibrationEnabled {
                        button.texture = button.activatedTexture
                    } else {
                        button.texture = button.defaultTexture
                    }
                } else if button.name == "cancelAdButton" {
                    button.size.height = 26
                } else if button.isActive {
                    button.texture = button.activatedTexture
                    button.size.height = 52
                } else {
                    button.texture = button.defaultTexture
                    button.size.height = 54
                }
            }
        }
        
    }
    
    func resetAllButtons() {
        resetButtonToDefault(button: musicToggle, height: 54)
        resetButtonToDefault(button: soundToggle, height: 54)
        resetButtonToDefault(button: vibrationToggle, height: 54)
        
        resetButtonToDefault(button: shopButton, height: 54)
        resetButtonToDefault(button: rankingsButton, height: 54)
        resetButtonToDefault(button: settingsButton, height: 54)
        resetButtonToDefault(button: shopBack, height: 54)
        resetButtonToDefault(button: settingsBack, height: 54)
        
        resetButtonToDefault(button: skisSelectButton, height: 54)
        resetButtonToDefault(button: snowtubeSelectButton, height: 54)
        resetButtonToDefault(button: snowboardSelectButton, height: 54)
        resetButtonToDefault(button: tobogganSelectButton, height: 54)
        resetButtonToDefault(button: snowmobileSelectButton, height: 54)
        resetButtonToDefault(button: hoverboardSelectButton, height: 54)
        
        resetButtonToDefault(button: purchase7500CoinsButton, height: 48)
        resetButtonToDefault(button: purchase45KCoinsButton, height: 48)
        resetButtonToDefault(button: purchase90KCoinsButton, height: 48)
        resetButtonToDefault(button: purchase180KCoinsButton, height: 48)
        resetButtonToDefault(button: purchase500KCoinsButton, height: 48)
        resetButtonToDefault(button: purchase1_2MCoinsButton, height: 48)
        
        resetButtonToDefault(button: acceptAdButton, height: 54)
        resetButtonToDefault(button: cancelAdButton, height: 26)
        
        resetButtonToDefault(button: nextButton, height: 54)
    }
    
    func presentSpinner() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        spinnerAlert.view.addSubview(loadingIndicator)
        
        //Display the alert
        view?.window?.rootViewController?.present(spinnerAlert, animated: true, completion: nil)
    }
    
    func dismissSpinner() {
        view?.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func dismissSpinnerOnFailedPurchase() {
        view?.window?.rootViewController?.dismiss(animated: false, completion: displayErrorMakingPurchaseAlert)
    }
    
    func pauseScene() {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        currentSceneVelocity.dy = 0
        self.physicsWorld.speed = 0
        self.removeAllActions()
        player.removeAllActions()
    }
    
    //Returns the adjusted width of the scene after it is stretched for different screen sizes
    func getAdjustedSceneWidth() -> CGFloat {
        let newSceneWidth = (self.size.width * UIScreen.main.bounds.size.height) / self.size.height
        let sceneWidthDifference = (newSceneWidth - UIScreen.main.bounds.size.width)/2
        let diffPercentageWidth = sceneWidthDifference / (newSceneWidth)
        
        let adjustedSceneWidth = self.size.width - (diffPercentageWidth * 2 * self.size.width)
        
        return adjustedSceneWidth
    }
    
    func displayPurchaseRideAlert(ride: String, coins: Int) {
        //Set up the title and message
        let alertTitle = "Unlock " + ride.capitalized + "?"
        let alertMessage = "Are you sure you want to unlock the " + ride.capitalized + " for " + String(coins) + " coins?"

        //Create the alert
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        //Add the cancel action to the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            print("cancel purchase")
        })
        
        //Add the purchase action to the alert
        alert.addAction(UIAlertAction(title: "Unlock", style: .default) {
            UIAlertAction in
            print("confirm purchase")
            
            //Update the amount of coins left after purchase
            self.totalCoins = self.totalCoins - coins
            UserDefaults.standard.set(self.totalCoins, forKey: "totalCoins")
            self.updateCoinsLabel()
            
            //Unlock the ride and update the select button
            switch ride {
            case "snowtube":
                self.snowtubeSelectButton.isUnlocked = true
                self.player.snowtubeUnlocked = true
                
                self.snowtubeSelectButton.texture = self.snowtubeSelectButton.defaultTexture
                self.snowtubeSelectButton.size.height = 52
            case "snowboard":
                self.snowboardSelectButton.isUnlocked = true
                self.player.snowboardUnlocked = true
                
                self.snowboardSelectButton.texture = self.snowboardSelectButton.defaultTexture
                self.snowboardSelectButton.size.height = 52
            case "toboggan":
                self.tobogganSelectButton.isUnlocked = true
                self.player.tobogganUnlocked = true
                
                self.tobogganSelectButton.texture = self.tobogganSelectButton.defaultTexture
                self.tobogganSelectButton.size.height = 52
            case "snowmobile":
                self.snowmobileSelectButton.isUnlocked = true
                self.player.snowmobileUnlocked = true
                
                self.snowmobileSelectButton.texture = self.snowmobileSelectButton.defaultTexture
                self.snowmobileSelectButton.size.height = 52
            case "hoverboard":
                self.hoverboardSelectButton.isUnlocked = true
                self.player.hoverboardUnlocked = true
                
                self.hoverboardSelectButton.texture = self.hoverboardSelectButton.defaultTexture
                self.hoverboardSelectButton.size.height = 52
            default:
                print("something went wrong with confirming the purchase")
            }
            
            //Save the status of unlocked rides
            self.saveUnlockedRides()
        })
        
        //Display the alert
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func shouldDisplayTutorial() {
        if !tutorialDisplayed {
            displayTutorial()
            
            //Save setting that tutorial has been displayed
            tutorialDisplayed = true
            UserDefaults.standard.set(tutorialDisplayed, forKey: "tutorialDisplayed")
        }
    }
    
    func shouldDisplayAd() {
        //Determine whether to play a rewarded ad
        let rand = randomInRange(lo: 0, hi: 12)
        if rand == 0 && timesPlayedCounter != 0 {
            displayRewardedAdPrompt()
        }
        
        //Determine whether to display an interstitial ad
        if timesPlayedCounter % 4 == 0 && !rewardedAdPromptIsDisplayed() && timesPlayedCounter != 0 {
            //Stop music and sound in preparation for displaying an ad
            self.music.run(SKAction.stop())
            self.wind.run(SKAction.stop())
            
            NotificationCenter.default.post(name: .InterstitialNotification, object: nil)
        }
        print(timesPlayedCounter)
    }
    
    func displayRewardedAdPrompt() {
        died = true
        //pauseScene()
        
        //Configure background
        let promptBg = SKSpriteNode(imageNamed: "rewarded_ad_prompt_bg")
        promptBg.size = CGSize(width: 262, height: 227)
        promptBg.position = CGPoint(x: getAdjustedSceneWidth()/2 + promptBg.size.width/2, y: 0)
        promptBg.name = "promptBg"
        cam.addChild(promptBg)
        
        //Configure accept ad button
        acceptAdButton.size = CGSize(width: 144, height: 54)
        acceptAdButton.position = CGPoint(x: getAdjustedSceneWidth()/2 + acceptAdButton.size.width/2, y: -self.size.height/2 + 270)
        acceptAdButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        cam.addChild(acceptAdButton)
        
        //Configure cancel ad button
        cancelAdButton.size = CGSize(width: 24, height: 26)
        cancelAdButton.position = CGPoint(x: getAdjustedSceneWidth()/2 + cancelAdButton.size.width/2, y: 83)
        cancelAdButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        cancelAdButton.name = "cancelAdButton"
        cam.addChild(cancelAdButton)
        
        //Animate the prompt
        let wait = SKAction.wait(forDuration: 0.5)
        let move = SKAction.moveTo(x: 0, duration: 0.2)
        let moveCancelButton = SKAction.moveTo(x: 114, duration: 0.2)
        let sequence = SKAction.sequence([wait, move])
        let cancelSequence = SKAction.sequence([wait, moveCancelButton])
        promptBg.run(sequence)
        acceptAdButton.run(sequence)
        cancelAdButton.run(cancelSequence)
    }
    
    func removeRewardedAdPrompt() {
        resetAllButtons()
        cam.childNode(withName: "promptBg")?.removeFromParent()
        acceptAdButton.removeFromParent()
        cancelAdButton.removeFromParent()
    }
    
    func displayRewardedAd() {
        print("display rewarded ad")
        
        //Stop music and sound in preparation for displaying an ad
        self.music.run(SKAction.stop())
        self.wind.run(SKAction.stop())
        
        //Post a notification to display a rewarded ad
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RewardedAdNotification"), object: nil)
    }
    
    func rewardedAdPromptIsDisplayed() -> Bool {
        if let _ = cam.childNode(withName:"promptBg"){
          return true
        } else {
            return false
        }
    }
    
    func tutorialIsDisplayed() -> Bool {
        if let _ = cam.childNode(withName:"tutorial_bg"){
          return true
        } else {
            return false
        }
    }
    
    func displayInsufficientCoinsAlert() {
        let alert = UIAlertController(title: "Not Enough Coins!", message: "Collect more coins or purchase a coin pack from the Ski Shop to unlock this ride!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            print("cancel purchase")
        })
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func displayErrorMakingPurchaseAlert() {
        let alert = UIAlertController(title: "Something went wrong.", message: "There was an error communicating with the store. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            print("store error")
        })
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func displaySpinner() {
        let activityInd = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityInd.style = .large
        } else {
            // Fallback on earlier versions
            activityInd.style = .whiteLarge
        }
        activityInd.center = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY)
        activityInd.startAnimating()
        scene!.view?.addSubview(activityInd)
    }
    
    func generateAmbientSnow() {
        let willGenerateSnow = randomNumber(probabilities: [0.9, 0.1])
        
        if willGenerateSnow == 1 {
            if let ambientSnow = SKEmitterNode(fileNamed: "ambient_snow") {
                ambientSnow.position = CGPoint(x: self.getAdjustedSceneWidth() / 2, y: self.size.height/2)
                ambientSnow.particlePositionRange.dx = self.getAdjustedSceneWidth() * 2
                ambientSnow.zPosition = CGFloat(Int.max)
                world.addChild(ambientSnow)
            }
        }
    }
    
    func getScreenResolution() -> Int {
        // Access in the current screen width and height
        let screenWidth = UIScreen.main.bounds.width
        
        // Request an UITraitCollection instance
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // Check the idiom to find out the current device type
        switch (deviceIdiom) {
        // Display myLabel with the appropriate font size for the device width.
        case .phone:
            switch screenWidth {
            case 0...320:
                //iPhone 5
                return 2
            default:
                //iPhone 6 or later
                return 3
            }
        case .pad:
            // iPad 2, Air, Retina and Mini etc Portrait
            return 1
        default:
            return 3
        }
    }
    
    //Function for removing menus with a fade out transition
    func fadeAndRemove(node: SKNode) {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
        let remove        = SKAction.run({ node.removeFromParent }())
        let sequence      = SKAction.sequence([fadeOutAction, remove])
        node.run(sequence)
    }
    
    @objc func disburseAdReward(_ notification: Notification) {
        totalCoins = totalCoins + 1000
        UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
        updateCoinsLabel()
    }
    
    @objc func rewardedAdDismissed(_ notification: Notification) {
        if musicEnabled {
            music.run(SKAction.play())
        }
        
        if soundEnabled {
            wind.run(SKAction.play())
        }
    }
}
