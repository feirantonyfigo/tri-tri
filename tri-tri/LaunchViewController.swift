//
//  LaunchViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-15.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class LaunchViewController: UIViewController {

    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishvedio() {
        print("Video Finished")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        nextViewController.modalTransitionStyle = .crossDissolve
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func pauseVideo() {
        player.pause()
    }
    
    func continueVideo () {
    player.play()
    NotificationCenter.default.addObserver(self, selector: #selector(LaunchViewController.finishvedio), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func loadVideo() {
        //do {
        //    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        //} catch { }
        
        let videoPath = NSURL(fileURLWithPath:Bundle.main.path(forResource: "anim", ofType:"mp4")!)
        player  = AVPlayer(url: videoPath as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.seek(to: kCMTimeZero)
        player.play()
    NotificationCenter.default.addObserver(self, selector: #selector(LaunchViewController.pauseVideo), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(LaunchViewController.continueVideo), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(LaunchViewController.finishvedio), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

    
    
    
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
