//
//  GameOverViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-14.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Social
import AVKit
import AVFoundation
import EggRating
import SpriteKit
import StoreKit
import Social
import GameKit


class GameOverViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    //theme islocked array
    //if locked : true , unlocked : false
    var theme_islocked_array : Array<Bool> = []
    var wrong_player = AVAudioPlayer()
    var cash_player = AVAudioPlayer()
    
    var in_theme_menu = false
    
    var language = String()
    let home_pic = UIImage(named:"home")
    let night_home_pic = UIImage(named:"night mode home")
    let BW_home_pic = UIImage(named:"BW_home")
    let chaos_home_pic = UIImage(named:"chaos_home_icon")
    let school_home_pic = UIImage(named:"school_home-icon")
    let colors_home_pic = UIImage(named:"colors_home-icon")
    //final board image
    var final_board_image = UIImage()
    
    @IBOutlet var high_score_marker_icon: UIImageView!
    @IBOutlet weak var share_image_button: UIButton!

    @IBOutlet weak var share_image_scene: UIImageView!
    
    @IBOutlet weak var share_scene_score: UILabel!
    @IBOutlet weak var High_score_marker: UILabel!

    @IBOutlet weak var background_image: UIImageView!
    @IBOutlet weak var score_board: UILabel!
    
    @IBOutlet weak var gameover_title: UIImageView!
    
    @IBOutlet weak var trophy: UIImageView!
    var restart_player = AVAudioPlayer()
    var button_player = AVAudioPlayer()
    @IBOutlet weak var restart_button: UIButton!
    @IBOutlet weak var home_button: UIButton!
    
   
    @IBOutlet weak var like_button: UIButton!
    
    @IBOutlet weak var game_center_button: UIButton!

    @IBAction func Game_Center_Action(_ sender: UIButton) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }
        let game_center_controller = GKGameCenterViewController()
        game_center_controller.gameCenterDelegate = self
        self.present(game_center_controller, animated: true, completion: nil)

    }

    var screen_width : CGFloat = 0
    var screen_height : CGFloat = 0
    //two vars value passed from game board
    var final_score = String()
    var star_score = 0
    var is_high_score = Bool()
    
    //theme type
    var ThemeType = Int()
    
    func pause_screen_x_transform(_ x: Double) -> CGFloat {
        let const = x/Double(375)
        let new_x = Double(screen_width)*const
        return CGFloat(new_x)
        
    }
    func pause_screen_y_transform(_ y: Double) -> CGFloat {
        let const = y/Double(667)
        let new_y = Double(screen_height)*const
        return CGFloat(new_y)
    }

    var sound_is_muted = false
    
    
    //display final_board_image
    @IBOutlet weak var finalBoard: UIImageView!
    var share_scene_timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.high_score_marker_icon.contentMode = .scaleAspectFit
        if(defaults.value(forKey: "tritri_theme_lock_array") == nil){
            theme_islocked_array = [false,false,true,true,true]
            defaults.set(theme_islocked_array, forKey: "tritri_theme_lock_array")
        }else{
            theme_islocked_array = defaults.value(forKey: "tritri_theme_lock_array") as! Array<Bool>
        }
        
           finalBoard.image = final_board_image

        if (SKPaymentQueue.canMakePayments()){
            print ("In_app_purchase is enabled, loading")
            let productID : NSSet = NSSet(objects: "tritri.test.add_500_stars", "tritri.test.add_1000_stars")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPs")
        }
        language = defaults.value(forKey: "language") as! String
        screen_width = view.frame.width
        screen_height = view.frame.height
        gameover_title.frame = CGRect(x: pause_screen_x_transform(Double(gameover_title.frame.origin.x)), y: pause_screen_y_transform(Double(gameover_title.frame.origin.y)), width: pause_screen_x_transform(Double(gameover_title.frame.width)), height: pause_screen_y_transform(Double(gameover_title.frame.height)))
        game_center_button.frame = CGRect(x: pause_screen_x_transform(Double(game_center_button.frame.origin.x)), y: pause_screen_y_transform(Double(game_center_button.frame.origin.y)), width: pause_screen_x_transform(Double(game_center_button.frame.width)), height: pause_screen_y_transform(Double(game_center_button.frame.height)))
        restart_button.frame = CGRect(x: pause_screen_x_transform(Double(restart_button.frame.origin.x)), y: pause_screen_y_transform(Double(restart_button.frame.origin.y)), width: pause_screen_x_transform(Double(restart_button.frame.width)), height: pause_screen_y_transform(Double(restart_button.frame.height)))
        like_button.frame = CGRect(x: pause_screen_x_transform(Double(like_button.frame.origin.x)), y: pause_screen_y_transform(Double(like_button.frame.origin.y)), width: pause_screen_x_transform(Double(like_button.frame.width)), height: pause_screen_y_transform(Double(like_button.frame.height)))
        home_button.frame = CGRect(x: pause_screen_x_transform(Double(home_button.frame.origin.x)), y: pause_screen_y_transform(Double(home_button.frame.origin.y)), width: pause_screen_x_transform(Double(home_button.frame.width)), height: pause_screen_y_transform(Double(home_button.frame.height)))
        trophy.frame = CGRect(x: pause_screen_x_transform(Double(trophy.frame.origin.x)), y: pause_screen_y_transform(Double(trophy.frame.origin.y)), width: pause_screen_x_transform(Double(trophy.frame.width)), height: pause_screen_y_transform(Double(trophy.frame.height)))
        score_board.frame = CGRect(x: pause_screen_x_transform(Double(score_board.frame.origin.x)), y: pause_screen_y_transform(Double(score_board.frame.origin.y)), width: pause_screen_x_transform(Double(score_board.frame.width)), height: pause_screen_y_transform(Double(score_board.frame.height)))

        High_score_marker.frame = CGRect(x: pause_screen_x_transform(Double(High_score_marker.frame.origin.x)), y: pause_screen_y_transform(Double(High_score_marker.frame.origin.y)), width: pause_screen_x_transform(Double(High_score_marker.frame.width)), height: pause_screen_y_transform(Double(High_score_marker.frame.height)))
        finalBoard.frame = CGRect(x: pause_screen_x_transform(Double(finalBoard.frame.origin.x)), y: pause_screen_y_transform(Double(finalBoard.frame.origin.y))+screen_height/2.0, width: pause_screen_x_transform(Double(finalBoard.frame.width)), height: pause_screen_y_transform(Double(finalBoard.frame.height)))
        share_image_scene.frame = CGRect(x: pause_screen_x_transform(Double(share_image_scene.frame.origin.x)), y: pause_screen_y_transform(Double(share_image_scene.frame.origin.y))+screen_height/2.0, width: pause_screen_x_transform(Double(share_image_scene.frame.width)), height: pause_screen_y_transform(Double(share_image_scene.frame.height)))
        share_image_button.frame =  CGRect(x: pause_screen_x_transform(Double(share_image_button.frame.origin.x)), y: pause_screen_y_transform(Double(share_image_button.frame.origin.y))+screen_height/2.0, width: pause_screen_x_transform(Double(share_image_button.frame.width)), height: pause_screen_y_transform(Double(share_image_button.frame.height)))
        share_scene_score.frame = CGRect(x: pause_screen_x_transform(Double(share_scene_score.frame.origin.x)), y: pause_screen_y_transform(Double(share_scene_score.frame.origin.y))+screen_height/2.0, width: pause_screen_x_transform(Double(share_scene_score.frame.width)), height: pause_screen_y_transform(Double(share_scene_score.frame.height)))
        high_score_marker_icon.frame = CGRect(x: pause_screen_x_transform(Double(high_score_marker_icon.frame.origin.x)), y: pause_screen_y_transform(Double(high_score_marker_icon.frame.origin.y)), width: pause_screen_x_transform(Double(high_score_marker_icon.frame.width)), height: pause_screen_y_transform(Double(high_score_marker_icon.frame.height)))
        
        restart_button.touchAreaEdgeInsets = UIEdgeInsets(top: 0, left: pause_screen_x_transform(40), bottom: pause_screen_y_transform(40), right: pause_screen_x_transform(40))
        background_image.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
       
        if (self.language == "English") {
            self.share_image_outlet.setImage(UIImage(named:"share_button"), for: .normal)
        }
        else {
            self.share_image_outlet.setImage(UIImage(named:"share_button_ch"), for: .normal)

        }
        
        if (ThemeType == 1){
            home_button.setBackgroundImage(home_pic, for: .normal)
        } else if (ThemeType == 2){
            home_button.setBackgroundImage(night_home_pic, for: .normal)
        } else if(ThemeType == 3){
            home_button.setBackgroundImage(BW_home_pic, for: .normal)
        } else if(ThemeType == 4){
            home_button.setBackgroundImage(chaos_home_pic, for: .normal)
        } else if(ThemeType == 5){
            home_button.setBackgroundImage(school_home_pic, for: .normal)
        } else if(ThemeType == 6){
            home_button.setBackgroundImage(colors_home_pic, for: .normal)
        }
        home_button.touchAreaEdgeInsets = UIEdgeInsets(top: 0, left: pause_screen_x_transform(25), bottom: 0, right: pause_screen_x_transform(25))
        like_button.touchAreaEdgeInsets = UIEdgeInsets(top: 0, left: pause_screen_x_transform(25), bottom: 0, right: pause_screen_x_transform(25))
        game_center_button.touchAreaEdgeInsets = UIEdgeInsets(top: pause_screen_y_transform(10), left: pause_screen_x_transform(15), bottom: pause_screen_y_transform(0), right: pause_screen_x_transform(15))
        score_board.text = final_score
        share_scene_score.text = final_score
        do{restart_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "restart_soundeffect", ofType: "wav")!))
            restart_player.prepareToPlay()
        }
        catch{
            
        }
        if !is_high_score{
            
            high_score_marker_icon.removeFromSuperview()
        }
        if(defaults.value(forKey: "tritri_star_score") != nil ){
            star_score = defaults.value(forKey: "tritri_star_score") as! NSInteger
        }else{
            defaults.set(0, forKey: "tritri_star_score")
        }
        
        if (defaults.value(forKey: "tri_tri_sound_is_muted") == nil){
            sound_is_muted = false
            defaults.set(sound_is_muted, forKey: "tri_tri_sound_is_muted")
        }
        else {
            sound_is_muted = defaults.value(forKey: "tri_tri_sound_is_muted") as! Bool
        }
        
        // Do any additional setup after loading the view.
        gameover_title_image_decider()
        if ThemeType == 1{
            self.view.backgroundColor = UIColor(red: 254.0/255, green: 253.0/255, blue: 252.0/255, alpha: 1.0)
            background_image.alpha = 0
            self.trophy.image = #imageLiteral(resourceName: "day_mode_trophy")
            self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
            
            self.restart_button.setImage(UIImage(named:"restart_big"), for: .normal)
            self.like_button.setImage(#imageLiteral(resourceName: "day mode like"), for: .normal)
            self.game_center_button.setImage(#imageLiteral(resourceName: "day_leaderboard"), for: .normal)
        } else if ThemeType == 2{
            self.view.backgroundColor = UIColor(red: 23.0/255, green: 53.0/255, blue: 52.0/255, alpha: 1.0)
            background_image.alpha = 0
            self.trophy.image = #imageLiteral(resourceName: "night_mode_trophy")
            self.score_board.textColor = UIColor(red: 255.0/255, green: 254.0/255, blue: 243.0/255, alpha: 1.0)
            
            self.restart_button.setImage(UIImage(named:"restart_big"), for: .normal)
            self.like_button.setImage(#imageLiteral(resourceName: "night mode like"), for: .normal)
            self.game_center_button.setImage(#imageLiteral(resourceName: "day_leaderboard"), for: .normal)
        }else if ThemeType == 3{
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"BW_background")!)
            background_image.alpha = 1
            background_image.image = #imageLiteral(resourceName: "BW_background")
            self.trophy.image = #imageLiteral(resourceName: "BW_mode_trophy")
            self.score_board.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1.0)
            
            self.restart_button.setImage(UIImage(named:"BW_restart_version2"), for: .normal)
            self.like_button.setImage(#imageLiteral(resourceName: "BW_like"), for: .normal)
            self.game_center_button.setImage(#imageLiteral(resourceName: "BW_leaderboard"), for: .normal)
            //self.home_button.setImage(UIImage(named:"BW_home"), for: .normal)
            
        }else if ThemeType == 4{
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chaos_background")!)
            background_image.alpha = 1
            background_image.image = #imageLiteral(resourceName: "chaos_background")
            self.trophy.image = UIImage(named: "chaos_j_icon")
            self.score_board.textColor = UIColor(red: 236.0/255, green: 232.0/255, blue: 187.0/255, alpha: 1.0)
            
            self.restart_button.setImage(UIImage(named:"chaos_restart_big"), for: .normal)
            self.like_button.setImage(UIImage(named:"chaos_theme_button"), for: .normal)
            self.game_center_button.setImage(UIImage(named:"chaos_share_icon"), for: .normal)
            //self.home_button.setImage(UIImage(named:"BW_home"), for: .normal)
            
        }
        else if ThemeType == 5{
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "school_background")!)
            background_image.alpha = 1
            background_image.image = #imageLiteral(resourceName: "school_background")
            self.trophy.image = #imageLiteral(resourceName: "school_mode_trophy")
            self.score_board.textColor = UIColor(red: 40.0/255, green: 60.0/255, blue: 133.0/255, alpha: 1.0)
           
            self.restart_button.setImage(UIImage(named:"school_restart-big"), for: .normal)
            self.like_button.setImage(#imageLiteral(resourceName: "school_like-icon"), for: .normal)
            self.game_center_button.setImage(#imageLiteral(resourceName: "school_leaderboard"), for: .normal)
            //self.home_button.setImage(UIImage(named:"BW_home"), for: .normal)
            
        }
        else if ThemeType == 6{
           //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "colors_background")!)
            background_image.image = #imageLiteral(resourceName: "colors_background")
            background_image.alpha = 1
            self.trophy.image = #imageLiteral(resourceName: "colors_mode_trophy")
            self.score_board.textColor = UIColor(red: 79.0/255, green: 168.0/255, blue: 248.0/255, alpha: 1.0)
            
            self.restart_button.setImage(UIImage(named:"colors_restart-big"), for: .normal)
            self.like_button.setImage(#imageLiteral(resourceName: "colors_like-icon"), for: .normal)
            self.game_center_button.setImage(#imageLiteral(resourceName: "color_leaderboard"), for: .normal)
            
        }

        if (language == "English"){
            self.share_image_scene.image = #imageLiteral(resourceName: "image_share_scene")
        } else {
            self.share_image_scene.image = #imageLiteral(resourceName: "image_share_scene_Chinese")
        }
        share_image_scene.contentMode = .scaleAspectFit
        
        //change button location
        home_button.frame.origin.y -= screen_height/2.0
        restart_button.frame.origin.y -= screen_height/2.0
        game_center_button.frame.origin.y -= screen_height/2.0
        gameover_title.frame.origin.y -= screen_height/2.0
        like_button.frame.origin.y -= screen_height/2.0
        score_board.frame.origin.y -= screen_height/2.0
        high_score_marker_icon.frame.origin.y -= screen_height/2.0
        High_score_marker.frame.origin.y -= screen_height/2.0
        
        
        share_scene_timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameOverViewController.share_scene_bounce_in), userInfo: nil, repeats: false)
        //add pangesture
        //et panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        //self.view.addGestureRecognizer(panGestureRecognizer)
    }

    func share_scene_bounce_in() {
        //share image scene bounce in
        share_image_button.frame.origin.y -= screen_height/2.0
        share_image_scene.frame.origin.y -= screen_height/2.0
        finalBoard.frame.origin.y -= screen_height/2.0
         share_scene_score.frame.origin.y -= screen_height/2.0
        
        share_image_button.transform = CGAffineTransform(translationX: 0, y: screen_height/2.0)
        share_image_scene.transform = CGAffineTransform(translationX: 0, y: screen_height/2.0)
        finalBoard.transform = CGAffineTransform(translationX: 0, y: screen_height/2.0)
        share_scene_score.transform = CGAffineTransform(translationX: 0, y: screen_height/2.0)
        UIView.animate(withDuration: 0.7, delay: 00, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: .curveLinear, animations: {
            self.share_image_button.transform = .identity
            self.share_image_scene.transform = .identity
            self.finalBoard.transform = .identity
            self.share_scene_score.transform = .identity
        }, completion: nil)
        
        //buttons bounce in
        
        home_button.frame.origin.y += screen_height/2.0
        restart_button.frame.origin.y += screen_height/2.0
        game_center_button.frame.origin.y += screen_height/2.0
        gameover_title.frame.origin.y += screen_height/2.0
        like_button.frame.origin.y += screen_height/2.0
        score_board.frame.origin.y += screen_height/2.0
        high_score_marker_icon.frame.origin.y += screen_height/2.0
        High_score_marker.frame.origin.y += screen_height/2.0
        
        
        
        home_button.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        restart_button.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        game_center_button.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        gameover_title.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        like_button.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        score_board.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        high_score_marker_icon.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        High_score_marker.transform = CGAffineTransform(translationX: 0, y: -screen_height/2.0)
        UIView.animate(withDuration: 0.7, delay: 00, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: .curveLinear, animations: {
            self.home_button.transform = .identity
            self.restart_button.transform = .identity
            self.game_center_button.transform = .identity
            self.gameover_title.transform = .identity
            self.like_button.transform = .identity
            self.score_board.transform = .identity
            self.high_score_marker_icon.transform = .identity
            self.High_score_marker.transform = .identity
            
        }, completion: nil)
        
        
        
        share_scene_timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(service: String){
        let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Restart_Sound_Action(_ sender: UIButton) {
        
        defaults.set([true,true,true], forKey: "tritri_exist_array")
        defaults.removeObject(forKey: "tritri_shape_type_index")
        if(!sound_is_muted){
       restart_player.play()
        }
        
    }
    
      @IBAction func home_button_action(_ sender: UIButton) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }
    }
    
    //origin
    var day_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var night_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var BW_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var chaos_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var school_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var colors_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var theme_star_counter = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var theme_star_board = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    
    var day_theme_origin = CGPoint(x: 0, y: 0)
    var night_theme_origin = CGPoint(x: 0, y: 0)
    var BW_theme_origin = CGPoint(x: 0, y: 0)
    var chaos_theme_origin = CGPoint(x: 0, y: 0)
    var school_theme_origin = CGPoint(x: 0, y: 0)
    var colors_theme_origin = CGPoint(x: 0, y: 0)
    
    var day_apply_button = MyButton()
    var night_apply_button = MyButton()
    var BW_apply_button = MyButton()
    var school_apply_button = MyButton()
    var colors_apply_button = MyButton()
    var day_apply_origin = CGPoint()
    var night_apply_origin = CGPoint()
    var BW_apply_origin = CGPoint()
    var school_apply_origin = CGPoint()
    var colors_apply_origin = CGPoint()
    
    var white_cover_y = CGFloat(0)
    var theme_button_height = CGFloat(0)
    
    var theme_menu = UIScrollView()
    
    var white_cover = UIView()
    
    var theme_menu_star_store_button = MyButton()
    /**
    @IBAction func theme_menu_action(_ sender: UIButton) {
        if(!in_theme_menu){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            in_theme_menu = true
        theme_menu = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y:0),size: CGSize(width: screen_width, height: screen_height)))
        theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
        theme_menu.alpha = 0
        theme_menu.tag = 100
        super.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(theme_menu)
        theme_menu.fadeIn()
        white_cover = UIView(frame: CGRect(x: pause_screen_x_transform(0), y: pause_screen_y_transform(0), width: pause_screen_x_transform(400), height: pause_screen_y_transform(53)))
        let triangle_text = UIImageView(frame: CGRect(x: pause_screen_x_transform(110), y: pause_screen_y_transform(15), width: pause_screen_x_transform(155), height: pause_screen_y_transform(35)))
        white_cover_y = white_cover.frame.origin.y + white_cover.frame.height
        theme_star_counter = UIImageView(frame: CGRect(x:pause_screen_x_transform(255), y:pause_screen_y_transform(12),width: pause_screen_x_transform(102), height: pause_screen_y_transform(38)))
        theme_star_board = UILabel(frame: CGRect(x:pause_screen_x_transform(285),y:pause_screen_y_transform(15),width: pause_screen_x_transform(80),height:pause_screen_y_transform(30)))
        theme_button_height = (screen_height - white_cover_y)/3.0
        let return_button = MyButton(frame: CGRect(x: pause_screen_x_transform(20), y: pause_screen_y_transform(15), width: pause_screen_x_transform(30), height: pause_screen_y_transform(30)))
        //add buttons
        day_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y: white_cover.frame.origin.y + white_cover.frame.height, width: screen_width, height: theme_button_height))
        day_theme_origin = day_theme_button.frame.origin
        day_theme_button.image = #imageLiteral(resourceName: "day_mode_theme_menu_button")
        day_apply_button.contentMode = .scaleAspectFit
        day_theme_button.alpha = 0
        day_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: day_theme_button.frame.origin.y + day_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        day_apply_button.setImage(#imageLiteral(resourceName: "day_mode_use"), for: .normal)
        
        if(ThemeType == 1){
            day_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            day_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            day_apply_button.setImage( #imageLiteral(resourceName: "day_selected"), for: .normal)
        }
        day_apply_origin = day_apply_button.frame.origin
        day_apply_button.whenButtonIsClicked(action:{
            if(self.ThemeType != 1){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            
            self.ThemeType = 1
            defaults.set(1, forKey:"tritri_Theme")
            self.view.backgroundColor = UIColor(red: 254.0/255, green: 253.0/255, blue: 252.0/255, alpha: 1.0)
            self.background_image.alpha = 0
            self.trophy.image = #imageLiteral(resourceName: "day_mode_trophy")
            self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
            self.gameover_title_image_decider()
            self.home_button.setBackgroundImage(self.home_pic, for: .normal)
            self.restart_button.setImage(UIImage(named:"restart_big"), for: .normal)
            self.shopping_button.setImage(UIImage(named:"shopping_cart"), for: .normal)
            self.game_center_button.setImage(UIImage(named:"link"), for: .normal)
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
            self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
            self.theme_star_board.textColor = UIColor(red: 46.0/255, green: 62.0/255, blue: 59.0/255, alpha: 1.0)
  
                self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y:  self.screen_height, final_completetion: {
                    
                    self.day_apply_button.removeFromSuperview()
                    self.night_apply_button.removeFromSuperview()
                    self.BW_apply_button.removeFromSuperview()
                    self.school_apply_button.removeFromSuperview()
                    self.colors_apply_button.removeFromSuperview()
                    
                    self.day_theme_button.removeFromSuperview()
                    self.night_theme_button.removeFromSuperview()
                    self.BW_theme_button.removeFromSuperview()
                    self.chaos_theme_button.removeFromSuperview()
                    self.school_theme_button.removeFromSuperview()
                    self.colors_theme_button.removeFromSuperview()
                    self.in_theme_menu = false
                    
                })
                self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                    self.theme_star_counter.fadeOutandRemove()
                    self.theme_star_board.fadeOutandRemove()
                    triangle_text.fadeOutandRemove()
                    return_button.fadeOutandRemove()
                    self.remove_all_theme_star_counter_fragments()
                })
            }else{
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
            }
        })
        
        theme_menu.addSubview(day_theme_button)
        day_theme_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(day_apply_button)
        day_apply_button.fadeInWithDisplacement()
        
        
        night_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y:day_theme_button.frame.origin.y + day_theme_button.frame.height, width: screen_width, height: theme_button_height))
        night_theme_origin = night_theme_button.frame.origin
        night_theme_button.image = #imageLiteral(resourceName: "night_mode_theme_menu_button")
        night_theme_button.contentMode = .scaleAspectFill
        night_theme_button.alpha = 0
        night_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: night_theme_button.frame.origin.y + night_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        night_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
        
        //night_apply_origin = night_apply_button.frame.origin
        if(ThemeType == 2){
            night_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            night_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            night_apply_button.setImage( #imageLiteral(resourceName: "night_selected"), for: .normal)
        }
        night_apply_origin = night_apply_button.frame.origin
        
        night_apply_button.whenButtonIsClicked(action:{
            if(self.ThemeType != 2){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            
            self.ThemeType = 2
            defaults.set(2, forKey:"tritri_Theme")
            self.view.backgroundColor = UIColor(red: 23.0/255, green: 53.0/255, blue: 52.0/255, alpha: 1.0)
            self.background_image.alpha = 0
            self.trophy.image = #imageLiteral(resourceName: "night_mode_trophy")
            self.score_board.textColor = UIColor(red: 255.0/255, green: 254.0/255, blue: 243.0/255, alpha: 1.0)
            self.gameover_title_image_decider()
            self.home_button.setBackgroundImage(self.night_home_pic, for: .normal)
            self.restart_button.setImage(UIImage(named:"restart_big"), for: .normal)
            self.shopping_button.setImage(UIImage(named:"shopping_cart"), for: .normal)
            self.game_center_button.setImage(UIImage(named:"link"), for: .normal)
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
            self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
            self.theme_star_board.textColor = UIColor.black

                self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y:  self.screen_height, final_completetion: {
                    
                    self.day_apply_button.removeFromSuperview()
                    self.night_apply_button.removeFromSuperview()
                    self.BW_apply_button.removeFromSuperview()
                    self.school_apply_button.removeFromSuperview()
                    self.colors_apply_button.removeFromSuperview()
                    
                    self.day_theme_button.removeFromSuperview()
                    self.night_theme_button.removeFromSuperview()
                    self.BW_theme_button.removeFromSuperview()
                    self.chaos_theme_button.removeFromSuperview()
                    self.school_theme_button.removeFromSuperview()
                    self.colors_theme_button.removeFromSuperview()
                    self.in_theme_menu = false
                    
                })
                self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                    self.theme_star_counter.fadeOutandRemove()
                    self.theme_star_board.fadeOutandRemove()
                    triangle_text.fadeOutandRemove()
                    return_button.fadeOutandRemove()
                    self.remove_all_theme_star_counter_fragments()
                })
            }else{
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
   
            }
        })
        theme_menu.addSubview(night_theme_button)
        night_theme_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(night_apply_button)
        night_apply_button.fadeInWithDisplacement()
        
        
        BW_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y: night_theme_button.frame.origin.y + night_theme_button.frame.height, width: screen_width, height: theme_button_height))
        BW_theme_origin = BW_theme_button.frame.origin
        BW_theme_button.image = #imageLiteral(resourceName: "BW_theme_menu_button")
        BW_theme_button.contentMode = .scaleAspectFill
        BW_theme_button.alpha = 0
        BW_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: BW_theme_button.frame.origin.y + BW_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        if(theme_islocked_array[2]){
            BW_apply_button.frame.origin.x -= pause_screen_x_transform(7)
            BW_apply_button.frame.size = CGSize(width: pause_screen_x_transform(114), height: pause_screen_y_transform(36))
            BW_apply_button.setImage(#imageLiteral(resourceName: "BW_price"), for: .normal)
        }else if(ThemeType == 3){
            BW_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            BW_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            BW_apply_button.setImage(#imageLiteral(resourceName: "BW_selected"), for: .normal)
        }
        else{
            BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
        }
        BW_apply_origin = BW_apply_button.frame.origin
        BW_apply_button.whenButtonIsClicked(action:{
            if(self.theme_islocked_array[2]){
                if(self.star_score >= 2000){
                    do{self.cash_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cash_register", ofType: "wav")!))
                        self.cash_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.cash_player.play()
                    self.star_score -= 2000
                    defaults.set(self.star_score, forKey: "tritri_star_score")
                    self.theme_star_board.text = String(self.star_score)
                    self.theme_islocked_array[2] = false
                    defaults.set(self.theme_islocked_array, forKey: "tritri_theme_lock_array")
                    self.BW_apply_button.frame = CGRect(x: self.screen_width - self.pause_screen_y_transform(130), y: self.BW_theme_button.frame.origin.y + self.BW_theme_button.frame.height/2.0 - self.pause_screen_y_transform(18), width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                    self.BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
                }else{
                    do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                        self.wrong_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.wrong_player.play()
                }
    
                
                
            }else if(self.ThemeType != 3){
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
                self.ThemeType = 3
                defaults.set(3, forKey:"tritri_Theme")
                //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"BW_background")!)
                self.background_image.alpha = 1
                self.background_image.image = #imageLiteral(resourceName: "BW_background")
                self.trophy.image = #imageLiteral(resourceName: "BW_mode_trophy")
                self.gameover_title_image_decider()
                self.score_board.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1)
                self.shopping_button.setImage(UIImage(named:"BW_shopping"), for: .normal)
                self.restart_button.setImage(UIImage(named:"BW_restart_version2"), for: .normal)
                self.game_center_button.setImage(UIImage(named:"BW_share"), for: .normal)
                self.home_button.setBackgroundImage(self.BW_home_pic, for: .normal)
                self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
                self.theme_star_board.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1.0)
                //self.trophy.image = UIImage(named:"trophy_new")
                //self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
                // self.gameover_title.image = UIImage(named:"day mode gameover title")
                self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))

                
                self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y:  self.screen_height, final_completetion: {
                    
                    self.day_apply_button.removeFromSuperview()
                    self.night_apply_button.removeFromSuperview()
                    self.BW_apply_button.removeFromSuperview()
                    self.school_apply_button.removeFromSuperview()
                    self.colors_apply_button.removeFromSuperview()
                    
                    self.day_theme_button.removeFromSuperview()
                    self.night_theme_button.removeFromSuperview()
                    self.BW_theme_button.removeFromSuperview()
                    self.chaos_theme_button.removeFromSuperview()
                    self.school_theme_button.removeFromSuperview()
                    self.colors_theme_button.removeFromSuperview()
                    self.in_theme_menu = false
                    
                })
                self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                    self.theme_star_counter.fadeOutandRemove()
                    self.theme_star_board.fadeOutandRemove()
                    triangle_text.fadeOutandRemove()
                    return_button.fadeOutandRemove()
                    self.remove_all_theme_star_counter_fragments()
                })
            }else{
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
   
            }
            
            

            
            
            
            
            
            
        })
        theme_menu.addSubview(BW_theme_button)
        BW_theme_button.fadeInWithDisplacement()
        theme_menu.addSubview(BW_apply_button)
        BW_apply_button.fadeInWithDisplacement()
        
        
        
       /** chaos_theme_button = MyButton(frame: CGRect(x: pause_screen_x_transform(206), y: pause_screen_y_transform(319), width: pause_screen_x_transform(144), height: pause_screen_y_transform(144)))
        chaos_theme_origin = chaos_theme_button.frame.origin
        chaos_theme_button.setBackgroundImage(UIImage(named:"Chaos_theme"), for: .normal)
        chaos_theme_button.alpha = 0
        chaos_theme_button.whenButtonIsClicked(action:{
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            
            self.ThemeType = 4
            defaults.set(4, forKey:"tritri_Theme")
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chaos_background")!)
            self.background_image.alpha = 1
            self.background_image.image = #imageLiteral(resourceName: "chaos_background")
            self.trophy.image = UIImage(named:"chaos_j_icon")
            self.gameover_title.image = UIImage(named: "night mode gameover title")
            self.score_board.textColor = UIColor(red: 236.0/255, green: 232.0/255, blue: 187.0/255, alpha: 1.0)
            self.restart_button.setImage(UIImage(named:"chaos_restart_big"), for: .normal)
            self.shopping_button.setImage(UIImage(named:"chaos_theme_button"), for: .normal)
            self.share_button.setImage(UIImage(named:"chaos_share_icon"), for: .normal)
            self.home_button.setBackgroundImage(self.chaos_home_pic, for: .normal)
            
            //self.trophy.image = UIImage(named:"trophy_new")
            //self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
            // self.gameover_title.image = UIImage(named:"day mode gameover title")
            theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(0))
            
            self.day_theme_button.fadeOut()
            self.night_theme_button.fadeOut()
            self.BW_theme_button.fadeOut()
            self.chaos_theme_button.fadeOut()
            self.school_theme_button.fadeOut()
            self.colors_theme_button.fadeOut()
            triangle_text.fadeOut()
            return_button.fadeOut()
            white_cover.fadeOut()
            theme_menu.fadeOut()
            
            self.day_theme_button.removeFromSuperview()
            self.night_theme_button.removeFromSuperview()
            self.BW_theme_button.removeFromSuperview()
            self.chaos_theme_button.removeFromSuperview()
            self.school_theme_button.removeFromSuperview()
            self.colors_theme_button.removeFromSuperview()
            triangle_text.removeFromSuperview()
            return_button.removeFromSuperview()
            white_cover.removeFromSuperview()
            theme_menu.removeFromSuperview()
            self.theme_star_counter.removeFromSuperview()
            self.theme_star_board.removeFromSuperview()
            
        })
        //self.view.addSubview(chaos_theme_button)
        //chaos_theme_button.fadeInWithDisplacement()
        **/
        
        school_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y: BW_theme_button.frame.origin.y + BW_theme_button.frame.height, width: screen_width, height: theme_button_height))
        school_theme_origin = school_theme_button.frame.origin
        school_theme_button.image = #imageLiteral(resourceName: "school_mode_theme_menu_button")
        school_theme_button.contentMode = .scaleAspectFit
        school_theme_button.alpha = 0
        school_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: school_theme_button.frame.origin.y + school_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        if(theme_islocked_array[3]){
            school_apply_button.frame.origin.x -= pause_screen_x_transform(7)
            school_apply_button.frame.size = CGSize(width: pause_screen_x_transform(114), height: pause_screen_y_transform(36))
            school_apply_button.setImage(#imageLiteral(resourceName: "school_price"), for: .normal)
        }else if(ThemeType == 5){
            school_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            school_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            school_apply_button.setImage(#imageLiteral(resourceName: "school_selected"), for: .normal)
        }
        else{
            school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use"), for: .normal)
        }
        
        school_apply_origin = school_apply_button.frame.origin
        school_apply_button.whenButtonIsClicked(action:{
            if(self.theme_islocked_array[3]){
                if(self.star_score >= 1000){
                    do{self.cash_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cash_register", ofType: "wav")!))
                        self.cash_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.cash_player.play()
                    self.star_score -= 1000
                    defaults.set(self.star_score, forKey: "tritri_star_score")
                    self.theme_star_board.text = String(self.star_score)
                    self.theme_islocked_array[3] = false
                    self.school_apply_button.frame = CGRect(x: self.screen_width - self.pause_screen_y_transform(130), y: self.school_theme_button.frame.origin.y + self.school_theme_button.frame.height/2.0 - self.pause_screen_y_transform(18), width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                    self.school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use"), for: .normal)
                    
                    defaults.set(self.theme_islocked_array, forKey: "tritri_theme_lock_array")
                }else{
                    do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                        self.wrong_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.wrong_player.play()
                }
                
                
                
            
            }else if(self.ThemeType != 5){
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
                self.ThemeType = 5
                defaults.set(5, forKey:"tritri_Theme")
                //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "school_background")!)
                self.background_image.alpha = 1
                self.background_image.image = #imageLiteral(resourceName: "school_background")
                self.trophy.image = #imageLiteral(resourceName: "school_mode_trophy")
                self.gameover_title_image_decider()
                self.score_board.textColor = UIColor(red: 113.0/255, green: 113.0/255, blue: 142.0/255, alpha: 1.0)
                self.restart_button.setImage(UIImage(named:"school_restart-big"), for: .normal)
                self.shopping_button.setImage(UIImage(named:"school_theme-button"), for: .normal)
                self.game_center_button.setImage(UIImage(named:"school_share-icon"), for: .normal)
                self.home_button.setBackgroundImage(self.school_home_pic, for: .normal)
                self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
                self.theme_star_board.textColor = UIColor(red: 68.0/255, green: 84.0/255, blue: 140.0/255, alpha: 1.0)
                
                self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))

                self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y:  self.screen_height, final_completetion: {
                    
                    self.day_apply_button.removeFromSuperview()
                    self.night_apply_button.removeFromSuperview()
                    self.BW_apply_button.removeFromSuperview()
                    self.school_apply_button.removeFromSuperview()
                    self.colors_apply_button.removeFromSuperview()
                    
                    self.day_theme_button.removeFromSuperview()
                    self.night_theme_button.removeFromSuperview()
                    self.BW_theme_button.removeFromSuperview()
                    self.chaos_theme_button.removeFromSuperview()
                    self.school_theme_button.removeFromSuperview()
                    self.colors_theme_button.removeFromSuperview()
                    self.in_theme_menu = false
                    
                })
                self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                    self.theme_star_counter.fadeOutandRemove()
                    self.theme_star_board.fadeOutandRemove()
                    triangle_text.fadeOutandRemove()
                    return_button.fadeOutandRemove()
                    self.remove_all_theme_star_counter_fragments()
                })
                
            }else{
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
            }
        })
        theme_menu.addSubview(school_theme_button)
        school_theme_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(school_apply_button)
        school_apply_button.fadeInWithDisplacement()
        
        colors_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y: school_theme_button.frame.origin.y + school_theme_button.frame.height, width: screen_width, height: theme_button_height))
        colors_theme_origin = colors_theme_button.frame.origin
        colors_theme_button.image = #imageLiteral(resourceName: "colors_theme_menu_button")
        colors_theme_button.contentMode = .scaleAspectFit
        colors_theme_button.alpha = 0
        colors_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: colors_theme_button.frame.origin.y + colors_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        if(theme_islocked_array[4]){
            colors_apply_button.frame.origin.x -= pause_screen_x_transform(7)
            colors_apply_button.frame.size = CGSize(width: pause_screen_x_transform(114), height: pause_screen_y_transform(36))
            
            colors_apply_button.setImage(#imageLiteral(resourceName: "colors_price"), for: .normal)
        }else if(ThemeType == 6){
            colors_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            colors_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            colors_apply_button.setImage(#imageLiteral(resourceName: "colors_selected"), for: .normal)
        }
        else{
            colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
        }
        
        
        colors_apply_origin = colors_apply_button.frame.origin
        colors_apply_button.whenButtonIsClicked(action:{
           
            if(self.theme_islocked_array[4]){
                if(self.star_score >= 1000){
                    do{self.cash_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cash_register", ofType: "wav")!))
                        self.cash_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.cash_player.play()
                    self.star_score -= 1000
                    defaults.set(self.star_score, forKey: "tritri_star_score")
                    self.theme_star_board.text = String(self.star_score)
                    self.theme_islocked_array[4] = false
                    defaults.set(self.theme_islocked_array, forKey: "tritri_theme_lock_array")
                    self.colors_apply_button.frame = CGRect(x: self.screen_width - self.pause_screen_y_transform(130), y: self.colors_theme_button.frame.origin.y + self.colors_theme_button.frame.height/2.0 - self.pause_screen_y_transform(18), width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                    self.colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
                }else{
                    do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                        self.wrong_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.wrong_player.play()
                }
                
   
                
            }else if(self.ThemeType != 6){
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
                self.ThemeType = 6
                defaults.set(6, forKey:"tritri_Theme")
                //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "colors_background")!)
                self.background_image.alpha = 1
                self.background_image.image = #imageLiteral(resourceName: "colors_background")
                self.trophy.image = #imageLiteral(resourceName: "colors_mode_trophy")
                self.gameover_title_image_decider()
                self.score_board.textColor = UIColor(red: 79.0/255, green: 168.0/255, blue: 248.0/255, alpha: 1.00)
                self.restart_button.setImage(UIImage(named:"colors_restart-big"), for: .normal)
                self.shopping_button.setImage(UIImage(named:"colors_theme-button"), for: .normal)
                self.game_center_button.setImage(UIImage(named:"colors_share-icon"), for: .normal)
                self.home_button.setBackgroundImage(self.colors_home_pic, for: .normal)
                self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
                self.theme_star_board.textColor = UIColor(red: 81.0/255, green: 195.0/255, blue: 247.0/255, alpha: 1.0)
                //self.trophy.image = UIImage(named:"trophy_new")
                //self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
                // self.gameover_title.image = UIImage(named:"day mode gameover title")
                self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))

                self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y:  self.screen_height, final_completetion: {
                    
                    self.day_apply_button.removeFromSuperview()
                    self.night_apply_button.removeFromSuperview()
                    self.BW_apply_button.removeFromSuperview()
                    self.school_apply_button.removeFromSuperview()
                    self.colors_apply_button.removeFromSuperview()
                    
                    self.day_theme_button.removeFromSuperview()
                    self.night_theme_button.removeFromSuperview()
                    self.BW_theme_button.removeFromSuperview()
                    self.chaos_theme_button.removeFromSuperview()
                    self.school_theme_button.removeFromSuperview()
                    self.colors_theme_button.removeFromSuperview()
                    self.in_theme_menu = false
                    
                })
                self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                    self.theme_star_counter.fadeOutandRemove()
                    self.theme_star_board.fadeOutandRemove()
                    triangle_text.fadeOutandRemove()
                    return_button.fadeOutandRemove()
                    self.remove_all_theme_star_counter_fragments()
                })
            }else{
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
            }
            
           
            
            
            
            
            
        })
        
        theme_menu.addSubview(colors_theme_button)
        colors_theme_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(colors_apply_button)
        colors_apply_button.fadeInWithDisplacement()
        
        //add white to 遮挡
        
        white_cover.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
        white_cover.alpha = 0
        self.view.addSubview(white_cover)
        white_cover.fadeInWithDisplacement()
        
        
        //add triangle text
        if (self.language == "English"){
            triangle_text.frame = CGRect(x: pause_screen_x_transform(127), y: pause_screen_y_transform(15), width: pause_screen_x_transform(120), height: pause_screen_y_transform(29.35))
            triangle_text.image = UIImage(named: "day mode triangle title")
        }
        else {
            triangle_text.frame = CGRect(x: pause_screen_x_transform(110), y: pause_screen_y_transform(15), width: pause_screen_x_transform(155), height: pause_screen_y_transform(35))
            triangle_text.image = UIImage(named: "san_title_day")
        }
        triangle_text.contentMode = .scaleAspectFit
        //triangle_text.sizeToFit()
        triangle_text.alpha = 0
        white_cover.addSubview(triangle_text)
        triangle_text.fadeIn()
        
        //add star_counter in theme menu
        theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
        
        theme_star_counter.alpha = 1
        
        //theme_star_counter.fadeInWithDisplacement()
        
        
        
        //add text
        theme_star_board.font = UIFont(name: "Helvetica", size: CGFloat(17))
        theme_star_board.text = String(star_score)
        theme_star_board.textAlignment = .center
        if(ThemeType == 1){
            theme_star_board.textColor = UIColor(red: 46.0/255, green: 62.0/255, blue: 59.0/255, alpha: 1.0)
        }else if(ThemeType == 2){
            theme_star_board.textColor = UIColor.black
        }else if(ThemeType == 3){
            theme_star_board.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1.0)
        }else if(ThemeType == 5){
            theme_star_board.textColor = UIColor(red: 68.0/255, green: 84.0/255, blue: 140.0/255, alpha: 1.0)
        }else if(ThemeType == 6){
            theme_star_board.textColor = UIColor(red: 81.0/255, green: 195.0/255, blue: 247.0/255, alpha: 1.0)
        }
        theme_star_board.alpha = 0
        white_cover.addSubview(theme_star_board)
        theme_star_board.fadeIn()
        
        theme_star_board_width = theme_star_board.frame.width
        split_theme_star_counter()
         theme_menu_star_store_button.frame = theme_star_counter.frame
        update_theme_star_length_according_to_string_length()
            
        //add theme star store button
         theme_menu_star_store_button.setImage(#imageLiteral(resourceName: "current_star_total"), for: .normal)
         theme_menu_star_store_button.alpha = 0.02
         self.view.addSubview(theme_menu_star_store_button)
         self.view.bringSubview(toFront: theme_menu_star_store_button)
        //theme_menu_star_store_button action
            theme_menu_star_store_button.whenButtonIsClicked(action: {
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
                
                
                
                
                self.purchase_star_function()
                
               
                
                
                
                
                
            })
            
            
        white_cover.addSubview(theme_star_counter)
        theme_star_counter.alpha = 0
        
        //add  return button
        
        return_button.setBackgroundImage(UIImage(named:"return_button"), for: .normal)
        
        
        return_button.whenButtonIsClicked(action: {
            
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))

            self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y:  self.screen_height, final_completetion: {
                
                self.day_apply_button.removeFromSuperview()
                self.night_apply_button.removeFromSuperview()
                self.BW_apply_button.removeFromSuperview()
                self.school_apply_button.removeFromSuperview()
                self.colors_apply_button.removeFromSuperview()
                
                self.day_theme_button.removeFromSuperview()
                self.night_theme_button.removeFromSuperview()
                self.BW_theme_button.removeFromSuperview()
                self.chaos_theme_button.removeFromSuperview()
                self.school_theme_button.removeFromSuperview()
                self.colors_theme_button.removeFromSuperview()
                self.in_theme_menu = false
                
            })
            self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                self.theme_star_counter.fadeOutandRemove()
                self.theme_star_board.fadeOutandRemove()
                triangle_text.fadeOutandRemove()
                return_button.fadeOutandRemove()
                self.remove_all_theme_star_counter_fragments()
            })
            
        })
        
        return_button.alpha = 0
       white_cover.addSubview(return_button)
        return_button.fadeIn()
        theme_menu.contentSize.height = colors_theme_button.frame.origin.y + theme_button_height
        theme_menu.showsVerticalScrollIndicator = false
        
            
            //bounce in
            theme_menu.transform = CGAffineTransform(translationX: 0, y: screen_height)
            UIView.animate(withDuration: 0.7, delay: 00, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
                self.theme_menu.transform = .identity
            }, completion: nil)
            
            
        }
    }
    **/
    
    
    func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer){
        let transition0 = gesture.translation(in: day_theme_button)
        //上1/3和下1/3的空间
        if(day_theme_button.frame.origin.y < (white_cover_y+day_theme_button.frame.height/3.5) && colors_theme_button.frame.origin.y > pause_screen_y_transform(493+144) - colors_theme_button.frame.height/3 - colors_theme_button.frame.height){
            day_theme_button.frame.origin = CGPoint(x: day_theme_origin.x, y: (day_theme_origin.y + transition0.y))
            night_theme_button.frame.origin = CGPoint(x: night_theme_origin.x, y: (night_theme_origin.y + transition0.y))
            BW_theme_button.frame.origin = CGPoint(x: BW_theme_origin.x, y: (BW_theme_origin.y + transition0.y))
            //chaos_theme_button.frame.origin = CGPoint(x: chaos_theme_origin.x, y: (chaos_theme_origin.y + transition0.y))
            school_theme_button.frame.origin = CGPoint(x: school_theme_origin.x, y: (school_theme_origin.y + transition0.y))
            colors_theme_button.frame.origin = CGPoint(x: colors_theme_origin.x, y: (colors_theme_origin.y + transition0.y))
            
            day_apply_button.frame.origin = CGPoint(x: day_apply_origin.x, y: (day_apply_origin.y + transition0.y))
            night_apply_button.frame.origin = CGPoint(x: night_apply_origin.x, y: (night_apply_origin.y + transition0.y))
            BW_apply_button.frame.origin = CGPoint(x: BW_apply_origin.x, y: (BW_apply_origin.y + transition0.y))
            school_apply_button.frame.origin = CGPoint(x: school_apply_origin.x, y: (school_apply_origin.y + transition0.y))
            colors_apply_button.frame.origin = CGPoint(x: colors_apply_origin.x, y: (colors_apply_origin.y + transition0.y))

            
            if(gesture.state == .ended){
                day_theme_origin.y = day_theme_button.frame.origin.y
                night_theme_origin.y = night_theme_button.frame.origin.y
                BW_theme_origin.y = BW_theme_button.frame.origin.y
                chaos_theme_origin.y = chaos_theme_button.frame.origin.y
                school_theme_origin.y = school_theme_button.frame.origin.y
                colors_theme_origin.y = colors_theme_button.frame.origin.y
                
                
                
                day_apply_origin.y = day_apply_button.frame.origin.y
                night_apply_origin.y = night_apply_button.frame.origin.y
                BW_apply_origin.y = BW_apply_button.frame.origin.y
                school_apply_origin.y = school_apply_button.frame.origin.y
                colors_apply_origin.y = colors_apply_button.frame.origin.y

            }
        }else{
            if(gesture.state == .ended){
                day_theme_origin.y = white_cover_y
                night_theme_origin.y =  day_theme_origin.y + day_theme_button.frame.height
                BW_theme_origin.y = night_theme_origin.y + night_theme_button.frame.height
                //chaos_theme_origin.y = pause_screen_y_transform(319)
                school_theme_origin.y = BW_theme_origin.y + BW_theme_button.frame.height
                colors_theme_origin.y = school_theme_origin.y + school_theme_button.frame.height
                
                day_apply_origin.y = white_cover_y + day_theme_button.frame.height/2.0 - pause_screen_y_transform(18)
                night_apply_origin.y = day_apply_origin.y + day_theme_button.frame.height
                BW_apply_origin.y = night_apply_origin.y + night_theme_button.frame.height
                school_apply_origin.y = BW_apply_origin.y + BW_theme_button.frame.height
                colors_apply_origin.y = school_apply_origin.y + school_theme_button.frame.height
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.day_theme_button.frame.origin.y = self.day_theme_origin.y
                    self.night_theme_button.frame.origin.y = self.night_theme_origin.y
                    self.BW_theme_button.frame.origin.y = self.BW_theme_origin.y
                    self.chaos_theme_button.frame.origin.y = self.chaos_theme_origin.y
                    self.school_theme_button.frame.origin.y = self.school_theme_origin.y
                    self.colors_theme_button.frame.origin.y = self.colors_theme_origin.y
                    
                    self.day_apply_button.frame.origin.y = self.day_apply_origin.y
                    self.night_apply_button.frame.origin.y = self.night_apply_origin.y
                    self.BW_apply_button.frame.origin.y = self.BW_apply_origin.y
                    self.school_apply_button.frame.origin.y = self.school_apply_origin.y
                    self.colors_apply_button.frame.origin.y = self.colors_apply_origin.y
                    
                })
            }
        }
        
        
        
    }
    
    func gameover_title_image_decider() -> Void{
        if (ThemeType == 1){
            if (language == "English"){
                self.gameover_title.image = UIImage(named:"day mode gameover title")
            } else {
                self.gameover_title.image = UIImage(named:"shibai_title_day")
            }
        } else if (ThemeType == 2){
            if (language == "English"){
                self.gameover_title.image = UIImage(named:"night mode gameover title")
            } else {
                self.gameover_title.image = UIImage(named:"shibai_title_night")
            }
        } else if (ThemeType == 3){
            if (language == "English"){
                self.gameover_title.image = UIImage(named:"day mode gameover title")
            } else {
                self.gameover_title.image = UIImage(named:"shibai_title_day")
            }
        } else if (ThemeType == 4){
            //chaos
        }
        else if (ThemeType == 5){
            if (language == "English"){
                self.gameover_title.image = UIImage(named:"school_gameover")
            } else {
                self.gameover_title.image = UIImage(named:"shibai_title_school")
            }
        } else if (ThemeType == 6){
            if (language == "English"){
                self.gameover_title.image = UIImage(named:"night mode gameover title")
            } else {
                self.gameover_title.image = UIImage(named:"shibai_title_night")
            }
        }
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    //star board auto resizing
    var theme_star_counter_fragments : Array<UIView> = []
    var theme_star_board_width = CGFloat(0)
    var theme_star_counter_fragments_width = CGFloat(0)
    
    func split_theme_star_counter() -> Void{
        theme_star_counter_fragments = []
        theme_star_counter.alpha = 1
        theme_star_counter_fragments = theme_star_counter.generateFragmentsFrom(theme_star_counter, with: 4.0, in: self.view)
        var i = 0
        theme_star_counter.alpha = 0
        theme_star_counter_fragments[0].frame.origin.x = theme_star_counter.frame.origin.x
        theme_star_counter_fragments[1].frame.origin.x = theme_star_counter_fragments[0].frame.origin.x + theme_star_counter_fragments[0].frame.width
        theme_star_counter_fragments[2].frame.origin.x = theme_star_counter_fragments[1].frame.origin.x + theme_star_counter_fragments[1].frame.width
        theme_star_counter_fragments[3].frame.origin.x = theme_star_counter_fragments[2].frame.origin.x + theme_star_counter_fragments[2].frame.width
        //print("current_star_total_fragments 0 width is \(current_star_total_fragments[0].frame.width)")
        //print("0 x is \(current_star_total_fragments[0].frame.origin.x)")
        white_cover.addSubview(theme_star_counter_fragments[0])
        white_cover.addSubview(theme_star_counter_fragments[1])
        white_cover.addSubview(theme_star_counter_fragments[2])
        white_cover.addSubview(theme_star_counter_fragments[3])
        theme_star_counter_fragments[0].alpha = 0
        theme_star_counter_fragments[1].alpha = 0
        theme_star_counter_fragments[2].alpha = 0
        theme_star_counter_fragments[3].alpha = 0
        theme_star_counter_fragments[0].fadeIn()
        theme_star_counter_fragments[1].fadeIn()
        theme_star_counter_fragments[2].fadeIn()
        theme_star_counter_fragments[3].fadeIn()
        theme_star_counter_fragments_width = theme_star_counter_fragments[2].frame.width
        self.view.bringSubview(toFront: theme_star_board)
        
        //print(star_counter_fragment_width)
    }
    func remove_all_theme_star_counter_fragments() -> Void{
        theme_menu_star_store_button.removeFromSuperview()
        theme_star_counter_fragments[0].removeFromSuperview()
        theme_star_counter_fragments[1].removeFromSuperview()
        theme_star_counter_fragments[2].removeFromSuperview()
        theme_star_counter_fragments[3].removeFromSuperview()
    }
    
    func update_theme_star_length_according_to_string_length() -> Void{
        var i = 0
        var loop = true
        var argument_integer = 0
        if(star_score != 0){
            while(loop){
                let first_pow = pow(10, Double(i))
                let second_pow = pow(10, Double(i+1))
                if(Double(star_score) >= first_pow && Double(star_score) < second_pow){
                    loop = false
                }
                i += 1
            }
        }else{
            i = 0
        }
        argument_integer = i - 2
        update_theme_star_counter_length(i: argument_integer)
    }
    var theme_star_total_length = CGFloat(0)
    func update_theme_star_counter_length(i: Int) -> Void{
        //print("star_board_original_width: \(star_board_original_width)")
        theme_star_board.frame.size = CGSize(width: theme_star_board_width + (CGFloat(i)*pause_screen_x_transform(3)), height: theme_star_board.frame.height)
        // print("star_board width: \(star_board.frame.width)")
        theme_star_counter_fragments[2].frame.size = CGSize(width: theme_star_counter_fragments_width + CGFloat(i)*pause_screen_x_transform(3), height: theme_star_counter_fragments[2].frame.height)
        theme_star_counter_fragments[3].frame.origin.x = theme_star_counter_fragments[2].frame.origin.x + theme_star_counter_fragments[2].frame.width
        self.view.bringSubview(toFront: theme_star_board)
        theme_star_total_length = theme_star_counter_fragments[0].frame.width + theme_star_counter_fragments[1].frame.width + theme_star_counter_fragments[2].frame.width + theme_star_counter_fragments[3].frame.width
        theme_menu_star_store_button.frame.size = CGSize(width: theme_star_total_length, height: theme_star_counter_fragments[0].frame.height)

    }
    
    var purchase_star_menu = UIImageView()
    var more_stars_label = UIImageView()
    var close_button = MyButton()
    var purchase_star_1000_bg = UIImageView()
    var purchase_star_500_bg = UIImageView()
    var purchase_star_1000_button = MyButton()
    var purchase_star_500_button = MyButton()
    var gameover_star_purchase = String()
    
    func purchase_star_function() -> Void{
        
        
        purchase_star_menu = UIImageView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        purchase_star_menu.image = #imageLiteral(resourceName: "treasure_background")
        purchase_star_menu.alpha = 0
        self.view.addSubview(purchase_star_menu)
        purchase_star_menu.fadeIn()
        
        more_stars_label = UIImageView(frame: CGRect(x: self.pause_screen_x_transform(42), y: self.pause_screen_y_transform(30), width: self.pause_screen_x_transform(272), height: self.pause_screen_y_transform(146)))
        more_stars_label.image = #imageLiteral(resourceName: "more_stars")
        more_stars_label.alpha = 0
        self.view.addSubview(more_stars_label)
        more_stars_label.fadeIn()
        
        purchase_star_500_bg = UIImageView(frame: CGRect(x: self.pause_screen_x_transform(35), y: self.pause_screen_y_transform(162), width: self.pause_screen_x_transform(305), height: self.pause_screen_y_transform(115)))
        purchase_star_1000_bg = UIImageView(frame: CGRect(x: self.pause_screen_x_transform(35), y: self.pause_screen_y_transform(314), width: self.pause_screen_x_transform(305), height: self.pause_screen_y_transform(115)))
        purchase_star_1000_bg.image = #imageLiteral(resourceName: "purchase_star_1000")
        purchase_star_1000_bg.alpha = 0
        self.view.addSubview(purchase_star_1000_bg)
        purchase_star_1000_bg.fadeIn()
        
        
        purchase_star_500_bg.image = #imageLiteral(resourceName: "purchase_star_500")
        purchase_star_500_bg.alpha = 0
        self.view.addSubview(purchase_star_500_bg)
        purchase_star_500_bg.fadeIn()
        
        
        
        close_button.frame = CGRect(x: self.pause_screen_x_transform(137), y: self.pause_screen_y_transform(500), width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(100))
        close_button.setImage(#imageLiteral(resourceName: "revive_just_let_me_die"), for: .normal)
        close_button.alpha = 0
        self.view.addSubview(close_button)
        
        close_button.whenButtonIsClicked{
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            
                self.purchase_star_menu.fadeOutandRemove()
                self.more_stars_label.fadeOutandRemove()
                self.close_button.fadeOutandRemove()
                
                
                self.purchase_star_1000_bg.fadeOutandRemove()
                self.purchase_star_500_bg.fadeOutandRemove()
                self.purchase_star_1000_button.fadeOutandRemove()
                self.purchase_star_500_button.fadeOutandRemove()
            
            }
        
        close_button.fadeIn()
        
        purchase_star_500_button.frame = CGRect(x: self.pause_screen_x_transform(208), y: self.pause_screen_y_transform(196), width: self.pause_screen_x_transform(118), height: self.pause_screen_y_transform(47))
        purchase_star_1000_button.frame = CGRect(x: self.pause_screen_x_transform(208), y: self.pause_screen_y_transform(348), width: self.pause_screen_x_transform(118), height: self.pause_screen_y_transform(47))
        purchase_star_1000_button.setImage(#imageLiteral(resourceName: "purchase_star_1000_price"), for: .normal)
        purchase_star_1000_button.alpha = 0
        self.view.addSubview(purchase_star_1000_button)
        purchase_star_1000_button.whenButtonIsClicked{
            for product in self.purchase_product_list{
                let productID = product.productIdentifier
                if productID == "tritri.add_1000_stars"{
                    self.present_product = product
                    self.buyProduct()
                }
                print(productID)
            }
        }
        
        
        purchase_star_1000_button.fadeIn()
        
        
        purchase_star_500_button.setImage(#imageLiteral(resourceName: "purchase_star_500_price"), for: .normal)
        purchase_star_500_button.alpha = 0
        self.view.addSubview(purchase_star_500_button)
        purchase_star_500_button.whenButtonIsClicked{
            for product in self.purchase_product_list{
                let productID = product.productIdentifier
                if productID == "tritri.add_500_stars"{
                    self.present_product = product
                    self.buyProduct()
                }
            }
        }
        
        
        purchase_star_500_button.fadeIn()
    }
    
    func buyProduct() -> Void{
        print ("purchasing")
        let pay = SKPayment(product: self.present_product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    
    func add_500_stars() -> Void{
        star_score += 500
        defaults.set(star_score, forKey: "tritri_star_score")
        defaults.synchronize()
        self.purchase_star_menu.fadeOutandRemove()
        self.more_stars_label.fadeOutandRemove()
        self.close_button.fadeOutandRemove()
        
        
        self.purchase_star_1000_bg.fadeOutandRemove()
        self.purchase_star_500_bg.fadeOutandRemove()
        self.purchase_star_1000_button.fadeOutandRemove()
        self.purchase_star_500_button.fadeOutandRemove()
        
    }
    
    func add_1000_stars() -> Void{
        star_score += 1000
        defaults.set(star_score, forKey: "tritri_star_score")
        defaults.synchronize()
        
        self.purchase_star_menu.fadeOutandRemove()
        self.more_stars_label.fadeOutandRemove()
        self.close_button.fadeOutandRemove()
        
        
        self.purchase_star_1000_bg.fadeOutandRemove()
        self.purchase_star_500_bg.fadeOutandRemove()
        self.purchase_star_1000_button.fadeOutandRemove()
        self.purchase_star_500_button.fadeOutandRemove()
        
    }
    
    var purchase_product_list = [SKProduct]()
    var present_product = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Product request")
        let myProduct = response.products
        for product in myProduct{
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            purchase_product_list.append(product)
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transaction restored")
        for transaction in queue.transactions{
            let t:SKPaymentTransaction = transaction
            let productID = t.payment.productIdentifier as String
            
            switch productID{
            case "tritri.add_500_stars":
                print ("add 500 stars")
                add_500_stars()
            case "tritri.add_1000_stars":
                print ("add 1000 stars")
                add_1000_stars()
            default:
                print ("in app purchase not found")
            }
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print ("add payment")
        for transaction: AnyObject in transactions{
            let trans = transaction as! SKPaymentTransaction
            print (trans.error)
            
            switch trans.transactionState{
            case .purchased:
                print ("IAP unlock")
                print (present_product.productIdentifier)
                
                let productID = present_product.productIdentifier
                
                switch productID{
                case "tritri.add_500_stars":
                    print ("add 500 stars")
                    add_500_stars()
                case "tritri.add_1000_stars":
                    print ("add 1000 stars")
                    add_1000_stars()
                default:
                    print ("in app purchase not found")
                }
                queue.finishTransaction(trans)
            case .failed:
                print ("purchase failed")
                queue.finishTransaction(trans)
                break
            default:
                print("default")
                break
            }
            
        }
    }

    @IBOutlet var share_image_outlet: UIButton!
    //share image button
    var final_image_to_share = UIImage()
    @IBAction func share_image_action(_ sender: UIButton) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }
        let shareImage = compose_final_share_image()
        final_image_to_share = shareImage
        //let myWebsite = NSURL(string:"http://www.baidu.com/")
        let shareItem = [shareImage] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        //share type
        activityViewController.excludedActivityTypes = [ UIActivityType.copyToPasteboard , UIActivityType.assignToContact, UIActivityType.openInIBooks, UIActivityType.print, UIActivityType.airDrop]
        //present view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func like_action(_ sender: UIButton) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }
        if(language == "English"){
            EggRating.rateButtonTitleText = "Cheers"
            EggRating.titleLabelText = "Rate Our App"
            EggRating.dismissButtonTitleText = "Not Now"
            EggRating.descriptionLabelText = "This is our first app. If you love our app, please take a moment to rate it."
            EggRating.appStoreTitleLabelText = "Write a review on the App Store"
            EggRating.appStoreDescriptionLabelText = "Would you mind taking a moment to rate it on the App Store? It won't take more than a minute. Thanks for your support!"
            EggRating.appStoreDismissButtonTitleText = "Not Right Now"
            EggRating.appStoreRateButtonTitleText = "Rate tri-tri Now"
            
        }else{
            EggRating.rateButtonTitleText = "打分"
            EggRating.dismissButtonTitleText = "离开"
            EggRating.titleLabelText = "为tri-tri打分"
            EggRating.descriptionLabelText = "客官您好！这是我们团队的第一个app。如果您喜欢tri-tri，劳烦客官为她评分并支持我们！"
            EggRating.appStoreTitleLabelText = "在App Store点评"
            EggRating.appStoreDescriptionLabelText = "麻烦占用客官一点时间在app store上为我们点评。整个过程不会超过一分钟。HBT Games感谢您的支持！"
            EggRating.appStoreDismissButtonTitleText = "残忍地拒绝"
            EggRating.appStoreRateButtonTitleText = "现在开始评论"
            
            
        }
        EggRating.promptRateUs(viewController: self)
        
    }
    
    //handle the final image to share
    func compose_final_share_image() -> UIImage{
        //first add a white cover
        let white_cover = UIView(frame: CGRect(x: -screen_width/2.0, y: -screen_height/2.0, width: 2.0*screen_width, height: 2.0*screen_height))
        white_cover.backgroundColor = UIColor.white
        white_cover.alpha = 1.0
        self.view.addSubview(white_cover)
        //four times of the area
        let final_image_frame = UIImageView(frame: share_image_scene.frame)
        if (language == "English"){
         final_image_frame.image = #imageLiteral(resourceName: "final_image_frame")
        }else{
         final_image_frame.image = #imageLiteral(resourceName: "final_share_frame_chinese")
        }
        
        final_image_frame.contentMode = .scaleAspectFit
        self.view.addSubview(final_image_frame)
        //now add screen shot
      let temp_screenshot = UIImageView(frame: finalBoard.frame)
        temp_screenshot.image = finalBoard.image
        self.view.addSubview(temp_screenshot)
        temp_screenshot.contentMode = .scaleAspectFit
        //take screen shot again
        let share_QR = generateQRCode()!
        let share_QR_view = UIImageView(frame: CGRect(x: share_scene_score.frame.origin.x , y: share_scene_score.frame.origin.y + pause_screen_y_transform(98), width: pause_screen_x_transform(60), height: pause_screen_y_transform(60)))
        share_QR_view.image = share_QR
        self.view.addSubview(share_QR_view)
        let temp_final_score = UILabel(frame: share_scene_score.frame)
        temp_final_score.textAlignment = .left
        temp_final_score.font = UIFont(name: "Fresca-Regular", size: 30.0)
        temp_final_score.textColor = UIColor.yellow
        temp_final_score.text = final_score
        self.view.addSubview(temp_final_score)
        
        let size = CGSize(width: final_image_frame.frame.width , height: final_image_frame.frame.height-pause_screen_y_transform(24))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let draw_rec = CGRect(x: -final_image_frame.frame.origin.x , y: -final_image_frame.frame.origin.y-pause_screen_x_transform(12) , width: view.bounds.size.width , height: view.bounds.size.height)
        self.view.drawHierarchy(in: draw_rec, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        temp_screenshot.removeFromSuperview()
        final_image_frame.removeFromSuperview()
        white_cover.removeFromSuperview()
        temp_final_score.removeFromSuperview()
        share_QR_view.removeFromSuperview()
        return image!
        
    }
    
    @IBAction func wechat_share(_ sender: UIButton) {
    //var message =
    let image = compose_final_share_image()
        //if WXApi.isWXAppInstalled() && WXApi.isWXAppSupport() {
        sendImage( image:image, inScene: WXSceneTimeline)
          //  }
        
    }
   
    
    
    ///分享图片
    func sendImage(image:UIImage, inScene:WXScene)->Bool{
        let ext=WXImageObject()
        ext.imageData=UIImagePNGRepresentation(image)
        
        let message=WXMediaMessage()
        message.title=nil
        message.description=nil
        message.mediaObject=ext
        message.mediaTagName="MyPic"
        //生成缩略图
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        image.draw(in: CGRect(x: 0, y: 0, width: 100,height: 100))
        let thumbImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        message.thumbData=UIImagePNGRepresentation(thumbImage!)
        
        let req=SendMessageToWXReq()
        req.text=nil
        req.message=message
        req.bText=false
        req.scene=Int32(inScene.rawValue)
        return WXApi.send(req)
    }
    
    func generateQRCode() -> UIImage?{
   let share_string = "https://itunes.apple.com/ca/app/tri-tri/id1259058860?mt=8"
   let data = share_string.data(using: String.Encoding.ascii)
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)
            
 if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
        
        
        
    }
   
    

}



class MyButton: UIButton {
    var action: (()->())?
    var highlight_action: (()->())?
    var escapeHighlight_action: (()->())?
    func whenButtonIsClicked(action: @escaping ()->()) {
        self.action = action
        self.addTarget(self, action: #selector(MyButton.clicked), for: .touchUpInside)
    }
    func whenButtonIsHighlighted(action: @escaping () -> () ) {
        self.highlight_action = action
        self.addTarget(self, action: #selector(MyButton.highlighted), for: .touchDown)
        
    }
    
    func whenButtonEscapeHighlight(action: @escaping () -> ()) {
        self.escapeHighlight_action = action
        self.addTarget(self, action: #selector(MyButton.escape_highlight), for: .touchDragExit)
    }
    
    func clicked() {
        action?()
    }
    
    func highlighted() {
        highlight_action?()
    }
    
    func escape_highlight(){
        escapeHighlight_action?()
    }
}
