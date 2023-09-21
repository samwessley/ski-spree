//
//  SettingsMenu.swift
//  slippy
//
//  Created by Sam Wessley on 5/14/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func createSettingsMenu() {
        removeScoreAndCoinsLabels()
        
        //Create translucent background
        let bg = SKSpriteNode()
        bg.name = "overlay_menu"
        bg.color = SKColor(red:0.1, green:0.24, blue:0.36, alpha:0.75)
        bg.size = self.size
        bg.position = .zero
        
        //Create music toggle button
        musicToggle.name = "music_toggle"
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            musicToggle.size = CGSize(width: 90, height: 81)
            //Adjust the positioning of the Toggle's labels
            musicToggle.children[1].position.x = -musicToggle.size.width - 20
            musicToggle.childNode(withName: "line")?.position.x = -musicToggle.size.width - 20
        } else {
            musicToggle.size = CGSize(width: 60, height: 54)
        }
        
        musicToggle.position = CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120)
        musicToggle.anchorPoint = CGPoint(x: 1, y: 0)
    
        if musicEnabled {
            musicToggle.run(SKAction.setTexture(musicToggle.defaultTexture))
            musicToggle.size.height = 54
        } else {
            musicToggle.run(SKAction.setTexture(musicToggle.activatedTexture!))
            musicToggle.size.height = 52
        }
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
           musicToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 400), duration: 0.1))
        } else {
            musicToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 342), duration: 0.1))
        }
        
        bg.addChild(musicToggle)
        
        //Create sound toggle button
        soundToggle.name = "sound_toggle"
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            soundToggle.size = CGSize(width: 90, height: 81)
            //Adjust the positioning of the Toggle's labels
            soundToggle.children[1].position.x = -soundToggle.size.width - 20
            soundToggle.childNode(withName: "line")?.position.x = -soundToggle.size.width - 20
        } else {
            soundToggle.size = CGSize(width: 60, height: 54)
        }
        
        soundToggle.position = CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120)
        soundToggle.anchorPoint = CGPoint(x: 1, y: 0)
        bg.addChild(soundToggle)
        
        if soundEnabled {
            soundToggle.run(SKAction.setTexture(soundToggle.defaultTexture))
            soundToggle.size.height = 54
        } else {
            soundToggle.run(SKAction.setTexture(soundToggle.activatedTexture!))
            soundToggle.size.height = 52
        }
    
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            soundToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 307), duration: 0.1))
        } else {
            soundToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 268), duration: 0.1))
        }
        
        //Create vibration toggle button
        vibrationToggle.name = "vibration_toggle"
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            vibrationToggle.size = CGSize(width: 90, height: 81)
            //Adjust the positioning of the Toggle's labels
            vibrationToggle.children[1].position.x = -vibrationToggle.size.width - 20
            vibrationToggle.childNode(withName: "line")?.position.x = -vibrationToggle.size.width - 20
        } else {
            vibrationToggle.size = CGSize(width: 60, height: 54)
        }
        
        vibrationToggle.anchorPoint = CGPoint(x: 1, y: 0)
        vibrationToggle.position = CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120)
        
        bg.addChild(vibrationToggle)
        
        if vibrationEnabled {
            vibrationToggle.run(SKAction.setTexture(vibrationToggle.defaultTexture))
            vibrationToggle.size.height = 54
        } else {
            vibrationToggle.run(SKAction.setTexture(vibrationToggle.activatedTexture!))
            vibrationToggle.size.height = 52
        }
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            vibrationToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 214), duration: 0.1))
        } else {
            vibrationToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 194), duration: 0.1))
        }
        
        //Create back button
        settingsBack.name = "down_button"
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            settingsBack.size = CGSize(width: 90, height: 81)
        } else {
            settingsBack.size = CGSize(width: 60, height: 54)
        }
    
        settingsBack.anchorPoint = CGPoint(x: 1, y: 0)
        settingsBack.position = CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120)
        bg.addChild(settingsBack)
        
        //Add the settings menu to the scene
        cam.addChild(bg)
    }
}
