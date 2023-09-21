//
//  GameOverElements.swift
//  slippy
//
//  Created by Sam Wessley on 5/4/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit
import GameplayKit

//Contains all the functions for building the menu that appears when the player dies
extension GameScene {
    func createGameOverMenu(type: String) {
        removeScoreAndCoinsLabels()
        
        //Spawn the game over menu
        let wait = SKAction.wait(forDuration: 0.2)
        
        if type == "crashed" {
            let runCreateTitleLabel = SKAction.run {
                self.createTitleLabel(type: "crashed")
            }
            let sequence = SKAction.sequence([wait, runCreateTitleLabel, SKAction.run(playWooshSound), wait, SKAction.run(createScoreboard), SKAction.run(createRestartButton), SKAction.run(playWooshSound)])
            self.run(sequence)
        } else {
            let runCreateTitleLabel = SKAction.run {
                self.createTitleLabel(type: "missed")
            }
            let sequence = SKAction.sequence([wait, runCreateTitleLabel, SKAction.run(playWooshSound), wait, SKAction.run(createScoreboard), SKAction.run(createRestartButton), SKAction.run(playWooshSound)])
            self.run(sequence)
        }
    }
    
    private func createTitleLabel(type: String) {
        var crashedTexture = SKTexture(imageNamed: "crashed")
        var crashed = SKSpriteNode(texture: crashedTexture)
        
        //If the player failed because they crashed, add the "crashed" label
        if type == "crashed" {
            crashedTexture = SKTexture(imageNamed: "crashed")
            crashed = SKSpriteNode(texture: crashedTexture)
            crashed.size = CGSize(width: 262, height: 52)
            crashed.position = CGPoint(x: -UIScreen.main.bounds.size.width/2 - crashed.frame.size.width, y: 175)
        }
        //If the player failed because they missed a goal, add the "missed" label
        if type == "missed" {
            crashedTexture = SKTexture(imageNamed: "missed")
            crashed = SKSpriteNode(texture: crashedTexture)
            crashed.size = CGSize(width: 262, height: 64)
            crashed.position = CGPoint(x: -UIScreen.main.bounds.size.width/2 - crashed.frame.size.width, y: 175)
        }
        
        //Add label to cam and animate it
        cam.addChild(crashed)
        crashed.run(SKAction.move(to: CGPoint(x: 0, y: 175), duration: 0.2))
    }
    
