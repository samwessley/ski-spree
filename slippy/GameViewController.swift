//
//  GameViewController.swift
//  slippy
//
//  Created by Sam Wessley on 9/22/18.
//  Copyright © 2018 Sam Wessley. All rights reserved.
//
// APP ID: ca-app-pub-0919661854292361~3485276950
// Banner ID: ca-app-pub-0919661854292361/1090568972
// Banner TEST ID: ca-app-pub-3940256099942544/2934735716
// Interstitial ID: ca-app-pub-0919661854292361/8455474556
// Interstitial TEST ID: ca-app-pub-3940256099942544/4411468910
// Rewarded Ad ID: ca-app-pub-0919661854292361/8001206656
// Rewarded Ad TEST ID: ca-app-pub-3940256099942544/1712485313

import UIKit
import SpriteKit
import GameKit
import GoogleMobileAds

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID = "com.eudeon.skispree.bestscore"
    
    var bannerAd: GADBannerView!
    var interstitial: GADInterstitial!
    var rewardedAd: GADRewardedAd?
        
    //Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Detect if it is the first launch of the app and then register default userdefaults values
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            //Register userdefaults values
            UserDefaults.standard.register(defaults: [
                "highScore": 0,
                "totalCoins": 0,
                "timesPlayed": 0,
                "musicEnabled": true,
                "soundEnabled": true,
                "vibrationEnabled": true,
                "tutorialDisplayed": false
                ])
            UserDefaults.standard.set(true, forKey: "musicEnabled")
            UserDefaults.standard.set(true, forKey: "soundEnabled")
            UserDefaults.standard.set(true, forKey: "vibrationEnabled")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(false, forKey: "tutorialDisplayed")
        }
        
        //Reset timesPlayed to 0
        UserDefaults.standard.set(0, forKey: "timesPlayed")
        
        //Set up the scene
        let scene = GameScene(size: CGSize(width: 600, height: 800))
        let skView = view as! SKView
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.showsPhysics = false
        
        //Call the GC authentication controller
        authenticateLocalPlayer()
        
        //Notification observer for sending the score to Game Center
        NotificationCenter.default.addObserver(self, selector: #selector(submitScoreToGameCenter(_:)), name: NSNotification.Name(rawValue: "sendScore"), object: nil)
        
        //Notification observer for opening Game Center
        NotificationCenter.default.addObserver(self, selector: #selector(openGameCenter(_:)), name: NSNotification.Name(rawValue: "openGameCenter"), object: nil)
        
        //Notification observer for presenting an interstitial ad
         NotificationCenter.default.addObserver(self, selector: #selector(presentInterstitial(_:)), name: NSNotification.Name(rawValue: "IntersititalNotification"), object: nil)
        
        //Notification observer for presenting a rewarded ad
         NotificationCenter.default.addObserver(self, selector: #selector(presentRewardedAd(_:)), name: NSNotification.Name(rawValue: "RewardedAdNotification"), object: nil)
        
        //present Google banner ad
        //presentBannerAd()
        
        //Get interstitial ad ready
        interstitial = createNewInterstitialAd()
        
        //Get rewarded ad ready
        rewardedAd = createAndLoadRewardedAd()
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
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
    
    func createAndLoadRewardedAd() -> GADRewardedAd {
      let rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-0919661854292361/8001206656")
      rewardedAd.load(GADRequest()) { error in
        if let error = error {
          print("Loading failed: \(error)")
        } else {
          print("Loading Succeeded")
        }
      }
      return rewardedAd
    }
    
    func presentBannerAd() {
        bannerAd = GADBannerView(adSize: kGADAdSizeBanner)
        
        if getScreenResolution() == 2 || getScreenResolution() == 1 {
            bannerAd.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 364, y: UIScreen.main.bounds.size.height - 120, width: 728, height: 90)
        } else {
            bannerAd.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 160, y: UIScreen.main.bounds.size.height - 90, width: 320, height: 50)
        }
        bannerAd.delegate = self
        bannerAd.adUnitID = "ca-app-pub-0919661854292361/1090568972"
        bannerAd.rootViewController = self
        bannerAd.load(GADRequest())
        view.addSubview(bannerAd)
    }
    
    func createNewInterstitialAd() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-0919661854292361/8455474556")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    @objc func presentInterstitial(_ notification: Notification) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        interstitial = createNewInterstitialAd()
    }
    
    @objc func presentRewardedAd(_ notification: Notification) {
        if rewardedAd?.isReady == true {
           rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
    
    @objc func openGameCenter(_ notification: Notification) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    @objc func submitScoreToGameCenter(_ notification: Notification) {
        guard let score = notification.userInfo?["score"] as? Int else { return }
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension GameViewController: GADBannerViewDelegate, GADRewardedAdDelegate, GADInterstitialDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("user earned reward for watching ad")
        
        //Post a notification to disburse reward for watching rewarded ad
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisburseRewardNotification"), object: nil)
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = createAndLoadRewardedAd()
        
        //Post a notification when rewarded ad is dismissed
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RewardedAdDismissedNotification"), object: nil)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("received ad")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("dismissed interstitial")
        //Post a notification when rewarded ad is dismissed
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RewardedAdDismissedNotification"), object: nil)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}
