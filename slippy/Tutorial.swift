//
//  Tutorial.swift
//  slippy
//
//  Created by Sam Wessley on 5/21/20.
//  Copyright © 2020 Sam Wessley. All rights reserved.
//

import SpriteKit

extension GameScene {
    func displayTutorial() {
        died = true
        pauseScene()
        
        //Create translucent background
        let bg = SKSpriteNode()
        bg.name = "tutorial_bg"
        bg.color = SKColor(red:0.1, green:0.24, blue:0.36, alpha:0.9)
        bg.size = self.size
        bg.position = .zero
        cam.addChild(bg)
        
        let text1 = SKSpriteNode(imageNamed: "carve_right_text")
        text1.size = CGSize(width: 262, height: 22)
        text1.position = CGPoint(x: 0, y: 160)
        text1.name = "tutorial_text1"
        cam.addChild(text1)
        
        let image1 = SKSpriteNode(imageNamed: "carve_right_image")
        image1.size = CGSize(width: 200, height: 200)
        image1.position = CGPoint(x: 0, y: 0)
        image1.name = "tutorial_image1"
        cam.addChild(image1)
    
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            nextButton.size = CGSize(width: 90, height: 81)
             nextButton.position = CGPoint(x: 140, y: -220)
        } else {
            nextButton.size = CGSize(width: 60, height: 54)
             nextButton.position = CGPoint(x: 100, y: -220)
        }
        nextButton.name = "tutorial_next_button"
        nextButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        cam.addChild(nextButton)
    }
    
    func displayPage2() {
        //Delete the page 1 image and text
        cam.enumerateChildNodes(withName: "tutorial_image1") {
            node, stop in
            node.removeFromParent()
        }
        cam.enumerateChildNodes(withName: "tutorial_text1") {
            node, stop in
            node.removeFromParent()
        }
        
        //Create the page 2 image and text
        let text2 = SKSpriteNode(imageNamed: "carve_left_text")
        text2.size = CGSize(width: 183, height: 44)
        text2.position = CGPoint(x: 0, y: 160)
        text2.name = "tutorial_text2"
        cam.addChild(text2)
        
        let image2 = SKSpriteNode(imageNamed: "carve_left_image")
        image2.size = CGSize(width: 200, height: 200)
        image2.position = CGPoint(x: 0, y: 0)
        image2.name = "tutorial_image2"
        cam.addChild(image2)
    }
    
    func displayPage3() {
        //Delete the page 2 image and text
        cam.enumerateChildNodes(withName: "tutorial_image2") {
            node, stop in
            node.removeFromParent()
        }
        cam.enumerateChildNodes(withName: "tutorial_text2") {
            node, stop in
            node.removeFromParent()
        }
        
        //Create the page 3 image and text
        let text3 = SKSpriteNode(imageNamed: "move_quickly_text")
        text3.size = CGSize(width: 204, height: 44)
        text3.position = CGPoint(x: 0, y: 160)
        text3.name = "tutorial_text3"
        cam.addChild(text3)
        
        let image3 = SKSpriteNode(imageNamed: "move_quickly_image")
        image3.size = CGSize(width: 200, height: 200)
        image3.position = CGPoint(x: 0, y: 0)
        image3.name = "tutorial_image3"
        cam.addChild(image3)
    }
    
    func displayPage4() {
        //Delete the page 3 image and text
        cam.enumerateChildNodes(withName: "tutorial_image3") {
            node, stop in
            node.removeFromParent()
        }
        cam.enumerateChildNodes(withName: "tutorial_text3") {
            node, stop in
            node.removeFromParent()
        }
        
        //Create the page 4 image and text
        let text4 = SKSpriteNode(imageNamed: "carve_harder_text")
        text4.size = CGSize(width: 189, height: 44)
        text4.position = CGPoint(x: 0, y: 160)
        text4.name = "tutorial_text4"
        cam.addChild(text4)
        
        let image4 = SKSpriteNode(imageNamed: "carve_harder_image")
        image4.size = CGSize(width: 200, height: 200)
        image4.position = CGPoint(x: 0, y: 0)
        image4.name = "tutorial_image4"
        cam.addChild(image4)
    }
    
    func displayPage5() {
        //Delete the page 4 image and text
        cam.enumerateChildNodes(withName: "tutorial_image4") {
            node, stop in
            node.removeFromParent()
        }
        cam.enumerateChildNodes(withName: "tutorial_text4") {
            node, stop in
            node.removeFromParent()
        }
        
        //Create the page 5 image and text
        let text5 = SKSpriteNode(imageNamed: "avoid_obstacles_text")
        text5.size = CGSize(width: 228, height: 44)
        text5.position = CGPoint(x: 0, y: 160)
        text5.name = "tutorial_text5"
        cam.addChild(text5)
        
        let image5 = SKSpriteNode(imageNamed: "avoid_obstacles_image")
        image5.size = CGSize(width: 200, height: 200)
        image5.position = CGPoint(x: 0, y: 0)
        image5.name = "tutorial_image5"
        cam.addChild(image5)
    }
    
    func dismissTutorial() {
        //Remove the tutorial elements
        cam.enumerateChildNodes(withName: "tutorial_bg") {
            node, stop in
            node.removeFromParent()
        }
        cam.enumerateChildNodes(withName: "tutorial_text5") {
            node, stop in
            node.removeFromParent()
        }
        cam.enumerateChildNodes(withName: "tutorial_image5") {
            node, stop in
            node.removeFromParent()
        }
        
        restart()
    }
}
