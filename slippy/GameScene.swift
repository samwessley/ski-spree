//
//  GameScene.swift
//  slippy
//
//  Created by Sam Wessley on 9/22/18.
//  Copyright © 2018 Sam Wessley. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
import StoreKit
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameStarted: Bool = false
    var died: Bool = false
    var playerCanMove: Bool = false
    
    var world = SKNode()
    var cam = SKCameraNode()
    
    var highScore: Int = 0
    var totalCoins: Int = 0
    
    //Player properties
    var player = Skier()
    let playerDefaultYInset : CGFloat = 250
    var playerMaxSpeed: CGFloat = 360
    var playerTouchForce: CGFloat = 6
    
    //Score
    var score = 0
    var scoreLabelBg = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var scoreLabelShadow = SKLabelNode()
    var scoreLabelShadowAttributes: [NSAttributedString.Key : Any] = [.strokeWidth: 10.0,
                                                                      .strokeColor: UIColor.black,
                                                                      .foregroundColor: UIColor.black,
                                                                      .font: UIFont(name: "Quick", size: 40)!]
    //Game Over menu
    var restartButton = Button(defaultTexture: SKTexture(imageNamed: "restart"), pressedTexture: SKTexture(imageNamed: "restart_pressed"))
    var rankingsButton = Button(defaultTexture: SKTexture(imageNamed: "rankings"), pressedTexture: SKTexture(imageNamed: "rankings_pressed"))
    
    //Coins
    var coinsLabel = SKLabelNode()
    var coinsLabelBg = SKSpriteNode()
    var coinsLabelShadow = SKLabelNode()
    var coinsLabelShadowAttributes: [NSAttributedString.Key : Any] = [.strokeWidth: -14.0,
                                                                      .strokeColor: UIColor.black,
                                                                      .foregroundColor: UIColor.black,
                                                                      .font: UIFont(name: "Quick", size: 20)!]
    
    //Shop menu properties
    var products: [SKProduct] = []
    var isTouchingMoveableNode = false
    var moveableNode = SKSpriteNode()
    var buttonTouched = false
    var shopBack = Button(defaultTexture: SKTexture(imageNamed: "back"), pressedTexture: SKTexture(imageNamed: "back_pressed"))
    let spinnerAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    //Shop menu purchase buttons
    var skisSelectButton = Button(defaultLockedTexture: SKTexture(imageNamed: "select_button"), pressedLockedTexture: SKTexture(imageNamed: "select_button_pressed"))
    var snowtubeSelectButton = Button(defaultLockedTexture: SKTexture(imageNamed: "19000button"), pressedLockedTexture: SKTexture(imageNamed: "19000button_pressed"))
    var snowboardSelectButton = Button(defaultLockedTexture: SKTexture(imageNamed: "40000button"), pressedLockedTexture: SKTexture(imageNamed: "40000button_pressed"))
    var tobogganSelectButton = Button(defaultLockedTexture: SKTexture(imageNamed: "80000button"), pressedLockedTexture: SKTexture(imageNamed: "80000button_pressed"))
    var snowmobileSelectButton = Button(defaultLockedTexture: SKTexture(imageNamed: "175000button"), pressedLockedTexture: SKTexture(imageNamed: "175000button_pressed"))
    var hoverboardSelectButton = Button(defaultLockedTexture: SKTexture(imageNamed: "600000button"), pressedLockedTexture: SKTexture(imageNamed: "600000button_pressed"))
    
    var purchase7500CoinsButton = Button(defaultTexture: SKTexture(imageNamed: "$0.99_button"), pressedTexture: SKTexture(imageNamed: "$0.99_button_pressed"))
    var purchase45KCoinsButton = Button(defaultTexture: SKTexture(imageNamed: "$4.99_button"), pressedTexture: SKTexture(imageNamed: "$4.99_button_pressed"))
    var purchase90KCoinsButton = Button(defaultTexture: SKTexture(imageNamed: "$8.99_button"), pressedTexture: SKTexture(imageNamed: "$8.99_button_pressed"))
    var purchase180KCoinsButton = Button(defaultTexture: SKTexture(imageNamed: "$14.99_button"), pressedTexture: SKTexture(imageNamed: "$14.99_button_pressed"))
    var purchase500KCoinsButton = Button(defaultTexture: SKTexture(imageNamed: "$34.99_button"), pressedTexture: SKTexture(imageNamed: "$34.99_button_pressed"))
    var purchase1_2MCoinsButton = Button(defaultTexture: SKTexture(imageNamed: "$59.99_button"), pressedTexture: SKTexture(imageNamed: "$59.99_button_pressed"))
    
    //Settings menu properties
    var musicEnabled = true
    var soundEnabled = true
    var vibrationEnabled = true
    
    //Settings menu buttons
    var musicToggle = Button(defaultTexture: SKTexture(imageNamed: "music"), pressedTexture: SKTexture(imageNamed: "music_pressed"), activatedTexture: SKTexture(imageNamed: "music_off"), activatedPressedTexture: SKTexture(imageNamed: "music_off_pressed"), firstLabel: "MUTE", secondLabel: "MUSIC")
    var soundToggle = Button(defaultTexture: SKTexture(imageNamed: "sound"), pressedTexture: SKTexture(imageNamed: "sound_pressed"), activatedTexture: SKTexture(imageNamed: "sound_off"), activatedPressedTexture: SKTexture(imageNamed: "sound_off_pressed"), firstLabel: "MUTE", secondLabel: "SOUNDS")
    var vibrationToggle = Button(defaultTexture: SKTexture(imageNamed: "vibration"), pressedTexture: SKTexture(imageNamed: "vibration_pressed"), activatedTexture: SKTexture(imageNamed: "vibration_off"), activatedPressedTexture: SKTexture(imageNamed: "vibration_off_pressed"), firstLabel: "DISABLE", secondLabel: "VIBRATIONS")
    var settingsBack = Button(defaultTexture: SKTexture(imageNamed: "down"), pressedTexture: SKTexture(imageNamed: "down_pressed"))

    //Rewarded Ad prompt buttons
    var acceptAdButton = Button(defaultTexture: SKTexture(imageNamed: "rewarded_ad_prompt_accept_button"), pressedTexture: SKTexture(imageNamed: "rewarded_ad_prompt_accept_button_pressed"))
    var cancelAdButton = Button(defaultTexture: SKTexture(imageNamed: "rewarded_ad_prompt_cancel_button"), pressedTexture: SKTexture(imageNamed: "rewarded_ad_prompt_cancel_button_pressed"))
    
    //Properties to determine player movement
    var isTouching: Bool = false
    var touchToggle: Bool = false
    var menuActive: Bool = false
    
    //World properties
    var defaultSceneVelocity = CGVector(dx: 0, dy: 280)
    var currentSceneVelocity = CGVector(dx: 0, dy: 0)
    var spawnDuration: TimeInterval = 0
    var zPositionCounter: CGFloat = 0
    
    //Start spawning goals
    var level: Int = 0
    var goalWait = SKAction.wait(forDuration: 1.5)
    var goalWidth = 100
    var goalColorTracker = false
    var goalRotation: CGFloat = 0.0
    var goalRotationMax: CGFloat = 30
    
    //Ski track properties
    var currentPoint: CGFloat = 0
    var currentWidth: CGFloat = 140
    var pathCurviness = 0.004
 
    //Noise map properties
    let source = GKPerlinNoiseSource()
    var noise = GKNoise()
    var map = GKNoiseMap()
    
    //Start menu properties
    var logo = SKSpriteNode()
    var shopButton = Button(defaultTexture: SKTexture(imageNamed: "shop"), pressedTexture: SKTexture(imageNamed: "shop_pressed"))
    var settingsButton = Button(defaultTexture: SKTexture(imageNamed: "settings"), pressedTexture: SKTexture(imageNamed: "settings_pressed"))
    
    //Tutorial menu properties
    var nextButton = Button(defaultTexture: SKTexture(imageNamed: "next"), pressedTexture: SKTexture(imageNamed: "next_pressed"))
    var tutorialDisplayed = false
    
    //Sounds
    let buttonOpenSound = SKAction.playSoundFileNamed("button_open", waitForCompletion: true)
    let buttonCloseSound = SKAction.playSoundFileNamed("button_close", waitForCompletion: true)
    let crashSound = SKAction.playSoundFileNamed("crash", waitForCompletion: false)
    let missedSound = SKAction.playSoundFileNamed("missed", waitForCompletion: false)
    let popSound = SKAction.playSoundFileNamed("pop", waitForCompletion: false)
    let pulseSound = SKAction.playSoundFileNamed("pulse", waitForCompletion: false)
    let wooshSound = SKAction.playSoundFileNamed("woosh", waitForCompletion: false)
    let woosh2Sound = SKAction.playSoundFileNamed("woosh2", waitForCompletion: false)
    let snow = SKAudioNode(fileNamed: "snow.mp3")
    let wind = SKAudioNode(fileNamed: "wind.mp3")
    
    //Music
    let music = SKAudioNode(fileNamed: "Celebration.mp3")
    let musicToFullVolume = SKAction.changeVolume(to: 1, duration: 0)
    let musicToMute = SKAction.changeVolume(to: 0, duration: 0)
    
    var timesPlayedCounter = 0
    
    override func didMove(to view: SKView) {
        loadUserDetails()
        loadUnlockedRides()
        loadCurrentRide()
        createScene()
        getIAPproducts()
        shouldDisplayAd()
        setupIAPNotificationObservers()
        setupRewardedAdObservers()
    }
    
    func createScene() {
        //Run fade-in effect
        runFadeInEffect()
        
        //Set up scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor(red:0.89, green:0.94, blue:1.00, alpha:1.0)
        self.view?.isMultipleTouchEnabled = true
        self.physicsWorld.contactDelegate = self
        
        //Add top-level world node to the scene
        self.addChild(world)
        
        //Add ambient snow
        generateAmbientSnow()
        
        //Set up camera
        self.camera = cam
        cam.zPosition = CGFloat(Int.max)
        if getScreenResolution() == 2 {
            cam.setScale(0.667)
        }
        
        world.addChild(cam)
        setCameraConstraints()
        
        //Initiate the noise map
        noise = GKNoise(source)
        buildMap()
        
        //Add initial obstacles to the scene
        setupInitialWorldElements()
        
        //Add logo to scene
        createLogo()
        
        //Add coins label
        createCoinsLabel()
        
        //Add shop button
        //createShopButton()
        
        //Add rankings button
        createRankingsButton()
        
        //Add settings button
        createSettingsButton()
        
        //Add player to scene
        spawnPlayer()
        
        updateCoinsLabel()
        
        //Add wind sound
        if soundEnabled {
            wind.name = "wind"
            self.addChild(wind)
        }
        
        //Add music
        if musicEnabled {
            music.name = "music"
            music.run(musicToFullVolume)
            self.addChild(music)
        }
    }
    
    func updateMap() {
        map = GKNoiseMap(noise, size: vector2(Double(self.frame.size.width), 1), origin: (vector2(map.origin.x + pathCurviness, 0)), sampleCount: vector2(50, 50), seamless: false)
        currentPoint = CGFloat(self.map.value(at: vector2(1,1))) * (self.frame.size.width / 2 - 100)
    }
    
    func setupInitialWorldElements() {
        for _ in 1...160 {
            spawnInitialObstacle()
            zPositionCounter += 1
        }
    }
    
    func setupIAPNotificationObservers() {
        //Notification observer for handling In-App Purchases
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
        name: .IAPHelperPurchaseNotification,
        object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseFailedNotification(_:)),
        name: .IAPHelperPurchaseFailedNotification,
        object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseCancelledNotification(_:)),
        name: .IAPHelperPurchaseCancelledNotification,
        object: nil)
    }
    
    func setupRewardedAdObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(disburseAdReward(_:)), name: .DisburseRewardNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rewardedAdDismissed(_:)), name: .RewardedAdDismissedNotification, object: nil)
    }
    
    func saveUserSettings() {
        UserDefaults.standard.set(highScore, forKey: "highScore")
        UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
        UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")
        UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        UserDefaults.standard.set(vibrationEnabled, forKey: "vibrationEnabled")
    }
    
    func loadUserDetails() {
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        timesPlayedCounter = UserDefaults.standard.integer(forKey: "timesPlayed")
        musicEnabled = UserDefaults.standard.bool(forKey: "musicEnabled")
        soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        vibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        tutorialDisplayed = UserDefaults.standard.bool(forKey: "tutorialDisplayed")
    }
    
    func gameOver(type: String) {
        died = true
        pauseScene()
        
        //Stop the snow sound
        self.enumerateChildNodes(withName: "snowSound") {
            node, stop in
            node.removeFromParent()
        }
        
        //Stop the wind noise
        self.enumerateChildNodes(withName: "wind") {
            node, stop in
            node.removeFromParent()
        }
        
        //Stop the music
        self.enumerateChildNodes(withName: "music") {
            node, stop in
            node.removeFromParent()
        }
    
        //Save the coins
        UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
        
        //Increment the timesPlayed counter
        timesPlayedCounter = timesPlayedCounter + 1
        UserDefaults.standard.set(timesPlayedCounter, forKey: "timesPlayed")
        
        createGameOverMenu(type: type)
    }
    
    func saveScore(score: Int) {
        UserDefaults.standard.set(score, forKey: "highScore")
    }
    
    func saveCurrentRide() {
        UserDefaults.standard.set(player.currentRide, forKey: "playerCurrentRide")
    }
    
    func loadCurrentRide() {
        player.currentRide = UserDefaults.standard.string(forKey: "playerCurrentRide") ?? "skis"
    }
    
    func saveUnlockedRides() {
        UserDefaults.standard.set(player.snowtubeUnlocked, forKey: "snowtubeUnlocked")
        UserDefaults.standard.set(player.snowboardUnlocked, forKey: "snowboardUnlocked")
        UserDefaults.standard.set(player.tobogganUnlocked, forKey: "tobogganUnlocked")
        UserDefaults.standard.set(player.snowmobileUnlocked, forKey: "snowmobileUnlocked")
        UserDefaults.standard.set(player.hoverboardUnlocked, forKey: "hoverboardUnlocked")
    }
    
    func loadUnlockedRides() {
        player.snowtubeUnlocked = UserDefaults.standard.bool(forKey: "snowtubeUnlocked")
        player.snowboardUnlocked = UserDefaults.standard.bool(forKey: "snowboardUnlocked")
        player.tobogganUnlocked = UserDefaults.standard.bool(forKey: "tobogganUnlocked")
        player.snowmobileUnlocked = UserDefaults.standard.bool(forKey: "snowmobileUnlocked")
        player.hoverboardUnlocked = UserDefaults.standard.bool(forKey: "hoverboardUnlocked")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = nodes(at: location)
            
            for node in touchedNode {
                if node is SKSpriteNode {
                    let sprite = node as! SKSpriteNode
                    
                    if sprite.isKind(of: Button.self) {
                        buttonTouched = true
                    }
                    
                    //If the scrollview is pressed, set isTouchingMoveableNode to true
                    if sprite.name == "scrollViewBorder" {
                        isTouchingMoveableNode = true
                    }
                    //If any of the coin purchase buttons are pressed, handle it
                    switch sprite.name {
                    case "$0.99_coin_button", "$4.99_coin_button", "$8.99_coin_button", "$14.99_coin_button", "$34.99_coin_button", "$59.99_coin_button":
                        let sprite = sprite as! Button
                        sprite.isTouched = true
                        sprite.texture = sprite.pressedTexture
                        sprite.size.height = 43
                        
                        //Play button sound
                        playSound(name: buttonOpenSound)
                    default:
                        break
                    }
                }
            }
            
            if shopButton === atPoint(location) {
                shopButton.isTouched = true
                shopButton.texture = shopButton.pressedTexture
                shopButton.size.height = 48
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    shopButton.size.height = 72
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            if skisSelectButton === atPoint(location) {
                if skisSelectButton.isUnlocked! {
                    if !skisSelectButton.isActive {
                        skisSelectButton.texture = skisSelectButton.pressedTexture
                        skisSelectButton.size.height = 45
                        
                        //Play button sound
                        playSound(name: buttonOpenSound)
                    }
                } else {
                    skisSelectButton.texture = skisSelectButton.pressedLockedTexture
                    skisSelectButton.size.height = 45
                    
                    //Play button sound
                    playSound(name: buttonOpenSound)
                }
                skisSelectButton.isTouched = true
            }
            
            if snowtubeSelectButton === atPoint(location) {
                if snowtubeSelectButton.isUnlocked! {
                    if !snowtubeSelectButton.isActive {
                        snowtubeSelectButton.texture = snowtubeSelectButton.pressedTexture
                        snowtubeSelectButton.size.height = 45
                        
                        //Play button sound
                        playSound(name: buttonOpenSound)
                    }
                } else {
                    snowtubeSelectButton.texture = snowtubeSelectButton.pressedLockedTexture
                    snowtubeSelectButton.size.height = 45
                    
                    //Play button sound
                    playSound(name: buttonOpenSound)
                }
                snowtubeSelectButton.isTouched = true
            }
            
            if snowboardSelectButton === atPoint(location) {
                if snowboardSelectButton.isUnlocked! {
                    if !snowboardSelectButton.isActive {
                        snowboardSelectButton.texture = snowboardSelectButton.pressedTexture
                        snowboardSelectButton.size.height = 45
                        
                        //Play button sound
                        playSound(name: buttonOpenSound)
                    }
                } else {
                    snowboardSelectButton.texture = snowboardSelectButton.pressedLockedTexture
                    snowboardSelectButton.size.height = 45
                    
                    //Play button sound
                    playSound(name: buttonOpenSound)
                }
                snowboardSelectButton.isTouched = true
            }
            
            if tobogganSelectButton === atPoint(location) {
                if tobogganSelectButton.isUnlocked! {
                    if !tobogganSelectButton.isActive {
                        tobogganSelectButton.texture = tobogganSelectButton.pressedTexture
                        tobogganSelectButton.size.height = 45
                        
                        //Play button sound
                        playSound(name: buttonOpenSound)
                    }
                } else {
                    tobogganSelectButton.texture = tobogganSelectButton.pressedLockedTexture
                    tobogganSelectButton.size.height = 45
                    
                    //Play button sound
                    playSound(name: buttonOpenSound)
                }
                tobogganSelectButton.isTouched = true
            }
            
            if snowmobileSelectButton === atPoint(location) {
                if snowmobileSelectButton.isUnlocked! {
                    if !snowmobileSelectButton.isActive {
                        snowmobileSelectButton.texture = snowmobileSelectButton.pressedTexture
                        snowmobileSelectButton.size.height = 45
                        
                        //Play button sound
                        playSound(name: buttonOpenSound)
                    }
                } else {
                    snowmobileSelectButton.texture = snowmobileSelectButton.pressedLockedTexture
                    snowmobileSelectButton.size.height = 45
                    
                    //Play button sound
                    playSound(name: buttonOpenSound)
                }
                snowmobileSelectButton.isTouched = true
            }
            
            if hoverboardSelectButton === atPoint(location) {
                if hoverboardSelectButton.isUnlocked! {
                    if !hoverboardSelectButton.isActive {
                        hoverboardSelectButton.texture = hoverboardSelectButton.pressedTexture
                        hoverboardSelectButton.size.height = 45
                        
                        //Play button sound
                        playSound(name: buttonOpenSound)
                    }
                } else {
                    hoverboardSelectButton.texture = hoverboardSelectButton.pressedLockedTexture
                    hoverboardSelectButton.size.height = 45
                    
                    //Play button sound
                    playSound(name: buttonOpenSound)
                }
                hoverboardSelectButton.isTouched = true
            }
            
            if rankingsButton === atPoint(location) {
                rankingsButton.isTouched = true
                rankingsButton.texture = rankingsButton.pressedTexture
                rankingsButton.size.height = 48
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    rankingsButton.size.height = 72
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            if settingsButton === atPoint(location) {
                settingsButton.isTouched = true
                settingsButton.texture = settingsButton.pressedTexture
                settingsButton.size.height = 48
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    settingsButton.size.height = 72
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            if restartButton === atPoint(location) {
                restartButton.isTouched = true
                restartButton.texture = restartButton.pressedTexture
                restartButton.size.height = 60
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            if musicToggle === atPoint(location) {
                musicToggle.isTouched = true
                if musicToggle.isActive {
                    musicToggle.texture = musicToggle.activatedPressedTexture
                } else {
                    musicToggle.texture = musicToggle.pressedTexture
                }
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    musicToggle.size.height = 72
                } else {
                    musicToggle.size.height = 48
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            if soundToggle === atPoint(location) {
                soundToggle.isTouched = true
                if soundToggle.isActive {
                    soundToggle.texture = soundToggle.activatedPressedTexture
                } else {
                    soundToggle.texture = soundToggle.pressedTexture
                }
               
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    soundToggle.size.height = 72
                } else {
                    soundToggle.size.height = 48
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            if vibrationToggle === atPoint(location) {
                vibrationToggle.isTouched = true
                if vibrationToggle.isActive {
                    vibrationToggle.texture = vibrationToggle.activatedPressedTexture
                } else {
                    vibrationToggle.texture = vibrationToggle.pressedTexture
                }
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    vibrationToggle.size.height = 72
                } else {
                    vibrationToggle.size.height = 48
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            //If shop back button is touched
            if shopBack === atPoint(location) {
                shopBack.isTouched = true
                shopBack.texture = shopBack.pressedTexture
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    shopBack.size.height = 72
                } else {
                    shopBack.size.height = 48
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            //If settings back button is touched
            if settingsBack === atPoint(location) {
                settingsBack.isTouched = true
                settingsBack.texture = settingsBack.pressedTexture
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    settingsBack.size.height = 72
                } else {
                    settingsBack.size.height = 48
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            //If accept rewarded ad button is touched
            if acceptAdButton === atPoint(location) {
                acceptAdButton.isTouched = true
                acceptAdButton.texture = acceptAdButton.pressedTexture
                acceptAdButton.size.height = 49
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            //If reject rewarded ad button is touched
            if cancelAdButton === atPoint(location) {
                cancelAdButton.isTouched = true
                cancelAdButton.texture = cancelAdButton.pressedTexture
                cancelAdButton.size.height = 24
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            //If tutorial next button is touched
            if nextButton === atPoint(location) {
                nextButton.isTouched = true
                nextButton.texture = nextButton.pressedTexture
                
                if getScreenResolution() == 2 || getScreenResolution() == 1 {
                    nextButton.size.height = 72
                } else {
                    nextButton.size.height = 48
                }
                
                //Play button sound
                playSound(name: buttonOpenSound)
            }
            
            //If the game hasn't started and it's not a button that's being touched, start the game
            if !shopButton.isTouched && !settingsButton.isTouched && !rankingsButton.isTouched && !rewardedAdPromptIsDisplayed() {
                if !gameStarted && !menuActive {
                    shouldDisplayTutorial()
                    
                    if !tutorialIsDisplayed() {
                        gameStarted = true
                        world.isPaused = false
                        currentSceneVelocity.dy = defaultSceneVelocity.dy
                        
                        //Remove the logo and main menu buttons
                        logo.run(SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width/2 + logo.size.width*2, y: 100), duration: 0.5), completion: {
                            self.logo.removeFromParent()
                        })
                        shopButton.run(SKAction.move(to: CGPoint(x: -UIScreen.main.bounds.size.width/2 - 72, y: -UIScreen.main.bounds.size.height/2 + 120), duration: 0.1), completion: {
                            self.shopButton.removeFromParent()
                        })
                        rankingsButton.run(SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width/2 + 72, y: -UIScreen.main.bounds.size.height/2 + 194), duration: 0.1), completion: {
                            self.rankingsButton.removeFromParent()
                        })
                        settingsButton.run(SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width/2 + 72, y: -UIScreen.main.bounds.size.height/2 + 120), duration: 0.1), completion: {
                            self.settingsButton.removeFromParent()
                        })
                        
                        //Play woosh sound
                        playSound(name: woosh2Sound)
                        
                        //Add the score label
                        createScoreLabel()
                        
                        //Animate player to go back to the playing position
                        animatePlayerToPlayingPosition()
                        
                        //Start spawning obstacles
                        let spawnObstacleSequence = SKAction.sequence([SKAction.run(spawnObstacle), SKAction.run {self.zPositionCounter += 1}, SKAction.wait(forDuration: 0.05)])
                        let spawnObstaclesForever = SKAction.repeatForever(spawnObstacleSequence)
                        self.run(spawnObstaclesForever)
                        
                        startSpawningGoals()
                        
                        //Start spawning player track
                        let spawnTrackSequence = SKAction.sequence([SKAction.run(spawnTrack), SKAction.wait(forDuration: 0.01)])
                        let spawnTrackForever = SKAction.repeatForever(spawnTrackSequence)
                        self.run(spawnTrackForever)
                        
                        //Add the snowmobile trail if necessary
                        let wait = SKAction.wait(forDuration: 1.0)
                        let activate = SKAction.run {
                            if self.player.currentRide == "snowmobile" {
                                self.player.addSnowmobileSnow()
                            }
                            if self.player.currentRide != "hoverboard" {
                                self.player.addDefaultSnow()
                            }
                        }
                        let sequence = SKAction.sequence([wait, activate])
                        self.run(sequence)
                        
                        //Start spawning trams
                        spawnTrams()
                        
                        //Start spawning coins
                        spawnCoins()
                        
                        //This is a noise tracker to track the "ideal" path
                        //run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnNoiseTracker), SKAction.wait(forDuration: 0.02)])))
                        
                        //Configure and add snow sound
                        if player.currentRide != "hoverboard" {
                            snow.name = "snowSound"
                            snow.run(SKAction.changeVolume(to: 0, duration: 0))
                            if soundEnabled {
                                self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run {
                                    self.addChild(self.snow)
                                    self.snow.run(SKAction.changeVolume(to: 0.2, duration: 0.2))
                                    }]))
                            }
                        }
                    }
                    
                } else {
                    //Move player if possible
                    if !died && playerCanMove {
                        isTouching = true
                        touchToggle = !touchToggle
                        
                        //Removes any existing snow effects from the player
                        player.enumerateChildNodes(withName: "snow") {
                            node, stop in
                            if (node is SKEmitterNode) {
                                let sprite = node as! SKEmitterNode
                                sprite.particleBirthRate = 0
                            }
                        }
                        
                        //Add new snow effect to player
                        addSnowEmitter()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        for _ in touches {
            if isTouchingMoveableNode {
                let touch = touches.first
                let touchLocation = touch!.location(in: self)
                let previousLocation = touch!.previousLocation(in: self)
                let deltaY = (touchLocation.y - previousLocation.y)
                
                if moveableNode.position.y + deltaY >= 240  && moveableNode.position.y + deltaY <= 1810 {
                    moveableNode.run(SKAction.moveTo(y: moveableNode.position.y + deltaY, duration: 0))
                }
            }
            
            //If touch moves off a button, reset all the buttons to their non-touched state
            if !touchedNode.isKind(of: Button.self) && buttonTouched {
                buttonTouched = false
                resetAllButtons()
                
                //Play button sound
                playSound(name: buttonCloseSound)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        isTouchingMoveableNode = false
        buttonTouched = false
        
        //Toggle shop menu if shop button is touched
        if shopButton.isTouched {
            //Animate button
            shopButton.texture = shopButton.defaultTexture
            shopButton.size.height = 54
            
            //Create the shop menu
            createShopMenu()
            menuActive = true
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        if skisSelectButton.isTouched {
            if skisSelectButton.isUnlocked! {
                if !skisSelectButton.isActive {
                    player.currentRide = "skis"
                    skisSelectButton.isActive = true
                    skisSelectButton.texture = skisSelectButton.activatedTexture
                    skisSelectButton.size.height = 49
                    saveCurrentRide()
                    
                    deselectOtherRideButtons()
                    
                    //Play button sound
                    playSound(name: buttonCloseSound)
                }
            } else {
                print("purchase skis")
                skisSelectButton.texture = skisSelectButton.defaultLockedTexture
                skisSelectButton.size.height = 52
                
                //Play button sound
                playSound(name: buttonCloseSound)
            }
        }
        
        //Handle what happens when the snowtube select button is pressed
        snowtubeSelectButtonIsPressed()
        
        //Handle what happens when the snowboard select button is pressed
        snowboardSelectButtonIsPressed()
        
        //Handle what happens when the toboggan select button is pressed
        tobogganSelectButtonIsPressed()
        
        //Handle what happens when the snowmobile select button is pressed
        snowmobileSelectButtonIsPressed()
        
        //Handle what happens when the hoverboard select button is pressed
        hoverboardSelectButtonIsPressed()
        
        //This section handles touches on all the shop purchase buttons
        if purchase7500CoinsButton.isTouched {
            
            //Animate button
            purchase7500CoinsButton.texture = purchase7500CoinsButton.defaultTexture
            purchase7500CoinsButton.size.height = 48
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            //In App Purchase stuff
            if IAPHelper.canMakePayments() {
                if searchProductArray(productIdentifier: "com.eudeon.skispree.7500_coinpack") != nil {
                    SkiSpreeProducts.store.buyProduct(searchProductArray(productIdentifier: "com.eudeon.skispree.7500_coinpack")!)
                    print("purchase successful")
                    presentSpinner()
                }
            } else {
                print("something went wrong when trying to purchase")
            }
        }
        
        if purchase45KCoinsButton.isTouched {
            //Animate button
            purchase45KCoinsButton.texture = purchase45KCoinsButton.defaultTexture
            purchase45KCoinsButton.size.height = 48
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            //In App Purchase stuff
            if IAPHelper.canMakePayments() {
                if searchProductArray(productIdentifier: "com.eudeon.skispree.45000_coinpack") != nil {
                    SkiSpreeProducts.store.buyProduct(searchProductArray(productIdentifier: "com.eudeon.skispree.45000_coinpack")!)
                    print("purchase successful")
                    presentSpinner()
                }
            } else {
                print("something went wrong when trying to purchase")
            }
        }
        
        if purchase90KCoinsButton.isTouched {
            //Animate button
            purchase90KCoinsButton.texture = purchase90KCoinsButton.defaultTexture
            purchase90KCoinsButton.size.height = 48
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            //In App Purchase stuff
            if IAPHelper.canMakePayments() {
                if searchProductArray(productIdentifier: "com.eudeon.skispree.90000_coinpack") != nil {
                    SkiSpreeProducts.store.buyProduct(searchProductArray(productIdentifier: "com.eudeon.skispree.90000_coinpack")!)
                    print("purchase successful")
                    presentSpinner()
                }
            } else {
                print("something went wrong when trying to purchase")
            }
        }
        
        if purchase180KCoinsButton.isTouched {
            //Animate button
            purchase180KCoinsButton.texture = purchase180KCoinsButton.defaultTexture
            purchase180KCoinsButton.size.height = 48
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            //In App Purchase stuff
            if IAPHelper.canMakePayments() {
                if searchProductArray(productIdentifier: "com.eudeon.skispree.180000_coinpack") != nil {
                    SkiSpreeProducts.store.buyProduct(searchProductArray(productIdentifier: "com.eudeon.skispree.180000_coinpack")!)
                    print("purchase successful")
                    presentSpinner()
                }
            } else {
                print("something went wrong when trying to purchase")
            }
        }
        
        if purchase500KCoinsButton.isTouched {
            //Animate button
            purchase500KCoinsButton.texture = purchase500KCoinsButton.defaultTexture
            purchase500KCoinsButton.size.height = 48
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            //In App Purchase stuff
            if IAPHelper.canMakePayments() {
                if searchProductArray(productIdentifier: "com.eudeon.skispree.500000_coinpack") != nil {
                    SkiSpreeProducts.store.buyProduct(searchProductArray(productIdentifier: "com.eudeon.skispree.500000_coinpack")!)
                    print("purchase successful")
                    presentSpinner()
                }
            } else {
                print("something went wrong when trying to purchase")
            }
        }
        
        if purchase1_2MCoinsButton.isTouched {
            //Animate button
            purchase1_2MCoinsButton.texture = purchase1_2MCoinsButton.defaultTexture
            purchase1_2MCoinsButton.size.height = 48
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            //In App Purchase stuff
            if IAPHelper.canMakePayments() {
                if searchProductArray(productIdentifier: "com.eudeon.skispree.1200000_coinpack") != nil {
                    SkiSpreeProducts.store.buyProduct(searchProductArray(productIdentifier: "com.eudeon.skispree.1200000_coinpack")!)
                    print("purchase successful")
                    presentSpinner()
                }
            } else {
                print("something went wrong when trying to purchase")
            }
        }
        
        if rankingsButton.isTouched {
            //Animate Button
            rankingsButton.texture = rankingsButton.defaultTexture
            rankingsButton.size.height = 54
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            //Notify the view controller to open Game Center
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "openGameCenter"), object: nil)
        }
        
        //Toggle Settings menu if settings button is touched
        if settingsButton.isTouched {
            //Animate button
            settingsButton.texture = settingsButton.defaultTexture
            settingsButton.size.height = 54
            
            //Create the settings menu
            createSettingsMenu()
            menuActive = true
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        if restartButton.isTouched {
            restartButton.texture = restartButton.defaultTexture
            restartButton.size.height = 65
            
            run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.run(restart)]))
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        //If music toggle button is touched
        if musicToggle.isTouched {
            if !musicEnabled {
                musicToggle.texture = musicToggle.activatedTexture
                musicToggle.size.height = 52
            } else {
                musicToggle.texture = musicToggle.defaultTexture
                musicToggle.size.height = 54
            }
            musicToggle.isActive = !musicToggle.isActive
            musicEnabled = !musicEnabled
            
            //If music is disabled, stop the music
            if !musicEnabled {
                music.run(musicToMute)
            } else {
                music.run(musicToFullVolume)
            }
            
            //Save the musicEnabled setting
            UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        //If sound toggle button is touched
        if soundToggle.isTouched {
            if !soundEnabled {
                soundToggle.texture = soundToggle.activatedTexture
                soundToggle.size.height = 52
            } else {
                soundToggle.texture = soundToggle.defaultTexture
                soundToggle.size.height = 54
            }
            soundToggle.isActive = !soundToggle.isActive
            soundEnabled = !soundEnabled
            
            //If sound is disabled, stop the wind sound
            if !soundEnabled {
                wind.run(SKAction.stop())
            } else {
                wind.run(SKAction.play())
            }
            
            //Save the soundEnabled setting
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        //If vibration toggle button is touched
        if vibrationToggle.isTouched {
            if !vibrationEnabled {
                vibrationToggle.texture = vibrationToggle.activatedTexture
                vibrationToggle.size.height = 52
            } else {
                vibrationToggle.texture = vibrationToggle.defaultTexture
                vibrationToggle.size.height = 54
            }
            vibrationToggle.isActive = !vibrationToggle.isActive
            vibrationEnabled = !vibrationEnabled
            
            //Save the vibrationEnabled setting
            UserDefaults.standard.set(vibrationEnabled, forKey: "vibrationEnabled")
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        //If shop back button is touched, remove the menu from the screen
        if shopBack.isTouched {
            //Animate button
            shopBack.texture = shopBack.defaultTexture
            shopBack.size.height = 54
            
            //Remove all menus
            cam.enumerateChildNodes(withName: "overlay_menu") {
                node, stop in
                node.removeFromParent()
            }
            menuActive = false
            
            //Reset the coins label's parent
            coinsLabelBg.removeFromParent()
            cam.addChild(coinsLabelBg)
            
            //Reconfigure the player physics
            player.setPhysics()
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        //If settings back button is touched, remove the menu from the screen
        if settingsBack.isTouched {
            //Animate buttons
            musicToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120), duration: 0.1))
            soundToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120), duration: 0.1))
            vibrationToggle.run(SKAction.move(to: CGPoint(x: getAdjustedSceneWidth()/2 - 20, y: -self.size.height/2 + 120), duration: 0.1))
            
            //Remove the settings menu
            let wait = SKAction.wait(forDuration: 0.1)
            let removeSettingsMenu = SKAction.run {
                //Animate button
                self.settingsBack.texture = self.settingsBack.defaultTexture
                self.settingsBack.size.height = 54
                
                //Remove all menus
                self.cam.enumerateChildNodes(withName: "overlay_menu") {
                    node, stop in
                    self.fadeAndRemove(node: node)
                }
                
                self.menuActive = false
                
                //Play button sound
                self.playSound(name: self.buttonCloseSound)
            }
            let sequence = SKAction.sequence([wait, removeSettingsMenu])
            self.run(sequence)
        }
        
        if acceptAdButton.isTouched {
            //Reset button to default state
            acceptAdButton.texture = acceptAdButton.defaultTexture
            acceptAdButton.size.height = 54
            
            //Remove the prompt from the screen
            removeRewardedAdPrompt()
            
            //Display the rewarded ad
            run(SKAction.sequence([SKAction.wait(forDuration: 0.2), SKAction.run(displayRewardedAd)]))
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            died = false
        }
        
        if cancelAdButton.isTouched {
            //Reset button to default state
            cancelAdButton.texture = cancelAdButton.defaultTexture
            cancelAdButton.size.height = 26
            
            //Remove the prompt from the screen
            removeRewardedAdPrompt()
            
            print("cancel rewarded ad")
            
            //Play button sound
            playSound(name: buttonCloseSound)
            
            died = false
        }
        
        if nextButton.isTouched {
            //Animate button
            nextButton.texture = nextButton.defaultTexture
            nextButton.size.height = 54
            
            //If tutorial is currently displaying page 1, create page 2
            if let _ = cam.childNode(withName:"tutorial_text1") {
                displayPage2()
            } else if let _ = cam.childNode(withName:"tutorial_text2") {
                displayPage3()
            } else if let _ = cam.childNode(withName:"tutorial_text3") {
                displayPage4()
            } else if let _ = cam.childNode(withName:"tutorial_text4") {
                displayPage5()
            } else if let _ = cam.childNode(withName:"tutorial_text5") {
                dismissTutorial()
            }
            
            //Play button sound
            playSound(name: buttonCloseSound)
        }
        
        //Reset every button's isTouched property to false
        resetAllButtons()
    }

    override func update(_ currentTime: TimeInterval) {
        if gameStarted == true {
            if died == false {
                //Update the currentPoint
                updateMap()
                
                //Adjust rotation of player according to their speed
                if player.currentRide == "skis" || player.currentRide == "snowtube" || player.currentRide == "snowboard" || player.currentRide == "hoverboard" {
                    player.zRotation = (player.physicsBody?.velocity.dx)!*0.0004
                    player.shadow.zRotation = -(player.physicsBody?.velocity.dx)!*0.0004
                    
                }
                if player.currentRide == "toboggan" || player.currentRide == "snowmobile" {
                    player.zRotation = (player.physicsBody?.velocity.dx)!*0.0002
                    player.shadow.zRotation = -(player.physicsBody?.velocity.dx)!*0.0002
                }

                //Move the player when the user touches the screen
                if isTouching {
                    var force = SKAction()
                    //Determine which way to move the player
                    if touchToggle {
                        force = SKAction.applyForce(CGVector(dx: playerTouchForce, dy: 0), duration: 0.15)
                    } else {
                        force = SKAction.applyForce(CGVector(dx: -playerTouchForce, dy: 0), duration: 0.15)
                    }
                    player.run(force)
                    
                    //Increase snow sound when user is touching the screen
                    snow.run(SKAction.changeVolume(to: 1.0, duration: 0.5))
                    
                } else {
                    //Return the snow sound to default when the user isn't touching the screen
                    snow.run(SKAction.changeVolume(to: 0.2, duration: 0.5))
                }
            }
        }
        
        //If a sprite leaves the scene, delete it
        world.enumerateChildNodes(withName: "*") {
            node, stop in
            if (node is SKSpriteNode) {
                let sprite = node as! SKSpriteNode
                //Set each node's velocity to the scene velocity
                if sprite.name != "player" && sprite.name != "tram" {
                    sprite.physicsBody?.velocity = self.currentSceneVelocity
                }
                
                //Set tram's velocity to their special velocity
                if sprite.name == "tram" {
                    sprite.physicsBody?.velocity.dy = self.currentSceneVelocity.dy * 1.07
                }
                
                // Check if the node is not in the scene
                if (sprite.position.x < (-self.size.width / 2) - (sprite.size.width / 2) ||
                    sprite.position.x > (self.size.width / 2) + (sprite.size.width / 2) ||
                    sprite.position.y < (-self.size.height / 2) - 600 ||
                    sprite.position.y > (self.size.height / 2) + (sprite.size.height * 2)) {
                    sprite.removeFromParent()
                    
                    //If the player goes off the scene, game over
                    if sprite.name == "player" {
                        //Play the crash sound and then run gameOver()
                        let runGameOver = SKAction.run {
                            self.gameOver(type: "crashed")
                        }
                        self.run(SKAction.sequence([SKAction.run {self.playSound(name: self.crashSound)}, SKAction.run {self.player.runCrashedAnimation()}, SKAction.run {self.player.removeParticleEmitters()}, runGameOver]))
                    }
                }
            }
        }
        
        //Game over if the player misses a goal
        world.enumerateChildNodes(withName: "goal") {
            node, stop in
            if (node is Goal) {
                let goal = node as! Goal
                
                //If a goal has passed the player without the player "passing" through it, game over
                if goal.position.y > self.player.position.y + 100 && !goal.passed {
                    //Mark the unpassed goal as passed to stop the loop
                    goal.passed = true
  
                    //Play the crash sound and then run gameOver()
                    let runGameOver = SKAction.run {
                        self.gameOver(type: "missed")
                    }
                    self.run(SKAction.sequence([SKAction.run {self.playSound(name: self.missedSound)}, SKAction.run {self.player.removeParticleEmitters()}, runGameOver]))
                }
            }
        }
        
        //Clamp the player's maximum velocity
        if (player.physicsBody!.velocity.dx > playerMaxSpeed) {
            player.physicsBody!.velocity.dx = playerMaxSpeed
        } else if (player.physicsBody!.velocity.dx < -playerMaxSpeed) {
            player.physicsBody!.velocity.dx = -playerMaxSpeed
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //set the firstBody to the node with the LOWER categoryBitMask
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //If a coin is spawned through a goal, remove it
        if firstBody.categoryBitMask == PhysicsCategory.goal && secondBody.categoryBitMask == PhysicsCategory.coin {
            secondBody.node?.removeFromParent()
            print("coin removed")
        }
        
        //if any two obstacles are spawned on top of each other, delete one
        if firstBody.categoryBitMask != PhysicsCategory.player && firstBody.categoryBitMask != PhysicsCategory.tram && secondBody.categoryBitMask != PhysicsCategory.tram {
            firstBody.node?.removeFromParent()
        }
        
        //If the player collides with any object, game over
        if firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask != PhysicsCategory.goal && secondBody.categoryBitMask != PhysicsCategory.coin {
            //Play the crash sound and then run gameOver()
            let runGameOver = SKAction.run {
                self.gameOver(type: "crashed")
            }
            self.run(SKAction.sequence([SKAction.run {self.playSound(name: self.crashSound)}, SKAction.run {self.player.runCrashedAnimation()}, SKAction.run {self.player.removeParticleEmitters()}, runGameOver]))
        }
        
        //If the player runs through a coin, increment coins
        if firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.coin {
            totalCoins += 1
            updateCoinsLabel()
            secondBody.node?.removeFromParent()
            
            //Save the coins
            UserDefaults.standard.set(totalCoins, forKey: "totalCoins")
            
            //Vibration effect if vibrations are turned on
            if vibrationEnabled {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            
            playSound(name: popSound)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //Set the firstBody to the node with the LOWER categoryBitMask
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //If the player runs through a goal, increment the score
        if firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.goal {
            score += 1
            updateScoreLabel()
            
            //Mark the goal as 'passed'
            if secondBody.node is Goal {
                let goal = secondBody.node as! Goal
                goal.passed = true
            }
            
            if score == 12 || score == 24 || score == 48 {
                level += 1
                setLevel()
            }
            
            //Vibration effect if vibrations are turned on
            if vibrationEnabled {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
            
            //Sound effect
            /* if soundEnabled {
                playSound(name: pulseSound)
            } */
            playSound(name: pulseSound)
        }
    }
    
    //Constrains the camera to follow the player without approaching the scene edges.
    func setCameraConstraints() {
        // Don't try to set up camera constraints if we don't yet have a camera.
        guard let camera = camera else { return }
        
        // Constrain the camera to stay a constant distance of 0 points from the player node.
        let zeroRange = SKRange(constantValue: 0.0)
        let playerBotLocationConstraint = SKConstraint.distance(zeroRange, to: player)
        
        /*
         Also constrain the camera to avoid it moving to the very edges of the scene.
         First, work out the scaled size of the scene. Its scaled height will always be
         the original height of the scene, but its scaled width will vary based on
         the window's current aspect ratio.
         */
        let scaledSize = CGSize(width: size.width * camera.xScale, height: size.height * camera.yScale)
        
        /*
         Find the root "board" node in the scene (the container node for
         the level's background tiles).
         */
        let boardNode = scene
        
        /*
         Calculate the accumulated frame of this node.
         The accumulated frame of a node is the outer bounds of all of the node's
         child nodes, i.e. the total size of the entire contents of the node.
         This gives us the bounding rectangle for the level's environment.
         */
        let boardContentRect = boardNode?.frame
        
        /*
         Work out how far within this rectangle to constrain the camera.
         We want to stop the camera when we get within 100pts of the edge of the screen,
         unless the level is so small that this inset would be outside of the level.
         */
        let xInset = min((scaledSize.width / 2) - (scaledSize.width/2 - UIScreen.main.bounds.width/2), boardContentRect!.width / 2)
        
        // Use these insets to create a smaller inset rectangle within which the camera must stay.
        let insetContentRect = boardContentRect!.insetBy(dx: xInset, dy: 0)
        
        // Define an `SKRange` for each of the x and y axes to stay within the inset rectangle.
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        
        // Constrain the camera within the inset rectangle.
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: SKRange(constantValue: 0))
        levelEdgeConstraint.referenceNode = boardNode
        
        /*
         Add both constraints to the camera. The scene edge constraint is added
         second, so that it takes precedence over following the `PlayerBot`.
         The result is that the camera will follow the player, unless this would mean
         moving too close to the edge of the level.
         */
        camera.constraints = [playerBotLocationConstraint, levelEdgeConstraint]
    }
    
    func addSnowEmitter(){
        if player.currentRide != "hoverboard" {
            if let snow = SKEmitterNode(fileNamed: "skier_snow") {
                snow.name = "snow"
                snow.zPosition = player.zPosition - 1
                
                if touchToggle {
                    snow.emissionAngle = 2.09
                    
                    if player.currentRide == "skis" || player.currentRide == "snowtube" || player.currentRide == "snowboard" {
                        snow.position = CGPoint(x: -5, y: -17)
                    }
                    if player.currentRide == "toboggan" {
                        snow.position = CGPoint(x: -6, y: -25)
                    }
                    if player.currentRide == "snowmobile" {
                        snow.position = CGPoint(x: -8, y: -23)
                    }
                    
                } else {
                    snow.emissionAngle = 1.05
                    
                    if player.currentRide == "skis" || player.currentRide == "snowtube" || player.currentRide == "snowboard" {
                        snow.position = CGPoint(x: 5, y: -17)
                    }
                    if player.currentRide == "toboggan" {
                        snow.position = CGPoint(x: 6, y: -25)
                    }
                    if player.currentRide == "snowmobile" {
                        snow.position = CGPoint(x: 8, y: -23)
                    }
                }
                
                let addEmitterAction = SKAction.run({self.player.addChild(snow)})
                let emitterDuration = CGFloat(snow.numParticlesToEmit) * snow.particleLifetime
                let wait = SKAction.wait(forDuration: TimeInterval(emitterDuration))
                let remove = SKAction.run({snow.removeFromParent()})
                let sequence = SKAction.sequence([addEmitterAction, wait, remove])
                self.run(sequence)
            }
        }
    }
    
    private func animatePlayerToPlayingPosition() {
        let wait = SKAction.wait(forDuration: 1.0)
        let activate = SKAction.run {
            self.playerCanMove = true
        }
        
        let sequence = SKAction.sequence([wait, activate])
        self.run(sequence)
        player.run(SKAction.moveTo(y: (self.frame.height / 2) - playerDefaultYInset, duration: 0.93))
    }
    
    private func startSpawningObstacles() {
        //Start spawning obstacles
        let spawnObstacleSequence = SKAction.sequence([SKAction.run(spawnObstacle), SKAction.run {self.zPositionCounter += 1}, SKAction.wait(forDuration: 0.05)])
        let spawnObstaclesForever = SKAction.repeatForever(spawnObstacleSequence)
        self.run(spawnObstaclesForever)
    }
    
    private func startSpawningGoals() {
        let spawnGoalSequence = SKAction.sequence([goalWait, SKAction.run(spawnGoal), SKAction.run {self.zPositionCounter += 2}])
        let spawnGoalsForever = SKAction.repeatForever(spawnGoalSequence)
        self.run(spawnGoalsForever, withKey: "spawnGoalsForever")
    }
    
    private func setLevel() {
        self.removeAction(forKey: "spawnGoalsForever")
        self.removeAction(forKey: "spawnTrams")

        switch level {
        //After 12 goals:
        case 1:
            goalWait = SKAction.wait(forDuration: 1.4)
            currentWidth = 130
            goalRotationMax = 45
        //24:
        case 2:
            goalWait = SKAction.wait(forDuration: 1.2)
            currentWidth = 120
            goalWidth = 95
            goalRotationMax = 60
        //48:
        case 3:
            goalWait = SKAction.wait(forDuration: 1.1)
            currentWidth = 110
            goalWidth = 90
            goalRotationMax = 75
        default:
            return
        }
        startSpawningGoals()
        spawnTrams()
    }
}
