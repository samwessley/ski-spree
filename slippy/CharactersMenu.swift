//
//  CharactersMenu.swift
//  slippy
//
//  Created by Sam Wessley on 5/14/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftySKScrollView

extension GameScene {
    
    func createShopMenu() {        
        removeScoreAndCoinsLabels()
        
        //Create translucent background
        let bg = SKSpriteNode()
        bg.name = "overlay_menu"
        bg.color = SKColor(red:0.1, green:0.24, blue:0.36, alpha:0.75)
        bg.size = self.size
        bg.position = .zero
        
        //Configure scroll view background
        let backgroundScrollView = SKSpriteNode(color: UIColor(red:0.13, green:0.35, blue:0.53, alpha:1.0), size: CGSize(width: 320, height: 410))
        backgroundScrollView.position = CGPoint(x: 0, y: self.size.height/2 - 180)
        backgroundScrollView.anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundScrollView.name = "scrollViewBorder"
        bg.addChild(backgroundScrollView)
        
        //Configure scroll view bottom background
        let backgroundBottom = SKSpriteNode(texture: SKTexture(imageNamed: "bg_bottom"), color: .clear, size: CGSize(width: 320, height: 24))
        backgroundBottom.position = CGPoint(x: 0, y: -202)
        backgroundBottom.name = "scrollViewBorder"
        bg.addChild(backgroundBottom)
        
        //Create scroll view
        let square = SKCropNode()
        square.maskNode = SKSpriteNode(texture: nil, color: .blue, size: CGSize(width: 320, height: 410))
        square.position = CGPoint(x: 0, y: 15)
        moveableNode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 320, height: 2014))
        moveableNode.anchorPoint = CGPoint(x: 0.5, y: 1)
        moveableNode.position = CGPoint(x: 0, y: 250)
        square.addChild(moveableNode)
        bg.addChild(square)
        
        //Add elements to scroll view
        setupRidesPage()
        setupCoinsPage()
        
        //Configure ski shop sign
        let skishopsign = SKSpriteNode(imageNamed: "skishop")
        skishopsign.size = CGSize(width: 320, height: 78)
        skishopsign.position = CGPoint(x: 0, y: self.size.height/2 - 141)
        bg.addChild(skishopsign)
        
        //Create coins label
        coinsLabelBg.removeFromParent()
        bg.addChild(coinsLabelBg)
        
        //Create back button
        shopBack.name = "back_button"
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            shopBack.size = CGSize(width: 90, height: 81)
        } else {
            shopBack.size = CGSize(width: 60, height: 54)
        }

        shopBack.anchorPoint = CGPoint(x: 0, y: 0)
        shopBack.position = CGPoint(x: -getAdjustedSceneWidth()/2 + 20, y: -self.size.height/2 + 120)
        bg.addChild(shopBack)

        cam.addChild(bg)
    }
    
    private func setupRidesPage() {
        //player.currentRide = UserDefaults.standard.string(forKey: "playerCurrentRide") ?? "skis"
        print(player.currentRide)
        
        //Configure page
        let ridesSection = SKSpriteNode(color: .clear, size: CGSize(width: 320, height: 1334))
        ridesSection.anchorPoint = CGPoint(x: 0.5, y: 1)
        ridesSection.position = CGPoint(x: 0, y: -20)
        moveableNode.addChild(ridesSection)
    
        //Add elements to page
        setupSkiSection(parent: ridesSection)
        setupSnowtubeSection(parent: ridesSection)
        setupSnowboardSection(parent: ridesSection)
        setupTobogganSection(parent: ridesSection)
        setupSnowmobileSection(parent: ridesSection)
        setupHoverboardSection(parent: ridesSection)
    }
    
    private func setupCoinsPage() {
        //Configure page
        let page3ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: 320, height: 584))
        page3ScrollView.position = CGPoint(x: 0, y: -1374)
        page3ScrollView.anchorPoint = CGPoint(x: 0.5, y: 1)
        moveableNode.addChild(page3ScrollView)
        
        //Add elements to page
        let page3Banner = SKSpriteNode(color: SKColor(red:0.08, green:0.25, blue:0.39, alpha:1.0), size: CGSize(width: 320, height: 30))
        page3Banner.position = CGPoint(x: 0, y: 0)
        page3Banner.anchorPoint = CGPoint(x: 0.5, y: 1)
        let page3BannerText = SKLabelNode(text: "Coins")
        page3BannerText.fontName = "Quick"
        page3BannerText.fontSize = 20
        page3BannerText.position = CGPoint(x: 0, y: -6)
        page3BannerText.verticalAlignmentMode = .top
        let page3BannerTextShadow = SKLabelNode(text: "Coins")
        page3BannerTextShadow.fontName = "Quick"
        page3BannerTextShadow.fontSize = 20
        page3BannerTextShadow.fontColor = UIColor(red:0.18, green:0.19, blue:0.21, alpha:1.0)
        page3BannerTextShadow.position = CGPoint(x: 0, y: -9)
        page3BannerTextShadow.verticalAlignmentMode = .top
        page3Banner.addChild(page3BannerTextShadow)
        page3Banner.addChild(page3BannerText)
        page3ScrollView.addChild(page3Banner)
        
        let coinButton1 = SKSpriteNode(imageNamed: "7.5k_coins_button")
        coinButton1.position = CGPoint(x: -77, y: -40)
        coinButton1.anchorPoint = CGPoint(x: 0.5, y: 1)
        coinButton1.size = CGSize(width: 145, height: 188)
        purchase7500CoinsButton.name = "$0.99_coin_button"
        purchase7500CoinsButton.position = CGPoint(x: 0, y: -coinButton1.size.height + 9)
        purchase7500CoinsButton.size = CGSize(width: 127, height: 48)
        purchase7500CoinsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        coinButton1.addChild(purchase7500CoinsButton)
        page3ScrollView.addChild(coinButton1)
        
        let coinButton2 = SKSpriteNode(imageNamed: "45k_coins_button")
        coinButton2.position = CGPoint(x: 77, y: -40)
        coinButton2.anchorPoint = CGPoint(x: 0.5, y: 1)
        coinButton2.size = CGSize(width: 145, height: 188)
        purchase45KCoinsButton.name = "$4.99_coin_button"
        purchase45KCoinsButton.position = CGPoint(x: 0, y: -coinButton2.size.height + 9)
        purchase45KCoinsButton.size = CGSize(width: 127, height: 48)
        purchase45KCoinsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        coinButton2.addChild(purchase45KCoinsButton)
        page3ScrollView.addChild(coinButton2)
        
        let coinButton3 = SKSpriteNode(imageNamed: "90k_coins_button")
        coinButton3.position = CGPoint(x: -77, y: -238)
        coinButton3.anchorPoint = CGPoint(x: 0.5, y: 1)
        coinButton3.size = CGSize(width: 145, height: 188)
        purchase90KCoinsButton.name = "$8.99_coin_button"
        purchase90KCoinsButton.position = CGPoint(x: 0, y: -coinButton3.size.height + 9)
        purchase90KCoinsButton.size = CGSize(width: 127, height: 48)
        purchase90KCoinsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        coinButton3.addChild(purchase90KCoinsButton)
        page3ScrollView.addChild(coinButton3)
        
        let coinButton4 = SKSpriteNode(imageNamed: "180k_coins_button")
        coinButton4.position = CGPoint(x: 77, y: -238)
        coinButton4.anchorPoint = CGPoint(x: 0.5, y: 1)
        coinButton4.size = CGSize(width: 145, height: 188)
        purchase180KCoinsButton.name = "$14.99_coin_button"
        purchase180KCoinsButton.position = CGPoint(x: 0, y: -coinButton4.size.height + 9)
        purchase180KCoinsButton.size = CGSize(width: 127, height: 48)
        purchase180KCoinsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        coinButton4.addChild(purchase180KCoinsButton)
        page3ScrollView.addChild(coinButton4)
        
        let coinButton5 = SKSpriteNode(imageNamed: "500k_coins_button")
        coinButton5.position = CGPoint(x: -77, y: -436)
        coinButton5.anchorPoint = CGPoint(x: 0.5, y: 1)
        coinButton5.size = CGSize(width: 145, height: 188)
        purchase500KCoinsButton.name = "$34.99_coin_button"
        purchase500KCoinsButton.position = CGPoint(x: 0, y: -coinButton5.size.height + 9)
        purchase500KCoinsButton.size = CGSize(width: 127, height: 48)
        purchase500KCoinsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        coinButton5.addChild(purchase500KCoinsButton)
        page3ScrollView.addChild(coinButton5)
        
        let coinButton6 = SKSpriteNode(imageNamed: "1.2m_coins_button")
        coinButton6.position = CGPoint(x: 77, y: -436)
        coinButton6.anchorPoint = CGPoint(x: 0.5, y: 1)
        coinButton6.size = CGSize(width: 145, height: 188)
        purchase1_2MCoinsButton.name = "$59.99_coin_button"
        purchase1_2MCoinsButton.position = CGPoint(x: 0, y: -coinButton6.size.height + 9)
        purchase1_2MCoinsButton.size = CGSize(width: 127, height: 48)
        purchase1_2MCoinsButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        coinButton6.addChild(purchase1_2MCoinsButton)
        page3ScrollView.addChild(coinButton6)
    }
    
    private func createCoinsLabel(parent: SKSpriteNode) {
        let coinIconTexture = SKTexture(imageNamed: "coin_border")
        let coinIcon = SKSpriteNode(texture: coinIconTexture, color: .clear, size: CGSize(width: 20, height: 19))
        coinIcon.anchorPoint = CGPoint(x: 1, y: 0)
        coinIcon.position = CGPoint(x: coinIcon.size.width - 0.5, y: -1.5)
        
        //Configure coins label
        let coinsLabel = SKLabelNode()
        coinsLabel.fontName = "8BIT WONDER Nominal"
        coinsLabel.text = (String)(totalCoins)
        coinsLabel.fontSize = 30
        coinsLabel.fontColor = UIColor(red:1.00, green:0.85, blue:0.00, alpha:1.0)
        coinsLabel.position = CGPoint(x: getAdjustedSceneWidth()/2 - 60, y: self.size.height/2 - coinsLabel.frame.size.height/2 - 80)
        coinsLabel.horizontalAlignmentMode = .right
        
        //Configure shadow
        coinsLabelShadow.attributedText = NSAttributedString(string: (String)(totalCoins), attributes: coinsLabelShadowAttributes)
        coinsLabelShadow.position = CGPoint(x: getAdjustedSceneWidth()/2 - 42, y: self.size.height/2 - coinsLabel.frame.size.height - 84)
        coinsLabelShadow.horizontalAlignmentMode = .right
        
        //Add labels
        parent.addChild(coinsLabelShadow)
        parent.addChild(coinsLabel)
        coinsLabel.addChild(coinIcon)
    }
    
    private func setupSkiSection(parent: SKSpriteNode) {
        let skiButton = SKSpriteNode(imageNamed: "skis_store_button")
        skiButton.position = CGPoint(x: 0, y: -40)
        skiButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        skiButton.size = CGSize(width: 300, height: 209)
        skisSelectButton.isUnlocked = player.skisUnlocked
        
        if skisSelectButton.isUnlocked! {
            if player.currentRide == "skis" {
                skisSelectButton.isActive = true
                skisSelectButton.texture = skisSelectButton.activatedTexture
                skisSelectButton.size = CGSize(width: 280, height: 49)
            } else {
                skisSelectButton.isActive = false
                skisSelectButton.texture = skisSelectButton.defaultTexture
                skisSelectButton.size = CGSize(width: 280, height: 52)
            }
        } else {
            skisSelectButton.texture = skisSelectButton.defaultLockedTexture
            skisSelectButton.size = CGSize(width: 280, height: 52)
        }
        
        skisSelectButton.position = CGPoint(x: 0, y: -skiButton.size.height + 10)
        skisSelectButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        skiButton.addChild(skisSelectButton)
        parent.addChild(skiButton)
    }
    
    private func setupSnowtubeSection(parent: SKSpriteNode) {
        let snowtubeButton = SKSpriteNode(imageNamed: "snowtube_store_button")
        snowtubeButton.position = CGPoint(x: 0, y: -259)
        snowtubeButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        snowtubeButton.size = CGSize(width: 300, height: 209)
        snowtubeSelectButton.isUnlocked = player.snowtubeUnlocked
        
        if snowtubeSelectButton.isUnlocked! {
            if player.currentRide == "snowtube" {
                snowtubeSelectButton.isActive = true
                snowtubeSelectButton.texture = snowtubeSelectButton.activatedTexture
                snowtubeSelectButton.size = CGSize(width: 280, height: 49)
            } else {
                snowtubeSelectButton.isActive = false
                snowtubeSelectButton.texture = snowtubeSelectButton.defaultTexture
                snowtubeSelectButton.size = CGSize(width: 280, height: 52)
            }
        } else {
            snowtubeSelectButton.texture = snowtubeSelectButton.defaultLockedTexture
            snowtubeSelectButton.size = CGSize(width: 280, height: 52)
        }
        
        snowtubeSelectButton.position = CGPoint(x: 0, y: -snowtubeButton.size.height + 10)
        snowtubeSelectButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        snowtubeButton.addChild(snowtubeSelectButton)
        parent.addChild(snowtubeButton)
    }
    
    private func setupSnowboardSection(parent: SKSpriteNode) {
        let snowboardButton = SKSpriteNode(imageNamed: "snowboard_store_button")
        snowboardButton.position = CGPoint(x: 0, y: -478)        
        snowboardButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        snowboardButton.size = CGSize(width: 300, height: 209)
        snowboardSelectButton.isUnlocked = player.snowboardUnlocked
        
        if snowboardSelectButton.isUnlocked! {
            if player.currentRide == "snowboard" {
                snowboardSelectButton.isActive = true
                snowboardSelectButton.texture = snowboardSelectButton.activatedTexture
                snowboardSelectButton.size = CGSize(width: 280, height: 49)
            } else {
                snowboardSelectButton.isActive = false
                snowboardSelectButton.texture = snowboardSelectButton.defaultTexture
                snowboardSelectButton.size = CGSize(width: 280, height: 52)
            }
        } else {
            snowboardSelectButton.texture = snowboardSelectButton.defaultLockedTexture
            snowboardSelectButton.size = CGSize(width: 280, height: 52)
        }
        
        snowboardSelectButton.position = CGPoint(x: 0, y: -snowboardButton.size.height + 10)
        snowboardSelectButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        snowboardButton.addChild(snowboardSelectButton)
        parent.addChild(snowboardButton)
    }
    
    private func setupTobogganSection(parent: SKSpriteNode) {
        let tobogganButton = SKSpriteNode(imageNamed: "toboggan_store_button")
        tobogganButton.position = CGPoint(x: 0, y: -697)
        tobogganButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        tobogganButton.size = CGSize(width: 300, height: 209)
        tobogganSelectButton.isUnlocked = player.tobogganUnlocked
        
        if tobogganSelectButton.isUnlocked! {
            if player.currentRide == "toboggan" {
                tobogganSelectButton.isActive = true
                tobogganSelectButton.texture = tobogganSelectButton.activatedTexture
                tobogganSelectButton.size = CGSize(width: 280, height: 49)
            } else {
                tobogganSelectButton.isActive = false
                tobogganSelectButton.texture = tobogganSelectButton.defaultTexture
                tobogganSelectButton.size = CGSize(width: 280, height: 52)
            }
        } else {
            tobogganSelectButton.texture = tobogganSelectButton.defaultLockedTexture
            tobogganSelectButton.size = CGSize(width: 280, height: 52)
        }
        
        tobogganSelectButton.position = CGPoint(x: 0, y: -tobogganButton.size.height + 10)
        tobogganSelectButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        tobogganButton.addChild(tobogganSelectButton)
        parent.addChild(tobogganButton)
    }
    
    private func setupSnowmobileSection(parent: SKSpriteNode) {
        let snowmobileButton = SKSpriteNode(imageNamed: "snowmobile_store_button")
        snowmobileButton.position = CGPoint(x: 0, y: -916)
        snowmobileButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        snowmobileButton.size = CGSize(width: 300, height: 209)
        snowmobileSelectButton.isUnlocked = player.snowmobileUnlocked
        
        if snowmobileSelectButton.isUnlocked! {
            if player.currentRide == "snowmobile" {
                snowmobileSelectButton.isActive = true
                snowmobileSelectButton.texture = snowmobileSelectButton.activatedTexture
                snowmobileSelectButton.size = CGSize(width: 280, height: 49)
            } else {
                snowmobileSelectButton.isActive = false
                snowmobileSelectButton.texture = snowmobileSelectButton.defaultTexture
                snowmobileSelectButton.size = CGSize(width: 280, height: 52)
            }
        } else {
            snowmobileSelectButton.texture = snowmobileSelectButton.defaultLockedTexture
            snowmobileSelectButton.size = CGSize(width: 280, height: 52)
        }
        
        snowmobileSelectButton.position = CGPoint(x: 0, y: -snowmobileButton.size.height + 10)
        snowmobileSelectButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        snowmobileButton.addChild(snowmobileSelectButton)
        parent.addChild(snowmobileButton)
    }
    
    private func setupHoverboardSection(parent: SKSpriteNode) {
        let hoverboardButton = SKSpriteNode(imageNamed: "hoverboard_store_button")
        hoverboardButton.position = CGPoint(x: 0, y: -1135)
        hoverboardButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        hoverboardButton.size = CGSize(width: 300, height: 209)
        hoverboardSelectButton.isUnlocked = player.hoverboardUnlocked
        
        if hoverboardSelectButton.isUnlocked! {
            if player.currentRide == "hoverboard" {
                hoverboardSelectButton.isActive = true
                hoverboardSelectButton.texture = hoverboardSelectButton.activatedTexture
                hoverboardSelectButton.size = CGSize(width: 280, height: 49)
            } else {
                hoverboardSelectButton.isActive = false
                hoverboardSelectButton.texture = hoverboardSelectButton.defaultTexture
                hoverboardSelectButton.size = CGSize(width: 280, height: 52)
            }
        } else {
            hoverboardSelectButton.texture = hoverboardSelectButton.defaultLockedTexture
            hoverboardSelectButton.size = CGSize(width: 280, height: 52)
        }
        
        hoverboardSelectButton.position = CGPoint(x: 0, y: -hoverboardButton.size.height + 10)
        hoverboardSelectButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        hoverboardButton.addChild(hoverboardSelectButton)
        parent.addChild(hoverboardButton)
    }
}