    private func createScoreboard() {
        //Create background element
        let bg = SKSpriteNode(imageNamed: "scoreboard")
        bg.name = "overlay_menu"
        bg.size = CGSize(width: 262, height: 200)
        bg.position = CGPoint(x: getAdjustedSceneWidth()/2 + bg.size.width, y: 0)
        
        //Configure subelements
        let bigScore = createBigScore()
        let bigScoreLabel = createBigScoreLabel()
        let topScore = createTopScore()
        let topScoreLabel = createTopScoreLabel()
        let totalCoins = createTotalCoins()
        let totalCoinsLabel = createTotalCoinsLabel()
        
        //Add subelements to scoreboard
        bg.addChild(bigScore)
        bg.addChild(bigScoreLabel)
        bg.addChild(topScore)
        bg.addChild(topScoreLabel)
        bg.addChild(totalCoins)
        bg.addChild(totalCoinsLabel)
        
        //Add the scoreboard to cam and animate it
        cam.addChild(bg)
        bg.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.2))
        
        //Save the high score
        if score > highScore {
            let highScoreLabel = createHighScoreLabel()
            bg.addChild(highScoreLabel)
            let wait = SKAction.wait(forDuration: 0.2)
            let scaleAction = SKAction.scale(to: 1, duration: 0.2)
            let sequence = SKAction.sequence([wait, scaleAction])
            highScoreLabel.run(sequence)
            
            saveScore(score: score)
            loadUserDetails()
            
            //Notify the view controller that we want to send the score to Game Center
            let userInfo = [ "score" : score]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendScore"), object: nil, userInfo: userInfo)
        }
    }
    
    private func createRestartButton() {
        //Configure restart button
        restartButton.size = CGSize(width: 262, height: 65)
        restartButton.position = CGPoint(x: -getAdjustedSceneWidth()/2 - restartButton.size.width, y: -self.size.height/2 + 210)
        restartButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        //Add button to scene and animate it
        cam.addChild(restartButton)
        restartButton.run(SKAction.move(to: CGPoint(x: 0, y: -self.size.height/2 + 210), duration: 0.2))
    }
    
    private func createBigScoreLabel() -> SKLabelNode {
        //Configure text
        let bigScoreLabel = SKLabelNode()
        bigScoreLabel.fontName = "Quick"
        bigScoreLabel.text = "SCORE"
        bigScoreLabel.fontSize = 36
        bigScoreLabel.setScale(0.5)
        bigScoreLabel.position = CGPoint(x: 0, y: 85)
        bigScoreLabel.horizontalAlignmentMode = .center
        bigScoreLabel.verticalAlignmentMode = .top
        
        return bigScoreLabel
    }
    
    private func createBigScore() -> SKLabelNode {
        //Configure text
        let bigScore = SKLabelNode()
        bigScore.fontName = "Quick"
        bigScore.text = String(score)
        bigScore.fontSize = 192
        bigScore.setScale(0.5)
        bigScore.position = CGPoint(x: 0, y: 55)
        bigScore.horizontalAlignmentMode = .center
        bigScore.verticalAlignmentMode = .top

        return bigScore
    }
    
    private func createTopScoreLabel() -> SKLabelNode {
        let topScoreLabel = SKLabelNode()
        topScoreLabel.fontName = "Quick"
        topScoreLabel.text = "BEST"
        topScoreLabel.fontSize = 28
        topScoreLabel.setScale(0.5)
        topScoreLabel.position = CGPoint(x: -115, y: -45)
        topScoreLabel.horizontalAlignmentMode = .left
        topScoreLabel.verticalAlignmentMode = .top
    
        return topScoreLabel
    }
    
    private func createTopScore() -> SKLabelNode {
        //Configure text
        let topScore = SKLabelNode()
        topScore.fontName = "Quick"
        if score > highScore {
            topScore.text = String(score)
        } else {
            topScore.text = String(highScore)
        }
        topScore.fontSize = 48
        topScore.setScale(0.5)
        topScore.position = CGPoint(x: -115, y: -65)
        topScore.horizontalAlignmentMode = .left
        topScore.verticalAlignmentMode = .top
        
        return topScore
    }
    
    private func createTotalCoinsLabel() -> SKLabelNode {
        //Configure text
        let coinsLabel = SKLabelNode()
        coinsLabel.fontName = "Quick"
        coinsLabel.text = "COINS"
        coinsLabel.fontSize = 28
        coinsLabel.setScale(0.5)
        coinsLabel.position = CGPoint(x: 115, y: -45)
        coinsLabel.horizontalAlignmentMode = .right
        coinsLabel.verticalAlignmentMode = .top

        return coinsLabel
    }
    
    private func createTotalCoins() -> SKLabelNode {
        //Configure text
        let totalCoins = SKLabelNode()
        totalCoins.fontName = "Quick"
        totalCoins.text = String(self.totalCoins)
        totalCoins.fontSize = 48
        totalCoins.setScale(0.5)
        totalCoins.fontColor = .white
        totalCoins.position = CGPoint(x: 115, y: -65)
        totalCoins.horizontalAlignmentMode = .right
        totalCoins.verticalAlignmentMode = .top

        return totalCoins
    }
    
    private func createHighScoreLabel() -> SKSpriteNode {
        let highscoreLabel = SKSpriteNode(imageNamed: "new_high_score")
        highscoreLabel.size = CGSize(width: 100, height: 36)
        highscoreLabel.position = CGPoint(x: -100, y: 80)
        highscoreLabel.zRotation = 0.42
        highscoreLabel.setScale(0)
        
        return highscoreLabel
    }
    
    private func playWooshSound() {
        playSound(name: wooshSound)
    }
}
