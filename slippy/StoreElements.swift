//
//  StoreElements.swift
//  slippy
//
//  Created by Sam Wessley on 8/29/19.
//  Copyright © 2019 Sam Wessley. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func snowtubeSelectButtonIsPressed() {
        if snowtubeSelectButton.isTouched {
            if snowtubeSelectButton.isUnlocked! {
                //If the snowtube is unlocked when touched but not selected, set it to the current ride
                if !snowtubeSelectButton.isActive {
                    player.currentRide = "snowtube"
                    snowtubeSelectButton.isActive = true
                    snowtubeSelectButton.texture = snowtubeSelectButton.activatedTexture
                    snowtubeSelectButton.size.height = 49
                    saveCurrentRide()
                    
                    //Reset all other buttons to unselected
                    deselectOtherRideButtons()
                    
                    //Play button sound
                    playSound(name: buttonCloseSound)
                }
            } else if totalCoins >= 19000 {
                print("purchase snowtube")
                
                //Update the select button
                snowtubeSelectButton.texture = snowtubeSelectButton.defaultLockedTexture
                snowtubeSelectButton.size.height = 52
                
                //Display the purchase alert
                displayPurchaseRideAlert(ride: "snowtube", coins: 19000)
                
                //Play button sound
                playSound(name: buttonCloseSound)
            } else {
                print("not enough coins")
                
                displayInsufficientCoinsAlert()
                
                //Update the select button
                snowtubeSelectButton.texture = snowtubeSelectButton.defaultLockedTexture
                snowtubeSelectButton.size.height = 52
                
                //Play button sound
                playSound(name: buttonCloseSound)
            }
        }
    }
    
    func snowboardSelectButtonIsPressed() {
        if snowboardSelectButton.isTouched {
            if snowboardSelectButton.isUnlocked! {
                //If the snowboard is unlocked when touched but not selected, set it to the current ride
                if !snowboardSelectButton.isActive {
                    player.currentRide = "snowboard"
                    snowboardSelectButton.isActive = true
                    snowboardSelectButton.texture = snowboardSelectButton.activatedTexture
                    snowboardSelectButton.size.height = 49
                    saveCurrentRide()
                    
                    //Reset all other buttons to unselected
                    deselectOtherRideButtons()
                    
                    //Play button sound
                    playSound(name: buttonCloseSound)
                }
            } else if totalCoins >= 40000 {
                print("purchase snowboard")
                
                //Update the select button
                snowboardSelectButton.texture = snowboardSelectButton.defaultLockedTexture
                snowboardSelectButton.size.height = 52
                
                //Display the purchase alert
                displayPurchaseRideAlert(ride: "snowboard", coins: 40000)
                
                //Play button sound
                playSound(name: buttonCloseSound)
            } else {
                print("not enough coins")
                
                displayInsufficientCoinsAlert()
                
                //Update the select button
                snowboardSelectButton.texture = snowboardSelectButton.defaultLockedTexture
                snowboardSelectButton.size.height = 52
                
                //Play button sound
                playSound(name: buttonCloseSound)
            }
        }
    }
    
    func tobogganSelectButtonIsPressed() {
        if tobogganSelectButton.isTouched {
            if tobogganSelectButton.isUnlocked! {
                //If the toboggan is unlocked when touched but not selected, set it to the current ride
                if !tobogganSelectButton.isActive {
                    player.currentRide = "toboggan"
                    tobogganSelectButton.isActive = true
                    tobogganSelectButton.texture = tobogganSelectButton.activatedTexture
                    tobogganSelectButton.size.height = 49
                    saveCurrentRide()
                    
                    //Reset all other buttons to unselected
                    deselectOtherRideButtons()
                    
                    //Play button sound
                    playSound(name: buttonCloseSound)
                }
            } else if totalCoins >= 80000 {
                print("purchase toboggan")
                
                //Update the select button
                tobogganSelectButton.texture = tobogganSelectButton.defaultLockedTexture
                tobogganSelectButton.size.height = 52
                
                //Display the purchase alert
                displayPurchaseRideAlert(ride: "toboggan", coins: 80000)
                
                //Play button sound
                playSound(name: buttonCloseSound)
            } else {
                print("not enough coins")
                
                displayInsufficientCoinsAlert()
                
                //Update the select button
                tobogganSelectButton.texture = tobogganSelectButton.defaultLockedTexture
                tobogganSelectButton.size.height = 52
                
                //Play button sound
                playSound(name: buttonCloseSound)
            }
        }
    }
    
    func snowmobileSelectButtonIsPressed() {
        if snowmobileSelectButton.isTouched {
            if snowmobileSelectButton.isUnlocked! {
                //If the snowmobile is unlocked when touched but not selected, set it to the current ride
                if !snowmobileSelectButton.isActive {
                    player.currentRide = "snowmobile"
                    snowmobileSelectButton.isActive = true
                    snowmobileSelectButton.texture = snowmobileSelectButton.activatedTexture
                    snowmobileSelectButton.size.height = 49
                    saveCurrentRide()
                    
                    //Reset all other buttons to unselected
                    deselectOtherRideButtons()
                    
                    //Play button sound
                    playSound(name: buttonCloseSound)
                }
            } else if totalCoins >= 175000 {
                print("purchase snowmobile")
                
                //Update the select button
                snowmobileSelectButton.texture = snowmobileSelectButton.defaultLockedTexture
                snowmobileSelectButton.size.height = 52
                
                //Display the purchase alert
                displayPurchaseRideAlert(ride: "snowmobile", coins: 175000)
                
                //Play button sound
                playSound(name: buttonCloseSound)
            } else {
                print("not enough coins")
                
                displayInsufficientCoinsAlert()
                
                //Update the select button
                snowmobileSelectButton.texture = snowmobileSelectButton.defaultLockedTexture
                snowmobileSelectButton.size.height = 52
                
                //Play button sound
                playSound(name: buttonCloseSound)
            }
        }
    }
    
    func hoverboardSelectButtonIsPressed() {
        if hoverboardSelectButton.isTouched {
            if hoverboardSelectButton.isUnlocked! {
                //If the hoverboard is unlocked when touched but not selected, set it to the current ride
                if !hoverboardSelectButton.isActive {
                    player.currentRide = "hoverboard"
                    hoverboardSelectButton.isActive = true
                    hoverboardSelectButton.texture = hoverboardSelectButton.activatedTexture
                    hoverboardSelectButton.size.height = 49
                    saveCurrentRide()
                    
                    //Reset all other buttons to unselected
                    deselectOtherRideButtons()
                    
                    //Play button sound
                    playSound(name: buttonCloseSound)
                }
            } else if totalCoins >= 600000 {
                print("purchase hoverboard")
                
                //Update the select button
                hoverboardSelectButton.texture = hoverboardSelectButton.defaultLockedTexture
                hoverboardSelectButton.size.height = 52
                
                //Display the purchase alert
                displayPurchaseRideAlert(ride: "hoverboard", coins: 600000)
                
                //Play button sound
                playSound(name: buttonCloseSound)
            } else {
                print("not enough coins")
                
                displayInsufficientCoinsAlert()
                
                //Update the select button
                hoverboardSelectButton.texture = hoverboardSelectButton.defaultLockedTexture
                hoverboardSelectButton.size.height = 52
                
                //Play button sound
                playSound(name: buttonCloseSound)
            }
        }
    }
    
    func deselectOtherRideButtons() {
        if player.currentRide != "skis" {
            if player.skisUnlocked {
                skisSelectButton.texture = skisSelectButton.defaultTexture
            } else {
                skisSelectButton.texture = skisSelectButton.defaultLockedTexture
            }
            skisSelectButton.size.height = 52
            skisSelectButton.isActive = false
        }
        
        if player.currentRide != "snowtube" {
            if player.snowtubeUnlocked {
                snowtubeSelectButton.texture = snowtubeSelectButton.defaultTexture
            } else {
                snowtubeSelectButton.texture = snowtubeSelectButton.defaultLockedTexture
            }
            snowtubeSelectButton.size.height = 52
            snowtubeSelectButton.isActive = false
        }
        
        if player.currentRide != "snowboard" {
            if player.snowboardUnlocked {
                snowboardSelectButton.texture = snowboardSelectButton.defaultTexture
            } else {
                snowboardSelectButton.texture = snowboardSelectButton.defaultLockedTexture
            }
            snowboardSelectButton.size.height = 52
            snowboardSelectButton.isActive = false
        }
        
        if player.currentRide != "toboggan" {
            if player.tobogganUnlocked {
                tobogganSelectButton.texture = tobogganSelectButton.defaultTexture
            } else {
                tobogganSelectButton.texture = tobogganSelectButton.defaultLockedTexture
            }
            tobogganSelectButton.size.height = 52
            tobogganSelectButton.isActive = false
        }
        
        if player.currentRide != "snowmobile" {
            if player.snowmobileUnlocked {
                snowmobileSelectButton.texture = snowmobileSelectButton.defaultTexture
            } else {
                snowmobileSelectButton.texture = snowmobileSelectButton.defaultLockedTexture
            }
            snowmobileSelectButton.size.height = 52
            snowmobileSelectButton.isActive = false
        }
        
        if player.currentRide != "hoverboard" {
            if player.hoverboardUnlocked {
                hoverboardSelectButton.texture = hoverboardSelectButton.defaultTexture
            } else {
                hoverboardSelectButton.texture = hoverboardSelectButton.defaultLockedTexture
            }
            hoverboardSelectButton.size.height = 52
            hoverboardSelectButton.isActive = false
        }
    }
}
