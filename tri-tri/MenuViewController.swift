//
//  MenuViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-05-15.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import EggRating
import SpriteKit
import StoreKit
import GameKit
import Material

extension UIView:Explodable { }



class MenuViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, GKGameCenterControllerDelegate {

    
    //theme islocked array
    //if locked : true , unlocked : false
    var theme_islocked_array : Array<Bool> = []
    //to show whether first time to enter sale
    var first_enter_sale = false
    
    @IBOutlet weak var gear_icon: UIImageView!
    var language = String()
    
    var cash_player = AVAudioPlayer()
    var add_player = AVAudioPlayer()
    var sub_player = AVAudioPlayer()
    var sub_not_allowed_player = AVAudioPlayer()
    var wrong_player = AVAudioPlayer()
    
    @IBOutlet weak var background_image: UIImageView!

    @IBOutlet weak var star_counter: UIButton!
    
    //sound state
    var sound_is_muted = false
    
    @IBOutlet weak var star_board: UILabel!
    @IBOutlet weak var continue_button: UIButton!
    var button_player = AVAudioPlayer()
    var opening_player = AVAudioPlayer()
    var star_score = 0
    
    @IBOutlet var tutorial_button: UIButton!
    @IBOutlet weak var gift_button: UIButton!
    
    @IBAction func gift_sound_effect(_ sender: UIButton) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }

    }
    

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var star_store_button = MyButton()
    
    @IBAction func tutorial_button_sound(_ sender: Any) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }
    }
    
    
 var settings_scene_original = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      let device_language = NSLocale.current.languageCode!
       print("device language: \(device_language)")
        
        //like_button.prepare()
        //like_button.setTitleColor(UIColor.clear, for: .highlighted)
        if (defaults.value(forKey: "language") == nil){
            if(device_language == "zh"){
               language = "Chinese"
               defaults.set("Chinese", forKey: "language")
                print("System language initializes to Chinese")
                
            }else{
                language = "English"
                defaults.set("English", forKey: "language")
                print("System language initializes to English")
            }
            
            
           
            
        }
        
        
        if (defaults.value(forKey: "language") as! String == "English"){
            language = "English"
        }
        else {
            language = "Chinese"
        }
        
        if(defaults.value(forKey: "tritri_theme_lock_array") == nil){
         theme_islocked_array = [false,false,true,true,true]
        defaults.set(theme_islocked_array, forKey: "tritri_theme_lock_array")
        }else{
            theme_islocked_array = defaults.value(forKey: "tritri_theme_lock_array") as! Array<Bool>
        }
        
        if (SKPaymentQueue.canMakePayments()){
            print ("In_app_purchase is enabled, loading")
            let productID : NSSet = NSSet(objects: "tritri.test.add_500_stars", "tritri.test.add_1000_stars")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPs")
        }

        if (defaults.value(forKey: "tri_tri_sound_is_muted") == nil){
            sound_is_muted = false
            defaults.set(sound_is_muted, forKey: "tri_tri_sound_is_muted")
        }
        else {
            sound_is_muted = defaults.value(forKey: "tri_tri_sound_is_muted") as! Bool
        }
        
        
        
        screen_width = view.frame.width
        screen_height = view.frame.height
        //add pangesture
        //triangle_title = UIImageView(frame: CGRect(x: pause_screen_x_transform(40), y: pause_screen_y_transform(20), width: pause_screen_x_transform(120), height: pause_screen_y_transform(50)))
        triangle_title.frame = CGRect(x: pause_screen_x_transform(Double(triangle_title.frame.origin.x)), y: pause_screen_y_transform(Double(triangle_title.frame.origin.y)), width: pause_screen_x_transform(Double(triangle_title.frame.width)), height: pause_screen_y_transform(Double(triangle_title.frame.height)))
        shopping_cart.frame = CGRect(x: pause_screen_x_transform(Double(shopping_cart.frame.origin.x)), y: pause_screen_y_transform(Double(shopping_cart.frame.origin.y)), width: pause_screen_x_transform(Double(shopping_cart.frame.width)), height: pause_screen_y_transform(Double(shopping_cart.frame.height)))
         //shopping_cart.touchAreaEdgeInsets = UIEdgeInsets(top: 0, left: pause_screen_x_transform(40), bottom: pause_screen_y_transform(40), right: pause_screen_x_transform(40))
        like_button.frame =  CGRect(x: pause_screen_x_transform(Double(like_button.frame.origin.x)), y: pause_screen_y_transform(Double(like_button.frame.origin.y)), width: pause_screen_x_transform(Double(like_button.frame.width)), height: pause_screen_y_transform(Double(like_button.frame.height)))
        continue_button.frame = CGRect(x: pause_screen_x_transform(Double(continue_button.frame.origin.x)), y: pause_screen_y_transform(Double(continue_button.frame.origin.y)), width: pause_screen_x_transform(Double(continue_button.frame.width)), height: pause_screen_y_transform(Double(continue_button.frame.height)))
        star_counter.frame = CGRect(x: pause_screen_x_transform(Double(star_counter.frame.origin.x)), y: pause_screen_y_transform(Double(star_counter.frame.origin.y)), width: pause_screen_x_transform(Double(star_counter.frame.width)), height: pause_screen_y_transform(Double(star_counter.frame.height)))
        trophy.contentMode = .scaleAspectFit
        trophy.frame = CGRect(x: pause_screen_x_transform(Double(trophy.frame.origin.x)), y: pause_screen_y_transform(Double(trophy.frame.origin.y)), width: pause_screen_x_transform(Double(trophy.frame.width)), height: pause_screen_y_transform(Double(trophy.frame.height)))
        star_board.frame = CGRect(x: pause_screen_x_transform(Double(star_board.frame.origin.x)), y: pause_screen_y_transform(Double(star_board.frame.origin.y)), width: pause_screen_x_transform(Double(star_board.frame.width)), height: pause_screen_y_transform(Double(star_board.frame.height)))
        highest_score.frame = CGRect(x: pause_screen_x_transform(Double(highest_score.frame.origin.x)), y: pause_screen_y_transform(Double(highest_score.frame.origin.y)), width: pause_screen_x_transform(Double(highest_score.frame.width)), height: pause_screen_y_transform(Double(highest_score.frame.height)))
        gift_button.frame = CGRect(x: pause_screen_x_transform(Double(gift_button.frame.origin.x)), y: pause_screen_y_transform(Double(gift_button.frame.origin.y)), width: pause_screen_x_transform(Double(gift_button.frame.width)), height: pause_screen_y_transform(Double(gift_button.frame.height)))
        tutorial_button.frame = CGRect(x: pause_screen_x_transform(0), y: pause_screen_y_transform(538), width: pause_screen_x_transform(128), height: pause_screen_y_transform(129))
        tutorial_button.contentMode = .scaleAspectFit
        treasure_box_icon.frame = CGRect(x: pause_screen_x_transform(Double(treasure_box_icon.frame.origin.x)), y: pause_screen_y_transform(Double(treasure_box_icon.frame.origin.y)), width: pause_screen_x_transform(Double(treasure_box_icon.frame.width)), height: pause_screen_y_transform(Double(treasure_box_icon.frame.height)))
        settings_button.frame = CGRect(x: pause_screen_x_transform(Double(settings_button.frame.origin.x)), y: pause_screen_y_transform(Double(settings_button.frame.origin.y)), width: pause_screen_x_transform(Double(settings_button.frame.width)), height: pause_screen_y_transform(Double(settings_button.frame.height)))
        gear_icon.frame = CGRect(x: pause_screen_x_transform(Double(gear_icon.frame.origin.x)), y: pause_screen_y_transform(Double(gear_icon.frame.origin.y)), width: pause_screen_x_transform(Double(gear_icon.frame.width)), height: pause_screen_y_transform(Double(gear_icon.frame.height)))
        background_image.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        settings_scene.frame = CGRect(x: pause_screen_x_transform(Double(settings_scene.frame.origin.x)), y: pause_screen_y_transform(Double(settings_scene.frame.origin.y)), width: pause_screen_x_transform(Double(settings_scene.frame.width)), height: pause_screen_y_transform(Double(settings_scene.frame.height)))
       settings_scene_original = settings_scene.frame
        settings_scene.contentMode = .scaleAspectFit
        settings_button.alpha = 0.02
        self.view.bringSubview(toFront: gear_icon)
        self.view.bringSubview(toFront: settings_button)
         self.view.isUserInteractionEnabled = true
        let menu_tap_gesture = UITapGestureRecognizer(target: self, action: #selector(menu_tapped))
        menu_tap_gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(menu_tap_gesture)

        
        star_board.font = UIFont(name: "Fresca-Regular", size: CGFloat(22))
        var HighestScore = 0
        // Do any additional setup after loading the view.
        if(defaults.value(forKey: "tritri_HighestScore") != nil ){
            HighestScore = defaults.value(forKey: "tritri_HighestScore") as! NSInteger
            print("Highest Score is \(HighestScore)")
        }else{
            defaults.set(0, forKey: "tritri_HighestScore")
            HighestScore = 0
        }
        highest_score.text = String(HighestScore)
        if(defaults.value(forKey: "tritri_star_score") != nil ){
            star_score = defaults.value(forKey: "tritri_star_score") as! NSInteger
        }else{
            defaults.set(0, forKey: "tritri_star_score")
            star_score = 0
        }
        star_board.text = String(star_score)
        
        //tool box default 
        //get tool box quantity array
        
        
        if(defaults.value(forKey: "tritri_tool_quantity_array") != nil){
            tool_quantity_array = defaults.value(forKey: "tritri_tool_quantity_array") as! Array
        }else{
            defaults.set([0,0,0,0,0,0], forKey: "tritri_tool_quantity_array")
        }
        
        
        
        if (defaults.value(forKey: "tritri_Theme") == nil){
            ThemeType = 1
            defaults.set(1, forKey: "tritri_Theme")
        }
        else {
            ThemeType = defaults.integer(forKey: "tritri_Theme")
        }
        

        //language_button_image_decider()
        if(ThemeType == 1){
            trophy.image = #imageLiteral(resourceName: "day_mode_trophy")
            view.backgroundColor = UIColor(red: 254.0/255, green: 253.0/255, blue: 252.0/255, alpha: 1.0)
            background_image.alpha = 0
            like_button.setBackgroundImage(UIImage(named: "day mode like"), for: .normal)
            highest_score.textColor = UIColor(red: 26.0/255, green: 58.0/255, blue: 49.0/255, alpha: 1)
            shopping_cart.setImage(UIImage(named:"shopping_cart"), for: .normal)
            continue_button.setImage(UIImage(named:"continue"), for: .normal)
            star_board.textColor = UIColor(red: 46.0/255, green: 62.0/255, blue: 59.0/255, alpha: 1.0)
            star_counter.setImage(#imageLiteral(resourceName: "day_mode_star"), for: .normal)
            gift_button.setImage(#imageLiteral(resourceName: "gift_day_mode"), for: .normal)
            tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_day_night"), for: .normal)
            treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_day_mode"), for: .normal)
            settings_button.setImage(#imageLiteral(resourceName: "settings_day"), for: .normal)
             settings_scene.image = #imageLiteral(resourceName: "settings_scene_day&night")
            gear_icon.image = #imageLiteral(resourceName: "gear_day&night")
        }else if(ThemeType == 2){
            trophy.image = #imageLiteral(resourceName: "night_mode_trophy")
            view.backgroundColor = UIColor(red: 23.0/255, green: 53.0/255, blue: 52.0/255, alpha: 1.0)
            background_image.alpha = 0
            triangle_title.image = UIImage(named:"night mode triangle title")
            like_button.setBackgroundImage(UIImage(named: "night mode like button"), for: .normal)
             highest_score.textColor = UIColor(red: 167.0/255, green: 157.0/255, blue: 124.0/255, alpha: 1)
            shopping_cart.setImage(UIImage(named:"shopping_cart"), for: .normal)
            continue_button.setImage(UIImage(named:"continue"), for: .normal)
            star_board.textColor = UIColor.white
            star_counter.setImage(#imageLiteral(resourceName: "night_mode_star"), for: .normal)
            gift_button.setImage(#imageLiteral(resourceName: "gift_night_mode"), for: .normal)
            tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_day_night"), for: .normal)
            treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_night_mode"), for: .normal)
            settings_button.setImage(#imageLiteral(resourceName: "settings_day"), for: .normal)
            settings_scene.image = #imageLiteral(resourceName: "settings_scene_day&night")
            gear_icon.image = #imageLiteral(resourceName: "gear_day&night")
        }else if(ThemeType == 3){
            like_button.setBackgroundImage(UIImage(named: "BW_like"), for: .normal)
            shopping_cart.setImage(UIImage(named:"BW_shopping"), for: .normal)
            trophy.image = #imageLiteral(resourceName: "BW_mode_trophy")
            highest_score.textColor =  UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1)
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"BW_background")!)
            background_image.alpha = 1
            background_image.image = #imageLiteral(resourceName: "BW_background")
            continue_button.setImage(UIImage(named:"BW_continue"), for: .normal)
            star_board.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1.0)
            star_counter.setImage(#imageLiteral(resourceName: "BW_mode_star"), for: .normal)
            gift_button.setImage(#imageLiteral(resourceName: "gift_BW_mode"), for: .normal)
            tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_B&W"), for: .normal)
            treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_bw_mode"), for: .normal)
            settings_button.setImage(#imageLiteral(resourceName: "settings_bw"), for: .normal)
            settings_scene.image = #imageLiteral(resourceName: "settings_scene_bw")
            gear_icon.image = #imageLiteral(resourceName: "gear_bw&colors")
        }else if(ThemeType == 4){
            triangle_title.image = UIImage(named: "night mode triangle title")
            like_button.setBackgroundImage(UIImage(named: "chaos_like_icon"), for: .normal)
            shopping_cart.setImage(UIImage(named:"chaos_theme_button"), for: .normal)
            trophy.image = UIImage(named:"chaos_j_icon")
            highest_score.textColor = UIColor(red: 236.0/255, green: 232.0/255, blue: 187.0/255, alpha: 1.0)
            background_image.alpha = 1
            background_image.image = #imageLiteral(resourceName: "chaos_background")
            //view.backgroundColor = UIColor(patternImage: UIImage(named: "chaos_background")!)
            continue_button.setImage(UIImage(named:"chaos_start_icon"), for: .normal)
            settings_button.setImage(#imageLiteral(resourceName: "settings_day"), for: .normal)
            
        }else if(ThemeType == 5){
            like_button.setBackgroundImage(UIImage(named: "school_like-icon"), for: .normal)
            shopping_cart.setImage(UIImage(named:"school_theme-button"), for: .normal)
            trophy.image = #imageLiteral(resourceName: "school_mode_trophy")
            highest_score.textColor = UIColor(red: 34.0/255, green: 61.0/255, blue: 128.0/255, alpha: 1.0)
            //view.backgroundColor = UIColor(patternImage: UIImage(named: "school_background")!)
            background_image.alpha = 1
            background_image.image = #imageLiteral(resourceName: "school_background")
            continue_button.setImage(UIImage(named:"school_start-icon"), for: .normal)
            star_board.textColor = UIColor(red: 68.0/255, green: 84.0/255, blue: 140.0/255, alpha: 1.0)
            star_counter.setImage(#imageLiteral(resourceName: "school_mode_star"), for: .normal)
            gift_button.setImage(#imageLiteral(resourceName: "gift_school_mode"), for: .normal)
            tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_school"), for: .normal)
            treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_school_mode"), for: .normal)
            settings_button.setImage(#imageLiteral(resourceName: "settings_school"), for: .normal)
            settings_scene.image = #imageLiteral(resourceName: "settings_scene_school")
            gear_icon.image = #imageLiteral(resourceName: "gear_school")
        }
        else if(ThemeType == 6){

            like_button.setBackgroundImage(UIImage(named:"colors_like-icon"), for: .normal)
            shopping_cart.setImage(UIImage(named:"colors_theme-button"), for: .normal)
            trophy.image = #imageLiteral(resourceName: "colors_mode_trophy")
            highest_score.textColor = UIColor(red: 255.0/255, green: 195.0/255, blue: 1.0/255, alpha: 1.0)
            continue_button.setImage(UIImage(named:"colors_start"), for: .normal)
            //view.backgroundColor = UIColor(patternImage: UIImage(named: "colors_background")!)
            background_image.alpha = 1
            background_image.image = #imageLiteral(resourceName: "colors_background")
            star_board.textColor = UIColor(red: 81.0/255, green: 195.0/255, blue: 247.0/255, alpha: 1.0)
            star_counter.setImage(#imageLiteral(resourceName: "colors_mode_star"), for: .normal)
            gift_button.setImage(#imageLiteral(resourceName: "gift_color_mode"), for: .normal)
            tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_color"), for: .normal)
            treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_color_mode"), for: .normal)
            settings_button.setImage(#imageLiteral(resourceName: "settings_colors"), for: .normal)
            settings_scene.image = #imageLiteral(resourceName: "settings_scene_colors")
            gear_icon.image = #imageLiteral(resourceName: "gear_bw&colors")
        }
        triangle_title_image_decider()
     star_board_original_width = star_board.frame.width
        print("star board width is \(star_board.frame.width)")
    //spliti star counter
    split_star_counter()
    star_store_button = MyButton(frame: star_counter.frame)
    update_star_counter_length_according_to_string_length()
 
    
    //add star_store button Star Store Action
    
    star_store_button.setImage(#imageLiteral(resourceName: "day_mode_star"), for: .normal)
    star_store_button.alpha = 0.02
    star_store_button.frame.size = CGSize(width: star_counter_total_length, height: star_counter_fragments[0].frame.height)
    self.view.addSubview(star_store_button)
        star_store_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            self.purchase_star_function()
        })
    //enablel gamecenter
    authPlayer()
    saveBestScore()
    //openGameCenter()
    //wechat
        if (defaults.value(forKey: "tritri_firstTimerEnterSale") == nil){
             first_enter_sale = true
            defaults.set(first_enter_sale, forKey: "tritri_firstTimerEnterSale")
        }
        else {
            first_enter_sale = defaults.value(forKey: "tritri_firstTimerEnterSale") as! Bool
        }
        if(first_enter_sale){
        first_time_enter_sale_action()
        let saleViewTap = UITapGestureRecognizer(target: self, action: #selector(saleView_tapped))
            saleViewTap.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(saleViewTap)
        }
    
        
    }
    
    var in_first_sale_scene = false
    var first_time_enter_sale_scene = UIImageView()
    func first_time_enter_sale_action(){
     in_first_sale_scene = true
     first_time_enter_sale_scene.frame = self.view.frame
     first_time_enter_sale_scene.image = #imageLiteral(resourceName: "first_time_enter_sale")
     self.view.addSubview(first_time_enter_sale_scene)
     first_time_enter_sale_scene.alpha = 0
    first_time_enter_sale_scene.fadeIn()
    gift_button.isUserInteractionEnabled = false
    continue_button.isUserInteractionEnabled = false
    treasure_box_icon.isUserInteractionEnabled = false
    tutorial_button.isUserInteractionEnabled = false
    shopping_cart.isUserInteractionEnabled = false
    like_button.isUserInteractionEnabled = false
    settings_button.isUserInteractionEnabled = false
        
        
    }
    
    func menu_tapped(_ gesture: UITapGestureRecognizer ){
        if(settings_scene_is_opened){
         let location = gesture.location(in: self.view)
            if(!settings_scene.frame.contains((location))){
                if(!sound_is_muted){
                    do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                        self.button_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.button_player.play()
                }

            close_settings_scene()
            }
            
        }
    }
    
    
    func saleView_tapped(_ gesture: UITapGestureRecognizer ) {
        if(in_first_sale_scene){
        let location = gesture.location(in: self.view)
            if(first_time_enter_sale_scene.frame.contains(location)){
                first_time_enter_sale_scene.fadeOutandRemove()
                gift_button.isUserInteractionEnabled = true
                continue_button.isUserInteractionEnabled = true
                treasure_box_icon.isUserInteractionEnabled = true
                tutorial_button.isUserInteractionEnabled = true
                shopping_cart.isUserInteractionEnabled = true
                like_button.isUserInteractionEnabled = true
                settings_button.isUserInteractionEnabled = true
                first_enter_sale = false
                defaults.set(first_enter_sale, forKey: "tritri_firstTimerEnterSale")
                
            }
        }
    }
    
    


    @IBOutlet weak var like_button: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var screen_width : CGFloat = 0
    var screen_height : CGFloat = 0

    
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

    @IBAction func start_action(_ sender: UIButton) {
        if(!sound_is_muted){
        do{self.opening_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "opening", ofType: "wav")!))
            self.opening_player.prepareToPlay()
        }
        catch{
            
        }
        self.opening_player.play()
        }
        if(settings_scene_is_opened){
            close_settings_scene()
        }
    }

    @IBOutlet weak var triangle_title: UIImageView!
    
    
    //settings button
    @IBOutlet var settings_button: UIButton!
    //settings functional buttons
    var language_button = MyButton()
    var mute_button = MyButton()
    var gameCenter_button = MyButton()
 
    
    
    
    @IBOutlet weak var settings_scene: UIImageView!
    
    
    
    
    @IBAction func language_changing(_ sender: Any) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }
        /**if (defaults.value(forKey: "language") as! String == "English"){
            language = "Chinese"
            defaults.set("Chinese", forKey: "language")
            print("System language change to Chinese")
            self.language_button_image_decider()
            triangle_title_image_decider()
        } else {
            language = "English"
            defaults.set("English", forKey: "language")
            print("System language change to English")
            self.language_button_image_decider()
            triangle_title_image_decider()
        }**/
        
    }
    
    
    
    
    
    
    @IBOutlet weak var shopping_cart: UIButton!
    //origin
    var day_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var night_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var BW_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var chaos_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var school_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var colors_theme_button = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var theme_star_counter = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var theme_star_board = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var day_apply_button = MyButton()
    var night_apply_button = MyButton()
    var BW_apply_button = MyButton()
    var school_apply_button = MyButton()
    var colors_apply_button = MyButton()

    var BW_saleConer = UIImageView()
    var school_saleConer = UIImageView()
    var colors_saleConer = UIImageView()
    
    var day_theme_origin = CGPoint(x: 0, y: 0)
    var night_theme_origin = CGPoint(x: 0, y: 0)
    var BW_theme_origin = CGPoint(x: 0, y: 0)
    var chaos_theme_origin = CGPoint(x: 0, y: 0)
    var school_theme_origin = CGPoint(x: 0, y: 0)
    var colors_theme_origin = CGPoint(x: 0, y: 0)
    
    var day_apply_origin = CGPoint()
    var night_apply_origin = CGPoint()
    var BW_apply_origin = CGPoint()
    var school_apply_origin = CGPoint()
    var colors_apply_origin = CGPoint()
    
    var white_cover_y = CGFloat(0)
    var theme_button_height = CGFloat(0)
    var theme_menu = UIScrollView()
    var in_theme_menu = false
    var white_cover = UIView()
    var theme_menu_star_store_button = MyButton()
    
    var return_button = MyButton()
    
    @IBAction func theme_menu_action(_ sender: UIButton) {
        if(settings_scene_is_opened){
            close_settings_scene()
        }
        if(!in_theme_menu){
            in_theme_menu = true
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
            }
        white_cover = UIView(frame: CGRect(x: pause_screen_x_transform(0), y: pause_screen_y_transform(0), width: pause_screen_x_transform(400), height: pause_screen_y_transform(53)))
        white_cover_y = white_cover.frame.origin.y + white_cover.frame.height
        
        theme_button_height = (screen_height - white_cover_y)/3.0
        theme_menu = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y:0),size: CGSize(width: screen_width, height: screen_height)))
        theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
        theme_menu.alpha = 0
        theme_menu.tag = 100
        super.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(theme_menu)
        //theme_menu.fadeIn()
        
        
        
        
        let triangle_text = UIImageView(frame: CGRect(x: pause_screen_x_transform(110), y: pause_screen_y_transform(15), width: pause_screen_x_transform(155), height: pause_screen_y_transform(35)))
        
        theme_star_counter = UIImageView(frame: CGRect(x:pause_screen_x_transform(255), y:pause_screen_y_transform(12),width: pause_screen_x_transform(102), height: pause_screen_y_transform(38)))
        theme_star_board = UILabel(frame: CGRect(x:pause_screen_x_transform(285),y:pause_screen_y_transform(15),width: pause_screen_x_transform(80),height:pause_screen_y_transform(30)))
        
        self.return_button = MyButton(frame: CGRect(x: pause_screen_x_transform(20), y: pause_screen_y_transform(15), width: pause_screen_x_transform(30), height: pause_screen_y_transform(30)))
        //add buttons
        day_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y: white_cover.frame.origin.y + white_cover.frame.height, width: screen_width, height: theme_button_height))
       day_theme_origin = day_theme_button.frame.origin
        day_theme_button.image = #imageLiteral(resourceName: "day_mode_theme_menu_button")
        day_apply_button.contentMode = .scaleAspectFit
        day_theme_button.alpha = 0
        day_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: day_theme_button.frame.origin.y + day_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
            if (self.language == "English"){
                self.day_apply_button.setImage(#imageLiteral(resourceName: "day_mode_use"), for: .normal)
            }
            else {
                self.day_apply_button.setImage(#imageLiteral(resourceName: "day_mode_use_ch"), for: .normal)
            }
        
        if(ThemeType == 1){
            day_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            day_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            if (self.language == "English"){
                self.day_apply_button.setImage(#imageLiteral(resourceName: "day_selected"), for: .normal)
            }
            else {
                self.day_apply_button.setImage(#imageLiteral(resourceName: "day_selected_ch"), for: .normal)
            }

            
        }
        day_apply_origin = day_apply_button.frame.origin
        day_apply_button.whenButtonIsClicked(action:{
            if(self.ThemeType != 1){
                if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
                }
            
            self.apply_button_restore()
                
            self.ThemeType = 1
            defaults.set(1, forKey:"tritri_Theme")
            self.view.backgroundColor = UIColor(red: 254.0/255, green: 253.0/255, blue: 252.0/255, alpha: 1.0)
            self.background_image.alpha = 0
            self.trophy.image = #imageLiteral(resourceName: "day_mode_trophy")
            if (self.language == "English"){
                self.triangle_title.image = UIImage(named: "day mode triangle title")
            }
            else {
                self.triangle_title.image = UIImage(named: "san_title_day")
            }
            //self.language_button_image_decider()
            self.settings_scene.image = #imageLiteral(resourceName: "settings_scene_day&night")
            self.gear_icon.image = #imageLiteral(resourceName: "gear_day&night")
            self.settings_functional_button_image_decider()
            self.settings_button.setImage(#imageLiteral(resourceName: "settings_day"), for: .normal)
            self.like_button.setBackgroundImage(UIImage(named: "day mode like"), for: .normal)
            self.highest_score.textColor = UIColor(red: 26.0/255, green: 58.0/255, blue: 49.0/255, alpha: 1)
            self.continue_button.setImage(UIImage(named:"continue"), for: .normal)
            self.shopping_cart.setImage(UIImage(named:"shopping_cart"), for: .normal)
            self.star_board.textColor = UIColor(red: 46.0/255, green: 62.0/255, blue: 59.0/255, alpha: 1.0)
            self.star_counter.setImage(#imageLiteral(resourceName: "day_mode_star"), for: .normal)
            self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
            self.theme_star_board.textColor = UIColor(red: 46.0/255, green: 62.0/255, blue: 59.0/255, alpha: 1.0)
            self.gift_button.setImage(#imageLiteral(resourceName: "gift_day_mode"), for: .normal)
            self.tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_day_night"), for: .normal)
            self.treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_day_mode"), for: .normal)
            self.remove_all_fragments()
            self.split_star_counter()
            self.update_star_counter_length_according_to_string_length()
            self.reorder_star_counter()
            //self.trophy.image = UIImage(named:"trophy_new")
            //self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
           // self.gameover_title.image = UIImage(named:"day mode gameover title")
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
            
           //change apply button image first
            UIView.transition(with: self.day_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                    self.day_apply_button.frame.origin.x -= self.pause_screen_x_transform(16)
                    self.day_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(132), height: self.pause_screen_y_transform(36))
                if (self.language == "English"){
                    self.day_apply_button.setImage(#imageLiteral(resourceName: "day_selected"), for: .normal)
                }
                else {
                    self.day_apply_button.setImage(#imageLiteral(resourceName: "day_selected_ch"), for: .normal)
                }

                
            }, completion: {
                (finished) -> Void in
                
                
                self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                    self.day_theme_button.removeFromSuperview()
                    self.night_theme_button.removeFromSuperview()
                    self.BW_theme_button.removeFromSuperview()
                    //self.chaos_theme_button.removeFromSuperview()
                    self.school_theme_button.removeFromSuperview()
                    self.colors_theme_button.removeFromSuperview()
                    
                    self.day_apply_button.removeFromSuperview()
                    self.night_apply_button.removeFromSuperview()
                    self.BW_apply_button.removeFromSuperview()
                    self.school_apply_button.removeFromSuperview()
                    self.colors_apply_button.removeFromSuperview()
                    
                    self.BW_saleConer.removeFromSuperview()
                    self.school_saleConer.removeFromSuperview()
                    self.colors_saleConer.removeFromSuperview()
                    
                    self.in_theme_menu = false
                })
                
                self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                    
                    
                    triangle_text.removeFromSuperview()
                    self.return_button.removeFromSuperview()
                    self.theme_star_counter.removeFromSuperview()
                    self.theme_star_board.removeFromSuperview()
                    self.remove_all_theme_star_counter_fragments()
                })
                
                
                
            })

                

                
                
            }else{
                if(!self.sound_is_muted){
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
                }
                self.day_apply_button.imageView?.shake(duration: 0.3)
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
            if (self.language == "English"){
                self.night_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
            }
            else {
                self.night_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
            }
        
        if(ThemeType == 2){
            night_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            night_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            if (self.language == "English"){
                self.night_apply_button.setImage( #imageLiteral(resourceName: "night_selected"), for: .normal)
            }
            else {
                self.night_apply_button.setImage( #imageLiteral(resourceName: "night_selected_ch"), for: .normal)
            }
            
        }
        night_apply_origin = night_apply_button.frame.origin
        night_apply_button.whenButtonIsClicked(action:{
            if(self.ThemeType != 2){
                if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
                
            self.button_player.play()
                }
            self.apply_button_restore()
            self.ThemeType = 2
            self.trophy.image = #imageLiteral(resourceName: "night_mode_trophy")
            self.like_button.setBackgroundImage(UIImage(named: "night mode like button"), for: .normal)
            defaults.set(2, forKey:"tritri_Theme")
            self.view.backgroundColor = UIColor(red: 23.0/255, green: 53.0/255, blue: 52.0/255, alpha: 1.0)
            self.background_image.alpha = 0
            if (self.language == "English"){
                self.triangle_title.image = UIImage(named: "night mode triangle title")
            }
            else {
                self.triangle_title.image = UIImage(named: "san_title_night")
            }
            //self.language_button_image_decider()
            self.settings_scene.image = #imageLiteral(resourceName: "settings_scene_day&night")
            self.gear_icon.image = #imageLiteral(resourceName: "gear_day&night")
            self.settings_functional_button_image_decider()
            self.settings_button.setImage(#imageLiteral(resourceName: "settings_day"), for: .normal)
            self.highest_score.textColor = UIColor(red: 167.0/255, green: 157.0/255, blue: 124.0/255, alpha: 1)
            self.continue_button.setImage(UIImage(named:"continue"), for: .normal)
            self.shopping_cart.setImage(UIImage(named:"shopping_cart"), for: .normal)
            self.star_board.textColor = UIColor.white
            self.star_counter.setImage(#imageLiteral(resourceName: "night_mode_star"), for: .normal)
            self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
            self.theme_star_board.textColor = UIColor.black
            self.gift_button.setImage(#imageLiteral(resourceName: "gift_night_mode"), for: .normal)
            self.tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_day_night"), for: .normal)
            self.treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_night_mode"), for: .normal)
            self.remove_all_fragments()
            self.split_star_counter()
            self.update_star_counter_length_according_to_string_length()
            self.reorder_star_counter()
           // self.trophy.image = UIImage(named:"night mode 奖杯")
           // self.score_board.textColor = UIColor(red: 255.0/255, green: 254.0/255, blue: 243.0/255, alpha: 1.0)
           // self.gameover_title.image = UIImage(named:"night mode gameover title")
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))

           //change apply button first
                UIView.transition(with: self.night_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                    self.night_apply_button.frame.origin.x -= self.pause_screen_x_transform(16)
                    self.night_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(132), height: self.pause_screen_y_transform(36))
                    if (self.language == "English"){
                        self.night_apply_button.setImage( #imageLiteral(resourceName: "night_selected"), for: .normal)
                    }
                    else {
                        self.night_apply_button.setImage( #imageLiteral(resourceName: "night_selected_ch"), for: .normal)
                    }
                }, completion: {
                    (finished) -> Void in
                    self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        self.day_theme_button.removeFromSuperview()
                        self.night_theme_button.removeFromSuperview()
                        self.BW_theme_button.removeFromSuperview()
                        //self.chaos_theme_button.removeFromSuperview()
                        self.school_theme_button.removeFromSuperview()
                        self.colors_theme_button.removeFromSuperview()
                        
                        self.day_apply_button.removeFromSuperview()
                        self.night_apply_button.removeFromSuperview()
                        self.BW_apply_button.removeFromSuperview()
                        self.school_apply_button.removeFromSuperview()
                        self.colors_apply_button.removeFromSuperview()
                        
                        self.BW_saleConer.removeFromSuperview()
                        self.school_saleConer.removeFromSuperview()
                        self.colors_saleConer.removeFromSuperview()
                        
                        self.in_theme_menu = false
                    })
                    self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        
                        
                        triangle_text.removeFromSuperview()
                        self.return_button.removeFromSuperview()
                        self.theme_star_counter.removeFromSuperview()
                        self.theme_star_board.removeFromSuperview()
                        self.remove_all_theme_star_counter_fragments()
                    })

                
                
                })
                
                
                
                
            }else{
                if(!self.sound_is_muted){
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
                }
                 self.night_apply_button.imageView?.shake(duration: 0.3)
            }
        })
        theme_menu.addSubview(night_theme_button)
        night_theme_button.fadeInWithDisplacement()
        theme_menu.addSubview(night_apply_button)
        night_apply_button.fadeInWithDisplacement()
        
        BW_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y: night_theme_button.frame.origin.y + night_theme_button.frame.height, width: screen_width, height: theme_button_height))
        BW_theme_origin = BW_theme_button.frame.origin
        //sale corner
        BW_saleConer.frame = CGRect(origin: BW_theme_button.frame.origin, size: CGSize(width: screen_width/4.5, height: screen_width/4.5))
        BW_theme_button.image = #imageLiteral(resourceName: "BW_theme_menu_button")
        BW_saleConer.image = #imageLiteral(resourceName: "salecorner")
        BW_theme_button.contentMode = .scaleAspectFill
        BW_theme_button.alpha = 0
        BW_saleConer.alpha = 0
        BW_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: BW_theme_button.frame.origin.y + BW_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        if(theme_islocked_array[2]){
        //BW_apply_button.frame.origin.x -= pause_screen_x_transform(7)
        //BW_apply_button.frame.size = CGSize(width: pause_screen_x_transform(114), height: pause_screen_y_transform(36))
        //BW_apply_button.setImage(#imageLiteral(resourceName: "BW_price"), for: .normal)
        
        //sale
            BW_apply_button.frame.origin.x -= pause_screen_x_transform(3)
            BW_apply_button.frame.size = CGSize(width: pause_screen_x_transform(106), height: pause_screen_y_transform(36))
            BW_apply_button.setImage(#imageLiteral(resourceName: "colors_price_sale"), for: .normal)
        }else if(ThemeType == 3){
            BW_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            BW_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            if (self.language == "English"){
                self.BW_apply_button.setImage(#imageLiteral(resourceName: "BW_selected"), for: .normal)
            }
            else {
                self.BW_apply_button.setImage(#imageLiteral(resourceName: "B&W_selected_ch"), for: .normal)
            }
        
        }
        else{
            if (self.language == "English"){
                self.BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
            }
            else {
                self.BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
            }
        }
        BW_apply_origin = BW_apply_button.frame.origin
        BW_apply_button.whenButtonIsClicked(action:{
            if(self.theme_islocked_array[2]){
                if(self.star_score >= 2000){
                    if(!self.sound_is_muted){
                    do{self.cash_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cash_register", ofType: "wav")!))
                        self.cash_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.cash_player.play()
                    }
                    //self.star_score -= 1000
                    //sale
                    self.star_score -= 500
                    defaults.set(self.star_score, forKey: "tritri_star_score")
                    self.theme_star_board.text = String(self.star_score)
                    self.star_board.text = String(self.star_score)
                    self.theme_islocked_array[2] = false
                    defaults.set(self.theme_islocked_array, forKey: "tritri_theme_lock_array")
                   
                    UIView.transition(with: self.BW_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                        self.BW_apply_button.frame = CGRect(x: self.screen_width - self.pause_screen_y_transform(130), y: self.BW_theme_button.frame.origin.y + self.BW_theme_button.frame.height/2.0 - self.pause_screen_y_transform(18), width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                        if (self.language == "English"){
                            self.BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
                        }
                        else {
                            self.BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
                        }
                    })

                    
                    
                }else{
                    if(!self.sound_is_muted){
                    do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                        self.wrong_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.wrong_player.play()
                    }
                    self.BW_apply_button.imageView?.shake(duration: 0.3)
                }
                
                
            }
            else if(self.ThemeType != 3){
                if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
                }
            self.apply_button_restore()
            self.ThemeType = 3
            defaults.set(3, forKey:"tritri_Theme")
           //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"BW_background")!)
            self.background_image.alpha = 1
            self.background_image.image = #imageLiteral(resourceName: "BW_background")
            self.trophy.image = #imageLiteral(resourceName: "BW_mode_trophy")
            if (self.language == "English"){
                self.triangle_title.image = UIImage(named: "day mode triangle title")
            }
            else {
                self.triangle_title.image = UIImage(named: "san_title_day")
            }
            //self.language_button_image_decider()
            self.settings_scene.image = #imageLiteral(resourceName: "settings_scene_bw")
            self.gear_icon.image = #imageLiteral(resourceName: "gear_bw&colors")
            self.settings_functional_button_image_decider()
            self.settings_button.setImage(#imageLiteral(resourceName: "settings_bw"), for: .normal)
            self.like_button.setBackgroundImage(UIImage(named: "BW_like"), for: .normal)
            self.highest_score.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1)
            self.shopping_cart.setImage(UIImage(named:"BW_shopping"), for: .normal)
            self.continue_button.setImage(UIImage(named:"BW_continue"), for: .normal)
            self.star_board.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1.0)
            self.star_counter.setImage(#imageLiteral(resourceName: "BW_mode_star"), for: .normal)
            self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
            self.theme_star_board.textColor = UIColor(red: 1.0/255, green: 1.0/255, blue: 1.0/255, alpha: 1.0)
            self.gift_button.setImage(#imageLiteral(resourceName: "gift_BW_mode"), for: .normal)
            self.tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_B&W"), for: .normal)
            self.treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_bw_mode"), for: .normal)
            self.remove_all_fragments()
            self.split_star_counter()
            self.update_star_counter_length_according_to_string_length()
            self.reorder_star_counter()
            //self.trophy.image = UIImage(named:"trophy_new")
            //self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
            // self.gameover_title.image = UIImage(named:"day mode gameover title")
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
            
           
                //change apply button first
                UIView.transition(with: self.BW_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                    self.BW_apply_button.frame.origin.x -= self.pause_screen_x_transform(16)
                    self.BW_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(132), height: self.pause_screen_y_transform(36))
                    if (self.language == "English"){
                        self.BW_apply_button.setImage(#imageLiteral(resourceName: "BW_selected"), for: .normal)
                    }
                    else {
                        self.BW_apply_button.setImage(#imageLiteral(resourceName: "B&W_selected_ch"), for: .normal)
                    }
                }, completion: {
                    (finished) -> Void in
                    self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        self.day_theme_button.removeFromSuperview()
                        self.night_theme_button.removeFromSuperview()
                        self.BW_theme_button.removeFromSuperview()
                        //self.chaos_theme_button.removeFromSuperview()
                        self.school_theme_button.removeFromSuperview()
                        self.colors_theme_button.removeFromSuperview()
                        
                        self.day_apply_button.removeFromSuperview()
                        self.night_apply_button.removeFromSuperview()
                        self.BW_apply_button.removeFromSuperview()
                        self.school_apply_button.removeFromSuperview()
                        self.colors_apply_button.removeFromSuperview()
                        
                        self.BW_saleConer.removeFromSuperview()
                        self.school_saleConer.removeFromSuperview()
                        self.colors_saleConer.removeFromSuperview()
                        
                        self.in_theme_menu = false
                    })
                    self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        
                        
                        triangle_text.removeFromSuperview()
                        self.return_button.removeFromSuperview()
                        self.theme_star_counter.removeFromSuperview()
                        self.theme_star_board.removeFromSuperview()
                        self.remove_all_theme_star_counter_fragments()
                    })
    
                    
                    
                    
                    
                })
     
            
                
                
                
            }else{
                if(!self.sound_is_muted){
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
                }
                self.BW_apply_button.imageView?.shake(duration: 0.3)
            }
            
            
            
            
            
            
        })
        theme_menu.addSubview(BW_theme_button)
        BW_theme_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(BW_apply_button)
        BW_apply_button.fadeInWithDisplacement()
            
        theme_menu.addSubview(BW_saleConer)
        BW_saleConer.fadeInWithDisplacement()
            
        chaos_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(206), y: pause_screen_y_transform(319), width: pause_screen_x_transform(144), height: pause_screen_y_transform(144)))
        chaos_theme_origin = chaos_theme_button.frame.origin
       // chaos_theme_button.setBackgroundImage(UIImage(named:"Chaos_theme"), for: .normal)
        chaos_theme_button.alpha = 0
       /** chaos_theme_button.whenButtonIsClicked(action:{
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
            self.triangle_title.image = UIImage(named: "night mode triangle title")
            self.like_button.setBackgroundImage(UIImage(named: "chaos_like_icon"), for: .normal)
            self.highest_score.textColor = UIColor(red: 236.0/255, green: 232.0/255, blue: 187.0/255, alpha: 1.0)
            self.shopping_cart.setImage(UIImage(named:"chaos_theme_button"), for: .normal)
            self.continue_button.setImage(UIImage(named:"chaos_start_icon"), for: .normal)
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
        school_saleConer.frame = CGRect(origin: school_theme_button.frame.origin, size: CGSize(width: screen_width/4.5, height: screen_width/4.5))
        school_theme_button.image = #imageLiteral(resourceName: "school_mode_theme_menu_button")
        school_saleConer.image = #imageLiteral(resourceName: "salecorner")
        school_theme_button.contentMode = .scaleAspectFit
        school_theme_button.alpha = 0
        school_saleConer.alpha = 0
        school_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: school_theme_button.frame.origin.y + school_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        if(theme_islocked_array[3]){
            //school_apply_button.frame.origin.x -= pause_screen_x_transform(7)
            //school_apply_button.frame.size = CGSize(width: pause_screen_x_transform(114), height: pause_screen_y_transform(36))
         //school_apply_button.setImage(#imageLiteral(resourceName: "school_price"), for: .normal)
        //sale
            school_apply_button.frame.origin.x -= pause_screen_x_transform(3)
            school_apply_button.frame.size = CGSize(width: pause_screen_x_transform(106), height: pause_screen_y_transform(36))
            school_apply_button.setImage(#imageLiteral(resourceName: "school_price_sale"), for: .normal)

        }else if(ThemeType == 5){
            school_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            school_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            if (self.language == "English"){
                self.school_apply_button.setImage(#imageLiteral(resourceName: "school_selected"), for: .normal)
            }
            else {
                self.school_apply_button.setImage(#imageLiteral(resourceName: "school_selected_ch"), for: .normal)
            }
            
        }
        else{
            if (self.language == "English"){
                self.school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use"), for: .normal)
            }
            else {
                self.school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use_ch"), for: .normal)
            }
        }
        
        school_apply_origin = school_apply_button.frame.origin
        school_apply_button.whenButtonIsClicked(action:{
            if(self.theme_islocked_array[3]){
                if(self.star_score >= 500){
                    if(!self.sound_is_muted){
                    do{self.cash_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cash_register", ofType: "wav")!))
                        self.cash_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.cash_player.play()
                    }
                    //self.star_score -= 1000
                    //sale
                     self.star_score -= 500
                    defaults.set(self.star_score, forKey: "tritri_star_score")
                    self.theme_star_board.text = String(self.star_score)
                    self.star_board.text = String(self.star_score)
                    self.theme_islocked_array[3] = false
                    defaults.set(self.theme_islocked_array, forKey: "tritri_theme_lock_array")

                    
                    UIView.transition(with: self.school_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                         self.school_apply_button.frame = CGRect(x: self.screen_width - self.pause_screen_y_transform(130), y: self.school_theme_button.frame.origin.y + self.school_theme_button.frame.height/2.0 - self.pause_screen_y_transform(18), width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                        if (self.language == "English"){
                            self.school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use"), for: .normal)
                        }
                        else {
                            self.school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use_ch"), for: .normal)
                        }
                    })

                   }else{
                    if(!self.sound_is_muted){
                    do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                        self.wrong_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.wrong_player.play()
                    }
                    self.school_apply_button.imageView?.shake(duration: 0.3)
                }
                
                
            }
            else if(self.ThemeType != 5){
                if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
                }
            self.apply_button_restore()
            self.ThemeType = 5
            defaults.set(5, forKey:"tritri_Theme")
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "school_background")!)
            self.background_image.alpha = 1
            self.background_image.image = #imageLiteral(resourceName: "school_background")
            self.trophy.image = #imageLiteral(resourceName: "school_mode_trophy")
            if (self.language == "English"){
                self.triangle_title.image = UIImage(named: "school_triangle_title")
            }
            else {
                self.triangle_title.image = UIImage(named: "san_title_school")
            }
            //self.language_button_image_decider()
            self.settings_scene.image = #imageLiteral(resourceName: "settings_scene_school")
            self.gear_icon.image = #imageLiteral(resourceName: "gear_school")
            self.settings_functional_button_image_decider()
            self.settings_button.setImage(#imageLiteral(resourceName: "settings_school"), for: .normal)
            self.like_button.setBackgroundImage(UIImage(named: "school_like-icon"), for: .normal)
            self.highest_score.textColor = UIColor(red: 34.0/255, green: 61.0/255, blue: 128.0/255, alpha: 1.0)
            self.shopping_cart.setImage(UIImage(named:"school_theme-button"), for: .normal)
            self.continue_button.setImage(UIImage(named:"school_start-icon"), for: .normal)
            self.star_board.textColor = UIColor(red: 68.0/255, green: 84.0/255, blue: 140.0/255, alpha: 1.0)
            self.star_counter.setImage(#imageLiteral(resourceName: "school_mode_star"), for: .normal)
            self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
            self.theme_star_board.textColor = UIColor(red: 68.0/255, green: 84.0/255, blue: 140.0/255, alpha: 1.0)
            self.gift_button.setImage(#imageLiteral(resourceName: "gift_school_mode"), for: .normal)
            self.tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_school"), for: .normal)
            self.treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_school_mode"), for: .normal)
            //self.trophy.image = UIImage(named:"trophy_new")
            //self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
            // self.gameover_title.image = UIImage(named:"day mode gameover title")
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
                self.remove_all_fragments()
                self.split_star_counter()
                self.update_star_counter_length_according_to_string_length()
            self.reorder_star_counter()
            
                //change apply button first
                UIView.transition(with: self.school_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                    self.school_apply_button.frame.origin.x -= self.pause_screen_x_transform(16)
                    self.school_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(132), height: self.pause_screen_y_transform(36))
                    if (self.language == "English"){
                        self.school_apply_button.setImage(#imageLiteral(resourceName: "school_selected"), for: .normal)
                    }
                    else {
                        self.school_apply_button.setImage(#imageLiteral(resourceName: "school_selected_ch"), for: .normal)
                    }
                }, completion: {
                    (finished) -> Void in
                    self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        self.day_theme_button.removeFromSuperview()
                        self.night_theme_button.removeFromSuperview()
                        self.BW_theme_button.removeFromSuperview()
                        //self.chaos_theme_button.removeFromSuperview()
                        self.school_theme_button.removeFromSuperview()
                        self.colors_theme_button.removeFromSuperview()
                        
                        self.day_apply_button.removeFromSuperview()
                        self.night_apply_button.removeFromSuperview()
                        self.BW_apply_button.removeFromSuperview()
                        self.school_apply_button.removeFromSuperview()
                        self.colors_apply_button.removeFromSuperview()
                        
                        self.BW_saleConer.removeFromSuperview()
                        self.school_saleConer.removeFromSuperview()
                        self.colors_saleConer.removeFromSuperview()
                        
                        self.in_theme_menu = false
                    })
                    self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        
                        
                        triangle_text.removeFromSuperview()
                        self.return_button.removeFromSuperview()
                        self.theme_star_counter.removeFromSuperview()
                        self.theme_star_board.removeFromSuperview()
                        self.remove_all_theme_star_counter_fragments()
                    })
                    
                })
                
                
            
            
            
            

            
                
            }else{
                if(!self.sound_is_muted){
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
                }
                self.school_apply_button.imageView?.shake(duration: 0.3)
            }
        })
        theme_menu.addSubview(school_theme_button)
        school_theme_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(school_apply_button)
        school_apply_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(school_saleConer)
        school_saleConer.fadeInWithDisplacement()
            
        colors_theme_button = UIImageView(frame: CGRect(x: pause_screen_x_transform(0), y: school_theme_button.frame.origin.y + school_theme_button.frame.height, width: screen_width, height: theme_button_height))
        colors_theme_origin = colors_theme_button.frame.origin
        colors_saleConer.frame = CGRect(origin: colors_theme_button.frame.origin, size: CGSize(width: screen_width/4.5, height: screen_width/4.5))
        colors_theme_button.image = #imageLiteral(resourceName: "colors_theme_menu_button")
        colors_saleConer.image = #imageLiteral(resourceName: "salecorner")
        colors_theme_button.contentMode = .scaleAspectFit
        colors_theme_button.alpha = 0
        colors_saleConer.alpha = 0
        colors_apply_button.frame = CGRect(x: screen_width - pause_screen_y_transform(130), y: colors_theme_button.frame.origin.y + colors_theme_button.frame.height/2.0 - pause_screen_y_transform(18), width: pause_screen_x_transform(100), height: pause_screen_y_transform(36))
        if(theme_islocked_array[4]){
            //colors_apply_button.frame.origin.x -= pause_screen_x_transform(7)
            //colors_apply_button.frame.size = CGSize(width: pause_screen_x_transform(114), height: pause_screen_y_transform(36))

            //colors_apply_button.setImage(#imageLiteral(resourceName: "colors_price"), for: .normal)
            //sale
            colors_apply_button.frame.origin.x -= pause_screen_x_transform(3)
            colors_apply_button.frame.size = CGSize(width: pause_screen_x_transform(106), height: pause_screen_y_transform(36))
            
            colors_apply_button.setImage(#imageLiteral(resourceName: "colors_price_sale"), for: .normal)

        }else if(ThemeType == 6){
            colors_apply_button.frame.origin.x -= pause_screen_x_transform(16)
            colors_apply_button.frame.size = CGSize(width: pause_screen_x_transform(132), height: pause_screen_y_transform(36))
            if (self.language == "English"){
                self.colors_apply_button.setImage(#imageLiteral(resourceName: "colors_selected"), for: .normal)
            }
            else {
                self.colors_apply_button.setImage(#imageLiteral(resourceName: "color_selected_ch"), for: .normal)
            }
         
        }
        else{
            if (self.language == "English"){
                self.colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
            }
            else {
                self.colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
            }
            
        }
        
            
        colors_apply_origin = colors_apply_button.frame.origin
        colors_apply_button.whenButtonIsClicked(action:{
            if(self.theme_islocked_array[4]){
                if(self.star_score >= 500){
                    if(!self.sound_is_muted){
                    do{self.cash_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cash_register", ofType: "wav")!))
                        self.cash_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.cash_player.play()
                    }
                    //self.star_score -= 1000
                    //sale
                     self.star_score -= 500
                    defaults.set(self.star_score, forKey: "tritri_star_score")
                    self.star_board.text = String(self.star_score)
                    self.theme_star_board.text = String(self.star_score)
                    self.theme_islocked_array[4] = false
                    defaults.set(self.theme_islocked_array, forKey: "tritri_theme_lock_array")
                    
                    UIView.transition(with: self.colors_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                        self.colors_apply_button.frame = CGRect(x: self.screen_width - self.pause_screen_y_transform(130), y: self.colors_theme_button.frame.origin.y + self.colors_theme_button.frame.height/2.0 - self.pause_screen_y_transform(18), width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                        if (self.language == "English"){
                            self.colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
                        }
                        else {
                            self.colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
                        }
                        
                    })
                    }else{
                    if(!self.sound_is_muted){
                    do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                        self.wrong_player.prepareToPlay()
                    }
                    catch{
                        
                    }
                    self.wrong_player.play()
                    }
                    self.colors_apply_button.imageView?.shake(duration: 0.3)
                }
                
                
            }
            else if(self.ThemeType != 6){
                if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
                }
            self.apply_button_restore()
            self.ThemeType = 6
            defaults.set(6, forKey:"tritri_Theme")
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "colors_background")!)
            self.background_image.alpha = 1
            self.background_image.image = #imageLiteral(resourceName: "colors_background")
            self.trophy.image = #imageLiteral(resourceName: "colors_mode_trophy")
            if (self.language == "English"){
                self.triangle_title.image = UIImage(named: "night mode triangle title")
            }
            else {
                self.triangle_title.image = UIImage(named: "san_title_night")
            }
            //self.language_button_image_decider()
            self.settings_scene.image = #imageLiteral(resourceName: "settings_scene_colors")
            self.gear_icon.image = #imageLiteral(resourceName: "gear_bw&colors")
            self.settings_functional_button_image_decider()
            self.settings_button.setImage(#imageLiteral(resourceName: "settings_colors"), for: .normal)
            self.like_button.setBackgroundImage(UIImage(named: "colors_like-icon"), for: .normal)
            self.highest_score.textColor = UIColor(red: 255.0/255, green: 195.0/255, blue: 1.0/255, alpha: 1.0)
            self.shopping_cart.setImage(UIImage(named:"colors_theme-button"), for: .normal)
            self.continue_button.setImage(UIImage(named:"colors_start"), for: .normal)
            self.star_board.textColor = UIColor(red: 81.0/255, green: 195.0/255, blue: 247.0/255, alpha: 1.0)
            self.star_counter.setImage(#imageLiteral(resourceName: "colors_mode_star"), for: .normal)
            self.theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
            self.theme_star_board.textColor = UIColor(red: 81.0/255, green: 195.0/255, blue: 247.0/255, alpha: 1.0)
            self.gift_button.setImage(#imageLiteral(resourceName: "gift_color_mode"), for: .normal)
            self.tutorial_button.setBackgroundImage(#imageLiteral(resourceName: "tuto_icon_color"), for: .normal)
            self.treasure_box_icon.setImage(#imageLiteral(resourceName: "treasure_color_mode"), for: .normal)
            self.remove_all_fragments()
            self.split_star_counter()
            self.update_star_counter_length_according_to_string_length()
            self.reorder_star_counter()
            //self.trophy.image = UIImage(named:"trophy_new")
            //self.score_board.textColor = UIColor(red: 59/255, green: 76/255, blue: 65/255, alpha: 1.0)
            // self.gameover_title.image = UIImage(named:"day mode gameover title")
            self.theme_menu.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
                
            //change apply button first
                
                UIView.transition(with: self.colors_apply_button, duration: 0.4, options: .transitionFlipFromRight, animations: {
                    self.colors_apply_button.frame.origin.x -= self.pause_screen_x_transform(16)
                    self.colors_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(132), height: self.pause_screen_y_transform(36))
                    if (self.language == "English"){
                        self.colors_apply_button.setImage(#imageLiteral(resourceName: "colors_selected"), for: .normal)
                    }
                    else {
                        self.colors_apply_button.setImage(#imageLiteral(resourceName: "color_selected_ch"), for: .normal)
                    }
                }, completion: {
                    (finished) -> Void in
                    self.theme_menu.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        self.day_theme_button.removeFromSuperview()
                        self.night_theme_button.removeFromSuperview()
                        self.BW_theme_button.removeFromSuperview()
                        //self.chaos_theme_button.removeFromSuperview()
                        self.school_theme_button.removeFromSuperview()
                        self.colors_theme_button.removeFromSuperview()
                        
                        self.day_apply_button.removeFromSuperview()
                        self.night_apply_button.removeFromSuperview()
                        self.BW_apply_button.removeFromSuperview()
                        self.school_apply_button.removeFromSuperview()
                        self.colors_apply_button.removeFromSuperview()
                        
                        self.BW_saleConer.removeFromSuperview()
                        self.school_saleConer.removeFromSuperview()
                        self.colors_saleConer.removeFromSuperview()
                        
                        self.in_theme_menu = false
                    })
                    self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                        
                        
                        triangle_text.removeFromSuperview()
                        self.return_button.removeFromSuperview()
                        self.theme_star_counter.removeFromSuperview()
                        self.theme_star_board.removeFromSuperview()
                        self.remove_all_theme_star_counter_fragments()
                    })
                    
   
                    
                })

            
            
                
            
            
            
            }else{
                if(!self.sound_is_muted){
                do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                    self.wrong_player.prepareToPlay()
                }
                catch{
                    
                }
                self.wrong_player.play()
                }
                self.colors_apply_button.imageView?.shake(duration: 0.3)
            }
        })
        
        theme_menu.addSubview(colors_theme_button)
        colors_theme_button.fadeInWithDisplacement()
        
        theme_menu.addSubview(colors_apply_button)
        colors_apply_button.fadeInWithDisplacement()
            
        theme_menu.addSubview(colors_saleConer)
        colors_saleConer.fadeInWithDisplacement()
            
        //add white to 遮挡
        
        white_cover.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
        white_cover.alpha = 0
        self.view.addSubview(white_cover)
        white_cover.fadeIn()
        
        
        //add triangle text
        if (self.language == "English"){
            triangle_text.frame = CGRect(x: pause_screen_x_transform(127), y: pause_screen_y_transform(15), width: pause_screen_x_transform(120), height: pause_screen_y_transform(29.35))
            triangle_text.image = UIImage(named: "day mode triangle title")
        }
        else {
            triangle_text.frame = CGRect(x: pause_screen_x_transform(110), y: pause_screen_y_transform(15), width: pause_screen_x_transform(155), height: pause_screen_y_transform(35))
            triangle_text.image = UIImage(named: "san_title_day")
        }
        
        //triangle_text.sizeToFit()
        triangle_text.alpha = 0
        white_cover.addSubview(triangle_text)
        triangle_text.fadeIn()
        
        
        //set setheme star counter image
        theme_star_counter.image = #imageLiteral(resourceName: "current_star_total")
        theme_star_counter.alpha = 1
        
        //theme_star_counter.fadeInWithDisplacement()
        
        
        
        //add text
        theme_star_board.font = UIFont(name: "Fresca-Regular", size: CGFloat(20))
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
        theme_star_board_width = theme_star_board.frame.width
        theme_star_board.alpha = 0
        white_cover.addSubview(theme_star_board)
        theme_star_board.fadeIn()
        
        split_theme_star_counter()
        theme_menu_star_store_button.frame = theme_star_counter.frame
        update_theme_star_length_according_to_string_length()
    //add theme menu star store button
        theme_menu_star_store_button.alpha = 0.02
        theme_menu_star_store_button.setImage(#imageLiteral(resourceName: "current_star_total"), for: .normal)
        self.view.addSubview(theme_menu_star_store_button)
        self.view.bringSubview(toFront: theme_menu_star_store_button)
            theme_menu_star_store_button.whenButtonIsClicked(action: {
                if(!self.sound_is_muted){
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
                }
               self.purchase_star_function()
                
                
                
                
            })
            
            
            
            
            
            
            
        theme_star_counter.alpha = 0
        white_cover.addSubview(theme_star_counter)
            
        //add  return button
        
        return_button.setBackgroundImage(UIImage(named:"return_button"), for: .normal)
        
        
        return_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
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
                
                self.BW_saleConer.removeFromSuperview()
                self.school_saleConer.removeFromSuperview()
                self.colors_saleConer.removeFromSuperview()
                self.in_theme_menu = false
    
            })
            self.white_cover.twoPointBounceOut(translation1_y: -self.white_cover_y, translation2_y: self.screen_height, final_completetion: {
                self.theme_star_counter.fadeOutandRemove()
                self.theme_star_board.fadeOutandRemove()
                triangle_text.fadeOutandRemove()
                self.return_button.fadeOutandRemove()
                self.remove_all_theme_star_counter_fragments_with_fading()
            })

           
        })
        
        return_button.alpha = 0
        white_cover.addSubview(return_button)
        return_button.fadeIn()
        
        
   theme_menu.alpha = 1
   theme_menu.contentSize.height = colors_theme_button.frame.origin.y + theme_button_height
   theme_menu.showsVerticalScrollIndicator = false
   //bounce in
   theme_menu.transform = CGAffineTransform(translationX: 0, y: screen_height)
        UIView.animate(withDuration: 0.7, delay: 00, usingSpringWithDamping: 0.75, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
          self.theme_menu.transform = .identity
        }, completion: nil)
        
    }
    }
    
    
    
    
    
    
    
    
    
    
    
    func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer){
        let transition0 = gesture.translation(in: day_theme_button)
        //上1/3和下1/3的空间
        if(day_theme_button.frame.origin.y < (white_cover_y+day_theme_button.frame.height/3.5) && colors_theme_button.frame.origin.y > pause_screen_y_transform(493+144) - colors_theme_button.frame.height/3 - colors_theme_button.frame.height){
            day_theme_button.frame.origin = CGPoint(x: day_theme_origin.x, y: (day_theme_origin.y + transition0.y))
            night_theme_button.frame.origin = CGPoint(x: night_theme_origin.x, y: (night_theme_origin.y + transition0.y))
            BW_theme_button.frame.origin = CGPoint(x: BW_theme_origin.x, y: (BW_theme_origin.y + transition0.y))
            chaos_theme_button.frame.origin = CGPoint(x: chaos_theme_origin.x, y: (chaos_theme_origin.y + transition0.y))
            school_theme_button.frame.origin = CGPoint(x: school_theme_origin.x, y: (school_theme_origin.y + transition0.y))
            colors_theme_button.frame.origin = CGPoint(x: colors_theme_origin.x, y: (colors_theme_origin.y + transition0.y))
            
            
            day_apply_button.frame.origin = CGPoint(x: day_apply_origin.x, y: (day_apply_origin.y + transition0.y))
            night_apply_button.frame.origin = CGPoint(x: night_apply_origin.x, y: (night_apply_origin.y + transition0.y))
            BW_apply_button.frame.origin = CGPoint(x: BW_apply_origin.x, y: (BW_apply_origin.y + transition0.y))
            school_apply_button.frame.origin = CGPoint(x: school_apply_origin.x, y: (school_apply_origin.y + transition0.y))
            colors_apply_button.frame.origin = CGPoint(x: colors_apply_origin.x, y: (colors_apply_origin.y + transition0.y))
            
            
            if(gesture.state == .ended){
                
                
                    
                    self.day_theme_origin.y = self.day_theme_button.frame.origin.y
                    self.night_theme_origin.y = self.night_theme_button.frame.origin.y
                    self.BW_theme_origin.y = self.BW_theme_button.frame.origin.y
                    self.chaos_theme_origin.y = self.chaos_theme_button.frame.origin.y
                    self.school_theme_origin.y = self.school_theme_button.frame.origin.y
                    self.colors_theme_origin.y = self.colors_theme_button.frame.origin.y
                    
                    self.day_apply_origin.y = self.day_apply_button.frame.origin.y
                    self.night_apply_origin.y = self.night_apply_button.frame.origin.y
                    self.BW_apply_origin.y = self.BW_apply_button.frame.origin.y
                    self.school_apply_origin.y = self.school_apply_button.frame.origin.y
                    self.colors_apply_origin.y = self.colors_apply_button.frame.origin.y
                
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
        
    @IBOutlet weak var trophy: UIImageView!
        
    @IBOutlet weak var highest_score: UILabel!
    

    
    
    
    
    
    
    func triangle_title_image_decider() -> Void{
        if (ThemeType == 1){
            if (language == "English"){
                self.triangle_title.image = UIImage(named:"day mode triangle title")
            } else {
                self.triangle_title.image = UIImage(named:"san_title_day")
            }
        } else if (ThemeType == 2){
            if (language == "English"){
                self.triangle_title.image = UIImage(named:"night mode triangle title")
            } else {
                self.triangle_title.image = UIImage(named:"san_title_night")
            }
        } else if (ThemeType == 3){
            if (language == "English"){
                self.triangle_title.image = UIImage(named:"day mode triangle title")
            } else {
                self.triangle_title.image = UIImage(named:"san_title_day")
            }
        } else if (ThemeType == 4){
            //chaos
        }
        else if (ThemeType == 5){
            if (language == "English"){
                self.triangle_title.image = UIImage(named:"school_triangle_title")
            } else {
                self.triangle_title.image = UIImage(named:"san_title_school")
            }
        } else if (ThemeType == 6){
            if (language == "English"){
                self.triangle_title.image = UIImage(named:"night mode triangle title")
            } else {
                self.triangle_title.image = UIImage(named:"san_title_night")
            }
        }


    }

    
    
    //global variables for treasure box meni
    var new_life_circle = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var same_color_eliminator_circle = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var  shape_bomb_circle = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var times_two_circle = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var three_triangles_circle = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var clear_all_circle = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var new_life_circle_text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var same_color_eliminator_circle_text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var shape_bomb_circle_text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var times_two_circle_text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var three_triangles_circle_text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var clear_all_circle_text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var current_star_total = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var current_star_total_text = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var treasuer_box_star_store_button = MyButton()
    
    
    
    var new_life_button = MyButton()
    var same_color_eliminator = MyButton()
    var shape_bomb = MyButton()
    var times_two = MyButton()
    var three_triangles = MyButton()
    var clear_all = MyButton()
    var treasure_cancel = MyButton()
    
    
    
    
    
    
    
    func treasure_box_function() -> Void {
        if(settings_scene_is_opened){
            close_settings_scene()
        }
    let treasure_menu = UIImageView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    treasure_menu.image = #imageLiteral(resourceName: "treasure_background")
    treasure_menu.alpha = 0
    self.view.addSubview(treasure_menu)
    treasure_menu.fadeIn()
    //treasure_menu.tag = 110
    //super.view.isUserInteractionEnabled = false
    //self.view.isUserInteractionEnabled = true
    continue_button.isEnabled = false
    like_button.isEnabled = false
    shopping_cart.isEnabled = false
    gift_button.isEnabled = false
    settings_button.isEnabled = false
    tutorial_button.isEnabled = false
    star_store_button.isEnabled = false
    treasure_cancel = MyButton(frame: CGRect(x: treasure_menu.frame.origin.x, y: treasure_menu.frame.origin.y, width: pause_screen_x_transform(117), height: pause_screen_y_transform(117)))
    treasure_cancel.setImage(#imageLiteral(resourceName: "treasure_box_cancel"), for: .normal)
    treasure_cancel.contentMode = .scaleAspectFit
    treasure_cancel.alpha = 0
    self.view.addSubview(treasure_cancel)
    treasure_cancel.fadeIn()
 

//current star total
current_star_total = UIImageView(frame: CGRect(x: screen_width - pause_screen_x_transform(150), y: pause_screen_y_transform(10), width: pause_screen_x_transform(120), height: pause_screen_y_transform(45)))
current_star_total.image = #imageLiteral(resourceName: "current_star_total")
current_star_total.alpha = 1


    
        
//current star total text
        current_star_total_text = UILabel(frame: CGRect(x: current_star_total.frame.origin.x + pause_screen_x_transform(17), y: current_star_total.frame.origin.y, width: current_star_total.frame.width, height: current_star_total.frame.height))
        current_star_total_text.textColor = UIColor(red: 188.0/255, green: 177.0/255, blue: 177.0/255, alpha: 1)
        current_star_total_text.text = String(star_score)
        current_star_total_text.font = UIFont(name: "Fresca-Regular", size: CGFloat(23))
        current_star_total_text.textAlignment = .center
        current_star_total_text.alpha = 0
        self.view.addSubview(current_star_total_text)
        current_star_total_text.fadeIn()

//auto resizing 
current_star_total_text_width = current_star_total_text.frame.width
split_current_star_total()
treasuer_box_star_store_button.frame = current_star_total.frame
update_current_star_length_according_to_string_length()

current_star_total.alpha = 0
self.view.addSubview(current_star_total)
//new  life button
    new_life_button = MyButton(frame: CGRect(x: pause_screen_x_transform(30), y: pause_screen_y_transform(100), width: pause_screen_x_transform(140), height: pause_screen_y_transform(140)))
    //new_life_button.setImage(#imageLiteral(resourceName: "resurrection_button") , for: .normal)
    //sale
    new_life_button.setImage( #imageLiteral(resourceName: "resurrection_up_sale"), for: .normal)
    new_life_button.alpha = 0
    self.view.addSubview(new_life_button)
    new_life_button.fadeIn()
        new_life_button.whenButtonIsHighlighted(action: {
            //self.new_life_button.setImage(#imageLiteral(resourceName: "new_life"), for: .normal)
            //sale
            self.new_life_button.setImage(#imageLiteral(resourceName: "resurrection_down_sale"), for: .normal)
            self.new_life_button.frame.origin.y += self.pause_screen_y_transform(2)
        })
        //new_life_button.whenButtonEs
        new_life_button.whenButtonEscapeHighlight(action: {
            self.new_life_button.frame.origin.y -= self.pause_screen_y_transform(2)
            //self.new_life_button.setImage(#imageLiteral(resourceName: "resurrection_button"), for: .normal)
            //sale
            self.new_life_button.setImage( #imageLiteral(resourceName: "resurrection_up_sale"), for: .normal)
    
        })
        new_life_button.whenButtonIsClicked(action: {
            self.new_life_button.frame.origin.y -= self.pause_screen_y_transform(2)
            //self.new_life_button.setImage(#imageLiteral(resourceName: "resurrection_button"), for: .normal)
            //sale
            self.new_life_button.setImage( #imageLiteral(resourceName: "resurrection_up_sale"), for: .normal)
            if(!self.sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            self.tool_selected = 0
            self.tool_selected_scene()
                
        })
        
//new life text
        let new_life_text = UIImageView(frame: CGRect(x: pause_screen_x_transform(30), y: pause_screen_y_transform(45), width: pause_screen_x_transform(140), height: pause_screen_y_transform(80)))
        if (self.language == "English"){
            new_life_text.image = #imageLiteral(resourceName: "resurrection_text")
        }
        else {
            new_life_text.image = #imageLiteral(resourceName: "resurrection_ch")
        }
        new_life_text.alpha = 0
        self.view.addSubview(new_life_text)
        new_life_text.fadeIn()
        
//new life circle
        new_life_circle = UIImageView(frame: CGRect(x: new_life_button.frame.origin.x + new_life_button.frame.width - pause_screen_x_transform(40), y: new_life_button.frame.origin.y - pause_screen_y_transform(5), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45)))
        new_life_circle.image = #imageLiteral(resourceName: "new_life_circle")
        new_life_circle.alpha = 0
        self.view.addSubview(new_life_circle)
        if(tool_quantity_array[0] != 0){
        new_life_circle.fadeIn()
        }
        
//new life circle text
        new_life_circle_text = UILabel(frame: CGRect(x: new_life_circle.frame.origin.x, y: new_life_circle.frame.origin.y, width: new_life_circle.frame.width, height: new_life_circle.frame.height))
        new_life_circle_text.text = String(tool_quantity_array[0])
        new_life_circle_text.font = UIFont(name: "Fresca-Regular", size: CGFloat(20))
        new_life_circle_text.textColor = UIColor(red: 208.0/255, green: 91.0/255, blue: 93.0/255, alpha: 1)
        new_life_circle_text.textAlignment = .center
        new_life_circle_text.adjustsFontSizeToFitWidth = true
        new_life_circle_text.alpha = 0
        self.view.addSubview(new_life_circle_text)
        if(tool_quantity_array[0] != 0){
        new_life_circle_text.fadeIn()
        }

        
    
//same color eliminator button
    same_color_eliminator = MyButton(frame: CGRect(x: new_life_button.frame.origin.x + new_life_button.frame.width + pause_screen_x_transform(50), y: pause_screen_y_transform(100), width: pause_screen_x_transform(140), height: pause_screen_y_transform(140)))
    //same_color_eliminator.setImage(#imageLiteral(resourceName: "purification_button"), for: .normal)
    //sale
    same_color_eliminator.setImage(#imageLiteral(resourceName: "purification_up_sale"), for: .normal)
        same_color_eliminator.whenButtonIsHighlighted(action: {
        //self.same_color_eliminator.setImage(#imageLiteral(resourceName: "same_color_eliminator"), for: .normal)
        //sale
        self.same_color_eliminator.setImage(#imageLiteral(resourceName: "purification_down_sale"), for: .normal)
        self.same_color_eliminator.frame.origin.y += self.pause_screen_y_transform(2)
        })
        same_color_eliminator.whenButtonEscapeHighlight(action: {
            //self.same_color_eliminator.setImage(#imageLiteral(resourceName: "purification_button"), for: .normal)
            //sale
            self.same_color_eliminator.setImage(#imageLiteral(resourceName: "purification_up_sale"), for: .normal)
            self.same_color_eliminator.frame.origin.y -= self.pause_screen_y_transform(2)
        })
    
    same_color_eliminator.alpha = 0
    self.view.addSubview(same_color_eliminator)
    same_color_eliminator.fadeIn()
        same_color_eliminator.whenButtonIsClicked(action: {
            //self.same_color_eliminator.setImage(#imageLiteral(resourceName: "purification_button"), for: .normal)
            //sale
            self.same_color_eliminator.setImage(#imageLiteral(resourceName: "purification_up_sale"), for: .normal)
            self.same_color_eliminator.frame.origin.y -= self.pause_screen_y_transform(2)
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            self.tool_selected = 1
            self.tool_selected_scene()
        })
    
    //same color eliminator text
       let same_color_eliminator_text = UIImageView(frame: CGRect(x: same_color_eliminator.frame.origin.x, y: pause_screen_y_transform(45), width: pause_screen_x_transform(140), height: pause_screen_y_transform(80)))
        same_color_eliminator_text.alpha = 0
        if (self.language == "English"){
            same_color_eliminator_text.image = #imageLiteral(resourceName: "purification_text_en")
        }
        else {
            same_color_eliminator_text.image = #imageLiteral(resourceName: "purification_ch")
        }
        
        self.view.addSubview(same_color_eliminator_text)
        same_color_eliminator_text.fadeIn()
        
//same color eliminator circle
        same_color_eliminator_circle = UIImageView(frame: CGRect(x: same_color_eliminator.frame.origin.x + same_color_eliminator.frame.width - pause_screen_x_transform(40), y: same_color_eliminator.frame.origin.y - pause_screen_y_transform(5), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45)))
        same_color_eliminator_circle.image = #imageLiteral(resourceName: "same_color_eminator_circle")
        same_color_eliminator_circle.alpha = 0
        self.view.addSubview(same_color_eliminator_circle)
        if(tool_quantity_array[1] != 0){
        same_color_eliminator_circle.fadeIn()
        }
        
//same color eliminator circle text
        same_color_eliminator_circle_text = UILabel(frame: CGRect(x: same_color_eliminator_circle.frame.origin.x, y: same_color_eliminator_circle.frame.origin.y, width: same_color_eliminator_circle.frame.width, height: same_color_eliminator_circle.frame.height))
        same_color_eliminator_circle_text.text = String(tool_quantity_array[1])
        same_color_eliminator_circle_text.font = UIFont(name: "Fresca-Regular", size: CGFloat(20))
        same_color_eliminator_circle_text.textColor = UIColor(red: 77.0/255, green: 113.0/255, blue: 56.0/255, alpha: 1)
        same_color_eliminator_circle_text.textAlignment = .center
        same_color_eliminator_circle_text.adjustsFontSizeToFitWidth = true
        same_color_eliminator_circle_text.alpha = 0
        self.view.addSubview(same_color_eliminator_circle_text)
        if(tool_quantity_array[1] != 0){
        same_color_eliminator_circle_text.fadeIn()
        }

        
    //shape bomb button
    shape_bomb = MyButton(frame: CGRect(x: new_life_button.frame.origin.x, y: new_life_button.frame.origin.y + new_life_button.frame.height + pause_screen_y_transform(50), width: pause_screen_x_transform(140), height: pause_screen_y_transform(140)))
    //shape_bomb.setImage(#imageLiteral(resourceName: "holy_nova_button"), for: .normal)
    //sale
    shape_bomb.setImage(#imageLiteral(resourceName: "holy_nova_up_sale"), for: .normal)
        shape_bomb.whenButtonIsHighlighted(action: {
            //self.shape_bomb.setImage(#imageLiteral(resourceName: "shape_bomb"), for: .normal)
            self.shape_bomb.setImage(#imageLiteral(resourceName: "holy_nova_down_sale"), for: .normal)
            self.shape_bomb.frame.origin.y += self.pause_screen_y_transform(2)
        })
    
        shape_bomb.whenButtonEscapeHighlight(action: {
            //self.shape_bomb.setImage(#imageLiteral(resourceName: "holy_nova_button"), for: .normal)
            //sale
            self.shape_bomb.setImage(#imageLiteral(resourceName: "holy_nova_up_sale"), for: .normal)
            self.shape_bomb.frame.origin.y -= self.pause_screen_y_transform(2)
        })
    shape_bomb.alpha = 0
    self.view.addSubview(shape_bomb)
    shape_bomb.fadeIn()
    
        shape_bomb.whenButtonIsClicked(action: {
            //self.shape_bomb.setImage(#imageLiteral(resourceName: "holy_nova_button"), for: .normal)
            //sale
            self.shape_bomb.setImage(#imageLiteral(resourceName: "holy_nova_up_sale"), for: .normal)
            self.shape_bomb.frame.origin.y -= self.pause_screen_y_transform(2)
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            self.tool_selected = 2
            self.tool_selected_scene()
        })
    //shape bomb text
    let shape_bomb_text = UIImageView(frame: CGRect(x: shape_bomb.frame.origin.x, y: shape_bomb.frame.origin.y - pause_screen_y_transform(55), width: pause_screen_x_transform(140), height: pause_screen_y_transform(80)))
    shape_bomb_text.alpha = 0
        if (self.language == "English"){
            shape_bomb_text.image = #imageLiteral(resourceName: "holy_nova_text_en")
        }
        else {
            shape_bomb_text.image = #imageLiteral(resourceName: "holy_nova_text_ch")
        }
    
    self.view.addSubview(shape_bomb_text)
    shape_bomb_text.fadeIn()
    //shape bomb circle
    shape_bomb_circle = UIImageView(frame: CGRect(x: shape_bomb.frame.origin.x + shape_bomb.frame.width - pause_screen_x_transform(40), y: shape_bomb.frame.origin.y - pause_screen_y_transform(5), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45)))
        shape_bomb_circle.image = #imageLiteral(resourceName: "shape_bomb_circle")
        shape_bomb_circle.alpha = 0
        self.view.addSubview(shape_bomb_circle)
        if(tool_quantity_array[2] != 0){
        shape_bomb_circle.fadeIn()
        }
    
    //shape bomb circle text
    shape_bomb_circle_text = UILabel(frame: CGRect(x: shape_bomb_circle.frame.origin.x, y: shape_bomb_circle.frame.origin.y, width: shape_bomb_circle.frame.width, height: shape_bomb_circle.frame.height))
        shape_bomb_circle_text.text = String(tool_quantity_array[2])
        shape_bomb_circle_text.font = UIFont(name: "Fresca-Regular", size: CGFloat(20))
        shape_bomb_circle_text.textColor = UIColor(red: 230.0/255, green: 157.0/255, blue: 68.0/255, alpha: 1)
        shape_bomb_circle_text.textAlignment = .center
        shape_bomb_circle_text.adjustsFontSizeToFitWidth = true
        shape_bomb_circle_text.alpha = 0
        self.view.addSubview(shape_bomb_circle_text)
        if(tool_quantity_array[2] != 0){
            shape_bomb_circle_text.fadeIn()
        }
    
        
    //times two button
    times_two = MyButton(frame: CGRect(x: same_color_eliminator.frame.origin.x, y: shape_bomb.frame.origin.y, width: pause_screen_x_transform(140), height: pause_screen_y_transform(140)))
    //times_two.setImage(#imageLiteral(resourceName: "amplifier_button"), for: .normal)
    //sale
        times_two.setImage(#imageLiteral(resourceName: "amplifier_up_sale"), for: .normal)
        times_two.whenButtonIsHighlighted(action: {
            //self.times_two.setImage(#imageLiteral(resourceName: "times_two"), for: .normal)
            //sale
            self.times_two.setImage(#imageLiteral(resourceName: "amplifier_down_sale"), for: .normal)
            self.times_two.frame.origin.y += self.pause_screen_y_transform(2)
       
        })
        times_two.whenButtonEscapeHighlight(action: {
           //self.times_two.setImage(#imageLiteral(resourceName: "amplifier_button"), for: .normal)
           //sale
            self.times_two.setImage(#imageLiteral(resourceName: "amplifier_up_sale"), for: .normal)
            self.times_two.frame.origin.y -= self.pause_screen_y_transform(2)
        })
        times_two.alpha = 0
    self.view.addSubview(times_two)
    times_two.fadeIn()
        times_two.whenButtonIsClicked(action: {
            //self.times_two.setImage(#imageLiteral(resourceName: "amplifier_button"), for: .normal)
            //sale
            self.times_two.setImage(#imageLiteral(resourceName: "amplifier_up_sale"), for: .normal)
            self.times_two.frame.origin.y -= self.pause_screen_y_transform(2)
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            self.tool_selected = 3
            self.tool_selected_scene()
        })
   //times two text
        let times_two_text = UIImageView(frame: CGRect(x: times_two.frame.origin.x, y: times_two.frame.origin.y - pause_screen_y_transform(55), width: pause_screen_x_transform(140), height: pause_screen_y_transform(80)))
        if (self.language == "English"){
            times_two_text.image = #imageLiteral(resourceName: "amplifier_en")
        }
        else {
           times_two_text.image = #imageLiteral(resourceName: "amplifier_ch")
        }
        
        times_two_text.alpha = 0
        self.view.addSubview(times_two_text)
        times_two_text.fadeIn()
     
   //times two circle
    times_two_circle = UIImageView(frame: CGRect(x: times_two.frame.origin.x + times_two.frame.width - pause_screen_x_transform(40), y: times_two.frame.origin.y - pause_screen_y_transform(5), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45)))
        times_two_circle.image = #imageLiteral(resourceName: "double_score_circle")
        times_two_circle.alpha = 0
        self.view.addSubview(times_two_circle)
        if(tool_quantity_array[3] != 0){
        times_two_circle.fadeIn()
        }
        
    //times two circle text 
        times_two_circle_text = UILabel(frame: CGRect(x: times_two_circle.frame.origin.x, y: times_two_circle.frame.origin.y, width: times_two_circle.frame.width, height: times_two_circle.frame.height))
        times_two_circle_text.text = String(tool_quantity_array[3])
        times_two_circle_text.font = UIFont(name: "Fresca-Regular", size: CGFloat(20))
        times_two_circle_text.textColor = UIColor(red: 180.0/255, green: 134.0/255, blue: 161.0/255, alpha: 1)
        times_two_circle_text.textAlignment = .center
        times_two_circle_text.adjustsFontSizeToFitWidth = true
        times_two_circle_text.alpha = 0
        self.view.addSubview(times_two_circle_text)
        if(tool_quantity_array[3] != 0){
            times_two_circle_text.fadeIn()
        }
        
    //three triangles button
    three_triangles = MyButton(frame: CGRect(x: shape_bomb.frame.origin.x, y: shape_bomb.frame.origin.y + shape_bomb.frame.height + pause_screen_y_transform(50), width: pause_screen_x_transform(140), height: pause_screen_y_transform(140)))
    //three_triangles.setImage(#imageLiteral(resourceName: "trinity_button"), for: .normal)
    //sale
    three_triangles.setImage(#imageLiteral(resourceName: "trinity_up_sale"), for: .normal)
        three_triangles.whenButtonIsHighlighted(action: {
            //self.three_triangles.setImage(#imageLiteral(resourceName: "three_triangle"), for: .normal)
            //sale
            self.three_triangles.setImage(#imageLiteral(resourceName: "trinity_down_sale"), for: .normal)
            self.three_triangles.frame.origin.y += self.pause_screen_y_transform(2)
        })
        
        three_triangles.whenButtonEscapeHighlight(action: {
            //self.three_triangles.setImage(#imageLiteral(resourceName: "trinity_button"), for: .normal)
            //sale
            self.three_triangles.setImage(#imageLiteral(resourceName: "trinity_up_sale"), for: .normal)
            self.three_triangles.frame.origin.y -= self.pause_screen_y_transform(2)
        })
    three_triangles.alpha = 0
    self.view.addSubview(three_triangles)
    three_triangles.fadeIn()
        three_triangles.whenButtonIsClicked(action: {
            //self.three_triangles.setImage(#imageLiteral(resourceName: "trinity_button"), for: .normal)
            //sale
            self.three_triangles.setImage(#imageLiteral(resourceName: "trinity_up_sale"), for: .normal)
            self.three_triangles.frame.origin.y -= self.pause_screen_y_transform(2)
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            self.tool_selected = 4
            self.tool_selected_scene()
        })
    
    //three triangle text
    let three_triangles_text = UIImageView(frame: CGRect(x: three_triangles.frame.origin.x, y: three_triangles.frame.origin.y - pause_screen_y_transform(55), width: pause_screen_x_transform(140), height: pause_screen_y_transform(80)))
        if (self.language == "English"){
            three_triangles_text.image = #imageLiteral(resourceName: "trinity_text_en")
        }
        else {
            
            three_triangles_text.image = #imageLiteral(resourceName: "trinity_ch")
        }
    
    three_triangles_text.alpha = 0
    self.view.addSubview(three_triangles_text)
    three_triangles_text.fadeIn()
    
    //three tirangle circle 
    three_triangles_circle = UIImageView(frame: CGRect(x: three_triangles.frame.origin.x + three_triangles.frame.width - pause_screen_x_transform(40), y: three_triangles.frame.origin.y - pause_screen_y_transform(5), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45)))
        three_triangles_circle.image = #imageLiteral(resourceName: "three_tri_circle")
        three_triangles_circle.alpha = 0
        self.view.addSubview(three_triangles_circle)
        if(tool_quantity_array[4] != 0){
        three_triangles_circle.fadeIn()
        }
        
    //three tirangle circle text
        three_triangles_circle_text = UILabel(frame: CGRect(x: three_triangles_circle.frame.origin.x, y: three_triangles_circle.frame.origin.y, width: three_triangles_circle.frame.width, height: three_triangles_circle.frame.height))
        three_triangles_circle_text.text = String(tool_quantity_array[4])
        three_triangles_circle_text.font = UIFont(name: "Fresca-Regular", size: CGFloat(20))
        three_triangles_circle_text.textColor = UIColor(red: 73.0/255, green: 159.0/255, blue: 192.0/255, alpha: 1)
        three_triangles_circle_text.textAlignment = .center
        three_triangles_circle_text.adjustsFontSizeToFitWidth = true
        three_triangles_circle_text.alpha = 0
        self.view.addSubview(three_triangles_circle_text)
        if(tool_quantity_array[4] != 0){
            three_triangles_circle_text.fadeIn()
        }
        
        
    //clear all button
    clear_all = MyButton(frame: CGRect(x: times_two.frame.origin.x, y: three_triangles.frame.origin.y, width: pause_screen_x_transform(140), height: pause_screen_y_transform(140)))
    //clear_all.setImage(#imageLiteral(resourceName: "doom_day_button"), for: .normal)
    //sale
    clear_all.setImage(#imageLiteral(resourceName: "doomday_up_sale"), for: .normal)
        clear_all.whenButtonIsHighlighted(action: {
            //self.clear_all.setImage(#imageLiteral(resourceName: "clear_all"), for: .normal)
            //sale
            self.clear_all.setImage(#imageLiteral(resourceName: "doomday_down_sale"), for: .normal)
            self.clear_all.frame.origin.y += self.pause_screen_y_transform(2)
        })
       clear_all.alpha = 0
    self.view.addSubview(clear_all)
    clear_all.fadeIn()
        clear_all.whenButtonEscapeHighlight(action: {
            //self.clear_all.setImage(#imageLiteral(resourceName: "doom_day_button"), for: .normal)
            //sale
             self.clear_all.setImage(#imageLiteral(resourceName: "doomday_up_sale"), for: .normal)
            self.clear_all.frame.origin.y -= self.pause_screen_y_transform(2)
            
        })
        clear_all.whenButtonIsClicked(action: {
            //self.clear_all.setImage(#imageLiteral(resourceName: "doom_day_button"), for: .normal)
            //sale
             self.clear_all.setImage(#imageLiteral(resourceName: "doomday_up_sale"), for: .normal)
            self.clear_all.frame.origin.y -= self.pause_screen_y_transform(2)
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            self.tool_selected = 5
            self.tool_selected_scene()
            
        })
    
    //clear all text
        let clear_all_text = UIImageView(frame: CGRect(x: clear_all.frame.origin.x, y: clear_all.frame.origin.y - pause_screen_y_transform(55), width: pause_screen_x_transform(140), height: pause_screen_y_transform(80)))
        if (language == "English"){
            clear_all_text.image = #imageLiteral(resourceName: "doom_day_text_en")
        } else{
            clear_all_text.image = #imageLiteral(resourceName: "doom_day_text_ch")

        }
        
        clear_all_text.alpha = 0
        self.view.addSubview(clear_all_text)
        clear_all_text.fadeIn()
  //clear all circle
   clear_all_circle = UIImageView(frame: CGRect(x: clear_all.frame.origin.x + clear_all.frame.width - pause_screen_x_transform(40), y: clear_all.frame.origin.y - pause_screen_y_transform(5), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45)))
        clear_all_circle.image = #imageLiteral(resourceName: "clear_all_circle")
        clear_all_circle.alpha = 0
        self.view.addSubview(clear_all_circle)
        if(tool_quantity_array[5] != 0){
        clear_all_circle.fadeIn()
        }
        
  //clear all circle text
        clear_all_circle_text = UILabel(frame: CGRect(x: clear_all_circle.frame.origin.x, y: clear_all_circle.frame.origin.y, width: clear_all_circle.frame.width, height: clear_all_circle.frame.height))
        clear_all_circle_text.text = String(tool_quantity_array[5])
        clear_all_circle_text.font = UIFont(name: "Fresca-Regular", size: CGFloat(20))
        clear_all_circle_text.textColor = UIColor(red: 56.0/255, green: 75.0/255, blue: 130.0/255, alpha: 1)
        clear_all_circle_text.textAlignment = .center
        clear_all_circle_text.adjustsFontSizeToFitWidth = true
        clear_all_circle_text.alpha = 0
        self.view.addSubview(clear_all_circle_text)
        if(tool_quantity_array[5] != 0){
            clear_all_circle_text.fadeIn()
        }
        
        
        
    //treasure cancel action
    treasure_cancel.whenButtonIsClicked(action: {
        if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
        }
            self.treasure_cancel.fadeOutandRemove()
            treasure_menu.fadeOutandRemove()
            self.new_life_button.fadeOutandRemove()
            self.same_color_eliminator.fadeOutandRemove()
            self.shape_bomb.fadeOutandRemove()
            self.times_two.fadeOutandRemove()
            self.three_triangles.fadeOutandRemove()
            self.clear_all.fadeOutandRemove()
            new_life_text.fadeOutandRemove()
            same_color_eliminator_text.fadeOutandRemove()
            shape_bomb_text.fadeOutandRemove()
            times_two_text.fadeOutandRemove()
            three_triangles_text.fadeOutandRemove()
            clear_all_text.fadeOutandRemove()
            self.new_life_circle.fadeOutandRemove()
            self.same_color_eliminator_circle.fadeOutandRemove()
            self.shape_bomb_circle.fadeOutandRemove()
            self.times_two_circle.fadeOutandRemove()
            self.three_triangles_circle.fadeOutandRemove()
            self.clear_all_circle.fadeOutandRemove()
          self.new_life_circle_text.fadeOutandRemove()
          self.same_color_eliminator_circle_text.fadeOutandRemove()
          self.shape_bomb_circle_text.fadeOutandRemove()
          self.times_two_circle_text.fadeOutandRemove()
          self.three_triangles_circle_text.fadeOutandRemove()
          self.clear_all_circle_text.fadeOutandRemove()
        self.current_star_total_text.fadeOutandRemove()
        self.current_star_total.fadeOutandRemove()
        self.remove_all_current_star_fragments()

        //restore all buttons
        self.continue_button.isEnabled = true
        self.like_button.isEnabled = true
        self.shopping_cart.isEnabled = true
        self.gift_button.isEnabled = true
        self.settings_button.isEnabled = true
        self.tutorial_button.isEnabled = true
        self.star_store_button.isEnabled = true
          })
        
//treasure box star store
       
       treasuer_box_star_store_button.setImage(#imageLiteral(resourceName: "current_star_total"), for: .normal)
       treasuer_box_star_store_button.alpha = 0.02
       self.view.addSubview(treasuer_box_star_store_button)
        treasuer_box_star_store_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            
            self.purchase_star_function()
        })
     
    }
   
    @IBOutlet weak var treasure_box_icon: UIButton!
    @IBAction func treasure_box_action(_ sender: UIButton) {
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }
        treasure_box_function()
    }

    
    func language_button_image_decider() -> Void{
        if (ThemeType == 1){
            if (language == "Chinese"){
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "en_day&night"), for: .normal)
            } else {
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "cn_day&night"), for: .normal)
            }
        } else if (ThemeType == 2){
            if (language == "Chinese"){
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "en_day&night"), for: .normal)
            } else {
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "cn_day&night"), for: .normal)
            }
        } else if (ThemeType == 3){
            if (language == "Chinese"){
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "en_bw&colors"), for: .normal)
            } else {
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "cn_bw&colors"), for: .normal)
            }
        } else if (ThemeType == 4){
            //chaos
        }
        else if (ThemeType == 5){
            if (language == "Chinese"){
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "en_school"), for: .normal)
            } else {
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "cn_school"), for: .normal)
            }
        } else if (ThemeType == 6){
            if (language == "Chinese"){
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "en_bw&colors"), for: .normal)
            } else {
                self.language_button.setBackgroundImage(#imageLiteral(resourceName: "cn_bw&colors"), for: .normal)
            }
        }
    }


    //tool selected:
    // 0 - new life  1 - same color eliminator 2 - shape bomb 3 - score*2 4 - three triangles 5 - clear all
    var tool_selected = -1
    
    
    //star base
    //star base quantity for selected tool
    var star_base = 0
    
    
    
    //tool quantity array
    //index : 0 - new life 1 - same color eliminator 2 - shape bomb 3 - score*2 4 - three triangles 5 - clear all
    var tool_quantity_array = [0,0,0,0,0,0]
    var total_price_image = UIImageView()
    var total_star_need_label = UILabel()
    var tool_quantity = 0
    var star_quantiry_needed = 0
    var total_star_full_length = CGFloat(0)
    var final_price_button_length = CGFloat(0)
    var final_price_button = MyButton()
    func tool_selected_scene() -> Void {
    let selected_scene_background = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    selected_scene_background.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    selected_scene_background.alpha = 0
    self.view.addSubview(selected_scene_background)
    selected_scene_background.fadeInTrans()
    let selected_scene = UIView(frame: CGRect(x: 0, y: screen_height/2 - pause_screen_y_transform(150), width: screen_width, height: pause_screen_y_transform(300)))
    selected_scene.backgroundColor = UIColor(red: 228.0/255, green: 229.0/255, blue: 224.0/255, alpha: 1.0)
    selected_scene.alpha = 0
    self.view.addSubview(selected_scene)
    selected_scene.fadeIn()
    let selected_cancel = MyButton(frame: CGRect(x: screen_width - pause_screen_x_transform(100), y: selected_scene.frame.origin.y, width: pause_screen_x_transform(100), height: pause_screen_y_transform(100)))
    selected_cancel.setImage(#imageLiteral(resourceName: "selected_scene_cancel"), for: .normal)
    selected_cancel.alpha = 0
    self.view.addSubview(selected_cancel)
    selected_cancel.fadeIn()
    let treasure_icon_selected = UIImageView(frame: CGRect(x: pause_screen_x_transform(30), y:   selected_scene.frame.origin.y+pause_screen_y_transform(70), width: pause_screen_x_transform(140), height: pause_screen_y_transform(140)))
        let treasure_text = UIImageView(frame: CGRect(x: treasure_icon_selected.frame.origin.x, y: treasure_icon_selected.frame.origin.y - pause_screen_y_transform(50), width: pause_screen_x_transform(140), height: pause_screen_y_transform(80)))
        
    
let explaination_text = UIImageView(frame: CGRect(x: treasure_icon_selected.frame.origin.x + treasure_icon_selected.frame.width + pause_screen_x_transform(37), y: treasure_icon_selected.frame.origin.y + pause_screen_y_transform(10), width: pause_screen_x_transform(159), height:pause_screen_y_transform(100)))

        
        
final_price_button = MyButton(frame: CGRect(x: explaination_text.frame.origin.x + explaination_text.frame.width/2.0 - pause_screen_x_transform(120)/2.0, y: treasure_icon_selected.frame.origin.y + pause_screen_y_transform(120), width: pause_screen_x_transform(120), height: pause_screen_y_transform(45)))

        
        
        let sub_button = MyButton(frame: CGRect(x: treasure_icon_selected.frame.origin.x + pause_screen_x_transform(10), y: treasure_icon_selected.frame.origin.y + treasure_icon_selected.frame.height + pause_screen_y_transform(15), width: pause_screen_x_transform(40), height: pause_screen_y_transform(40)))
        sub_button.setImage(#imageLiteral(resourceName: "substract"), for: .normal)
        sub_button.contentMode = .scaleAspectFit
       
        
        let add_button = MyButton(frame: CGRect(x: treasure_icon_selected.frame.origin.x + treasure_icon_selected.frame.width - pause_screen_x_transform(50), y: sub_button.frame.origin.y, width: pause_screen_x_transform(40), height: pause_screen_y_transform(40)))
        add_button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        add_button.contentMode = .scaleAspectFit
        
        
     
        
        
        
        
        
        
        //quantity of tool
         self.tool_quantity = 0
        //quantity of star needed
        self.star_quantiry_needed = 0
        _ = CGFloat(25)
        
      
        
        
        
        let tool_quantity_label = UILabel(frame: CGRect(x: (add_button.frame.origin.x + sub_button.frame.origin.x + sub_button.frame.width)/2 - pause_screen_x_transform(25), y: sub_button.frame.origin.y, width: pause_screen_x_transform(50), height: pause_screen_y_transform(45)))
        tool_quantity_label.text = String(tool_quantity)
        tool_quantity_label.font = UIFont(name: "Fresca-Regular", size: CGFloat(28))
        tool_quantity_label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        tool_quantity_label.textAlignment = .center
        
        
         total_star_need_label = UILabel(frame: CGRect(x: final_price_button.frame.origin.x + pause_screen_x_transform(20), y: final_price_button.frame.origin.y, width: final_price_button.frame.width, height: final_price_button.frame.height))
        total_star_need_label.text = String(self.star_quantiry_needed)
        
        total_star_need_label.font = UIFont(name: "Fresca-Regular", size: CGFloat(28))
        total_star_need_label.textAlignment = .center
        total_star_need_label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)

        
        
        
        if (self.language == "English"){
        if(tool_selected == 0){
            //treasure_icon_selected.image = #imageLiteral(resourceName: "new_life")
            //sale
            treasure_icon_selected.image = #imageLiteral(resourceName: "resurrection_down_sale")
            treasure_text.image = #imageLiteral(resourceName: "resurrection_text")
            final_price_button.setImage(#imageLiteral(resourceName: "new_life_star_total"), for: .normal)
            explaination_text.image =  #imageLiteral(resourceName: "new_life_en")
            total_star_need_label.textColor = UIColor(red: 208.0/255, green: 91.0/255, blue: 93.0/255, alpha: 1)
            //star_base = 25
            //sale
            star_base = 10
        }else if(tool_selected == 1){
            //treasure_icon_selected.image = #imageLiteral(resourceName: "same_color_eliminator")
            //sale
            treasure_icon_selected.image = #imageLiteral(resourceName: "purification_down_sale")
            treasure_text.image = #imageLiteral(resourceName: "purification_text_en")
            final_price_button.setImage(#imageLiteral(resourceName: "same_color_eliminator_star_total-1"), for: .normal)
            explaination_text.image = #imageLiteral(resourceName: "same_color_eliminator_en")
            total_star_need_label.textColor = UIColor(red: 77.0/255, green: 113.0/255, blue: 56.0/255, alpha: 1)
            //star_base = 100
            //sale
            star_base = 50
        }else if(tool_selected == 2){
            //treasure_icon_selected.image = #imageLiteral(resourceName: "shape_bomb")
            treasure_icon_selected.image = #imageLiteral(resourceName: "holy_nova_down_sale")
            treasure_text.image = #imageLiteral(resourceName: "holy_nova_text_en")
            final_price_button.setImage(#imageLiteral(resourceName: "shape_bomb_star_total"), for: .normal)
            total_star_need_label.textColor = UIColor(red: 230.0/255, green: 157.0/255, blue: 68.0/255, alpha: 1)
            explaination_text.image = #imageLiteral(resourceName: "shape_bomb_en")
            //star_base = 150
            //sale
            star_base = 75
        }else if(tool_selected == 3){
            //treasure_icon_selected.image = #imageLiteral(resourceName: "times_two")
            //sale
            treasure_icon_selected.image = #imageLiteral(resourceName: "amplifier_down_sale")
            treasure_text.image = #imageLiteral(resourceName: "amplifier_en")
            final_price_button.setImage(#imageLiteral(resourceName: "double_score_star_total"), for: .normal)
            explaination_text.image = #imageLiteral(resourceName: "double_score_en")
            total_star_need_label.textColor = UIColor(red: 180.0/255, green: 134.0/255, blue: 161.0/255, alpha: 1)
            //star_base = 50
            //sale
            star_base = 25
        }else if(tool_selected == 4){
            //treasure_icon_selected.image =  #imageLiteral(resourceName: "three_triangle")
            //sale
            treasure_icon_selected.image = #imageLiteral(resourceName: "trinity_down_sale")
            treasure_text.image = #imageLiteral(resourceName: "trinity_text_en")
            final_price_button.setImage(#imageLiteral(resourceName: "three_triangles_star_total"), for: .normal)
            explaination_text.image = #imageLiteral(resourceName: "three_triangles_en")
            total_star_need_label.textColor = UIColor(red: 73.0/255, green: 159.0/255, blue: 192.0/255, alpha: 1)
            //star_base = 75
            //sale
            star_base = 40
        }else if(tool_selected == 5){
            //treasure_icon_selected.image = #imageLiteral(resourceName: "clear_all")
            treasure_icon_selected.image = #imageLiteral(resourceName: "doomday_down_sale")
            treasure_text.image = #imageLiteral(resourceName: "doom_day_text_en")
            final_price_button.setImage(#imageLiteral(resourceName: "clear_all_star_total"), for: .normal)
            explaination_text.image = #imageLiteral(resourceName: "clear_all_en")
            total_star_need_label.textColor = UIColor(red: 56.0/255, green: 75.0/255, blue: 130.0/255, alpha: 1)

            //star_base = 999
            //sale
            star_base = 500
        }
        }
        else {
            if(tool_selected == 0){
                //treasure_icon_selected.image = #imageLiteral(resourceName: "new_life")
                treasure_icon_selected.image = #imageLiteral(resourceName: "resurrection_down_sale")
                treasure_text.image = #imageLiteral(resourceName: "resurrection_ch")
                final_price_button.setImage(#imageLiteral(resourceName: "new_life_star_total"), for: .normal)
                explaination_text.image =  #imageLiteral(resourceName: "resurrection_explain_ch")
                total_star_need_label.textColor = UIColor(red: 208.0/255, green: 91.0/255, blue: 93.0/255, alpha: 1)
                //star_base = 25
                //sale
                star_base = 10
            }else if(tool_selected == 1){
                //treasure_icon_selected.image = #imageLiteral(resourceName: "same_color_eliminator")
                treasure_icon_selected.image = #imageLiteral(resourceName: "purification_down_sale")
                treasure_text.image = #imageLiteral(resourceName: "purification_ch")
                final_price_button.setImage(#imageLiteral(resourceName: "same_color_eliminator_star_total-1"), for: .normal)
                explaination_text.image = #imageLiteral(resourceName: "purification_explain_ch")
                total_star_need_label.textColor = UIColor(red: 77.0/255, green: 113.0/255, blue: 56.0/255, alpha: 1)
                //star_base = 100
                //sale
                star_base = 50
            }else if(tool_selected == 2){
                //treasure_icon_selected.image = #imageLiteral(resourceName: "shape_bomb")
                treasure_icon_selected.image = #imageLiteral(resourceName: "holy_nova_down_sale")
                treasure_text.image = #imageLiteral(resourceName: "holy_nova_text_ch")
                final_price_button.setImage(#imageLiteral(resourceName: "shape_bomb_star_total"), for: .normal)
                total_star_need_label.textColor = UIColor(red: 230.0/255, green: 157.0/255, blue: 68.0/255, alpha: 1)
                explaination_text.image = #imageLiteral(resourceName: "holy_nova_explain_ch")
                //star_base = 150
                //sale
                star_base = 75
            }else if(tool_selected == 3){
                //treasure_icon_selected.image = #imageLiteral(resourceName: "times_two")
                treasure_icon_selected.image = #imageLiteral(resourceName: "amplifier_down_sale")
                treasure_text.image = #imageLiteral(resourceName: "amplifier_ch")
                final_price_button.setImage(#imageLiteral(resourceName: "double_score_star_total"), for: .normal)
                explaination_text.image = #imageLiteral(resourceName: "amplifier_explain_ch")
                total_star_need_label.textColor = UIColor(red: 180.0/255, green: 134.0/255, blue: 161.0/255, alpha: 1)
                //star_base = 50
                //sale
                star_base = 25
            }else if(tool_selected == 4){
                //treasure_icon_selected.image =  #imageLiteral(resourceName: "three_triangle")
                treasure_icon_selected.image = #imageLiteral(resourceName: "trinity_down_sale")
                treasure_text.image = #imageLiteral(resourceName: "trinity_ch")
                final_price_button.setImage(#imageLiteral(resourceName: "three_triangles_star_total"), for: .normal)
                explaination_text.image = #imageLiteral(resourceName: "trinity_explain_ch")
                total_star_need_label.textColor = UIColor(red: 73.0/255, green: 159.0/255, blue: 192.0/255, alpha: 1)
                //star_base = 75
                //sale
                star_base = 40
            }else if(tool_selected == 5){
                //treasure_icon_selected.image = #imageLiteral(resourceName: "clear_all")
                treasure_icon_selected.image = #imageLiteral(resourceName: "doomday_down_sale")
                treasure_text.image = #imageLiteral(resourceName: "doom_day_text_ch")
                final_price_button.setImage(#imageLiteral(resourceName: "clear_all_star_total"), for: .normal)
                explaination_text.image = #imageLiteral(resourceName: "doom_day_explain_ch")
                total_star_need_label.textColor = UIColor(red: 56.0/255, green: 75.0/255, blue: 130.0/255, alpha: 1)
                
                //star_base = 999
                //sale
                star_base = 500
            }
        }
        //fade in
        treasure_icon_selected.alpha = 0
        self.view.addSubview(treasure_icon_selected)
        treasure_icon_selected.fadeIn()
        
        treasure_text.alpha = 0
        self.view.addSubview(treasure_text)
        treasure_text.fadeIn()
        
        final_price_button.alpha = 0
        self.view.addSubview(final_price_button)
        final_price_button.fadeIn()
        
        
        explaination_text.alpha = 0
        self.view.addSubview(explaination_text)
        explaination_text.fadeIn()
        
        sub_button.alpha = 0
        self.view.addSubview(sub_button)
        sub_button.fadeIn()
        
        
        add_button.alpha = 0
        self.view.addSubview(add_button)
        add_button.fadeIn()
        
        tool_quantity_label.alpha = 0
        self.view.addSubview(tool_quantity_label)
        tool_quantity_label.fadeIn()
        
        total_star_need_label.alpha = 0
        self.view.addSubview(total_star_need_label)
        total_star_need_label.fadeIn()
        total_price_text_width = total_star_need_label.frame.width
        
        final_price_button_length = final_price_button.frame.width
        
        //add total_price_image
        //total_price_image.frame = final_price_button.frame
        total_price_image.frame = final_price_button.frame
        total_price_image.image = final_price_button.image(for: .normal)
        //total_price_image.alpha = 0
        final_price_button.alpha = 1
        
        split_total_price_counter()
        update_total_star_length_according_to_string_length()
        //self.view.bringSubview(toFront: final_price_button)
        //self.view.addSubview(total_price_image)
        //total_price_image.fadeIn()
        //final_price_button.alpha = 1
        
        total_price_image.frame.size = CGSize(width: total_star_full_length, height: total_price_image.frame.height)
        print("total price image width is \(total_star_full_length)")
        //total_price_image.image = temp_image
        total_price_image.alpha = 1
        if(total_price_image.image == nil){
            print("nil image")
        }
        //self.view.bringSubview(toFront: total_price_image)
        final_price_button.alpha = 0.02
        //final_price_button.isHidden = false
        //final_price_button.backgroundColor = UIColor.clear
        self.view.bringSubview(toFront: final_price_button)
        //self.remove_all_total_price_fragments()
        
        
        //let temp_image_1 = treasure_icon_selected.image
        
        
        
        
        
        selected_cancel.whenButtonIsClicked(action: {
            selected_scene_background.fadeOutandRemove()
            selected_scene.fadeOutandRemove()
            selected_cancel.fadeOutandRemove()
            treasure_icon_selected.fadeOutandRemove()
            treasure_text.fadeOutandRemove()
            sub_button.fadeOutandRemove()
            add_button.fadeOutandRemove()
            tool_quantity_label.fadeOutandRemove()
            self.total_star_need_label.fadeOutandRemove()
            self.final_price_button.fadeOutandRemove()
            explaination_text.fadeOutandRemove()
            self.total_price_image.fadeOutandRemove()
            self.remove_all_total_price_fragments()
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            
        })
       
        add_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
            do{self.add_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "add", ofType: "wav")!))
                self.add_player.prepareToPlay()
            }
            catch{
                
            }
            self.add_player.play()
            }
            self.tool_quantity = self.tool_quantity + 1
            tool_quantity_label.text = String(self.tool_quantity)
            self.star_quantiry_needed = self.tool_quantity * self.star_base
            self.total_star_need_label.text = String(self.star_quantiry_needed)
            self.update_total_star_length_according_to_string_length()
        })
        
        sub_button.whenButtonIsClicked(action: {
            if(self.tool_quantity == 0){
                self.tool_quantity = 0
                if(!self.sound_is_muted){
                do{self.sub_not_allowed_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sub_not_allowed", ofType: "wav")!))
                    self.sub_not_allowed_player.prepareToPlay()
                }
                catch{
                    
                }
                self.sub_not_allowed_player.play()
                }
     
            }else{
                if(!self.sound_is_muted){
                do{self.sub_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sub", ofType: "wav")!))
                    self.sub_player.prepareToPlay()
                }
                catch{
                    
                }
                self.sub_player.play()
                }
                self.tool_quantity = self.tool_quantity - 1
                tool_quantity_label.text = String(self.tool_quantity)
            }
            self.star_quantiry_needed = self.tool_quantity * self.star_base
            self.total_star_need_label.text = String(self.star_quantiry_needed)
            self.update_total_star_length_according_to_string_length()
        })
        
        print("tool selected : \(tool_selected)")
        //action for confirming price
        //have an issue
        
        final_price_button.whenButtonIsClicked (action: {
            if(self.star_score >= self.star_quantiry_needed && self.star_quantiry_needed != 0){
        self.tool_quantity_array[self.tool_selected] += self.tool_quantity
        selected_scene_background.fadeOutandRemove()
        selected_scene.fadeOutandRemove()
        selected_cancel.fadeOutandRemove()
        treasure_icon_selected.fadeOutandRemove()
        treasure_text.fadeOutandRemove()
        sub_button.fadeOutandRemove()
        add_button.fadeOutandRemove()
        tool_quantity_label.fadeOutandRemove()
        self.total_star_need_label.fadeOutandRemove()
        self.final_price_button.fadeOutandRemove()
        explaination_text.fadeOutandRemove()
        self.total_price_image.fadeOutandRemove()
        self.circle_pop_up(tool_index: self.tool_selected)
        self.update_star_counter_length_according_to_string_length()
        self.update_current_star_length_according_to_string_length()
        self.remove_all_total_price_fragments()
            }else{
              selected_scene.shake(duration: 0.5)
              selected_cancel.shake(duration: 0.5)
              treasure_icon_selected.shake(duration: 0.5)
              treasure_text.shake(duration: 0.5)
              add_button.shake(duration: 0.5)
              sub_button.shake(duration: 0.5)
              tool_quantity_label.shake(duration: 0.5)
              explaination_text.shake(duration: 0.5)
              self.total_price_fragments[0].shake(duration: 0.5)
                self.total_price_fragments[1].shake(duration: 0.5)
                self.total_price_fragments[2].shake(duration: 0.5)
                self.total_price_fragments[3].shake(duration: 0.5)
                self.total_star_need_label.shake(duration: 0.5)
            }
            self.fix_star_score(star_needed: self.star_quantiry_needed)
        })
        
    }
    
    func circle_pop_up(tool_index: Int) -> Void {
        if(tool_quantity_array[0] != 0){
            new_life_circle.fadeIn()
            new_life_circle_text.fadeIn()
            new_life_circle_text.text = String(tool_quantity_array[0])
            
        }
        if(tool_quantity_array[1] != 0){
            same_color_eliminator_circle.fadeIn()
            same_color_eliminator_circle_text.fadeIn()
            same_color_eliminator_circle_text.text = String(tool_quantity_array[1])
        }
        if(tool_quantity_array[2] != 0){
            shape_bomb_circle.fadeIn()
            shape_bomb_circle_text.fadeIn()
            shape_bomb_circle_text.text = String(tool_quantity_array[2])
        }
        if(tool_quantity_array[3] != 0){
            times_two_circle.fadeIn()
            times_two_circle_text.fadeIn()
            times_two_circle_text.text = String(tool_quantity_array[3])
        }
        if(tool_quantity_array[4] != 0){
            three_triangles_circle.fadeIn()
            three_triangles_circle_text.fadeIn()
            three_triangles_circle_text.text = String(tool_quantity_array[4])
        }
        if(tool_quantity_array[5] != 0){
            clear_all_circle.fadeIn()
            clear_all_circle_text.fadeIn()
            clear_all_circle_text.text = String(tool_quantity_array[5])
        }
        defaults.set(tool_quantity_array, forKey: "tritri_tool_quantity_array")
        
        
    }
    
    func fix_star_score(star_needed: Int){
        if(star_score >= star_needed && star_needed != 0){
        star_score -= star_needed
        defaults.set(tool_quantity_array, forKey: "tritri_tool_quantity_array")
            if(!sound_is_muted){
            do{self.cash_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cash_register", ofType: "wav")!))
                self.cash_player.prepareToPlay()
            }
            catch{
                
            }
            self.cash_player.play()
            }
        }else{
            star_score = star_score - 0
            if(!sound_is_muted){
            do{self.wrong_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "not_fit", ofType: "wav")!))
                self.wrong_player.prepareToPlay()
            }
            catch{
                
            }
            self.wrong_player.play()
            }

        }
        defaults.set(star_score, forKey: "tritri_star_score")
        self.current_star_total_text.text = String(star_score)
        self.star_board.text = String(star_score)
        
    }
    
    // star counter auto resize
    
    var star_counter_fragments : Array<UIView> = []
    
    func remove_all_fragments() -> Void{
        star_counter_fragments[0].removeFromSuperview()
        star_counter_fragments[1].removeFromSuperview()
        star_counter_fragments[2].removeFromSuperview()
        star_counter_fragments[3].removeFromSuperview()
    }
    func split_star_counter() -> Void{
        star_counter_fragments = []
        star_counter.alpha = 1
        star_counter_fragments = star_counter.generateFragmentsFrom(star_counter, with: 4.0, in: self.view)
        _ = 0
        star_counter.alpha = 0
        star_counter_fragments[0].frame.origin.x = star_counter.frame.origin.x
        star_counter_fragments[1].frame.origin.x = star_counter_fragments[0].frame.origin.x + star_counter_fragments[0].frame.width
        star_counter_fragments[2].frame.origin.x = star_counter_fragments[1].frame.origin.x + star_counter_fragments[1].frame.width
        star_counter_fragments[3].frame.origin.x = star_counter_fragments[2].frame.origin.x + star_counter_fragments[2].frame.width
        print("star counter fragment 0 width is \(star_counter_fragments[0].frame.width)")
         //self.view.addSubview(star_counter_fragments[0])
        //self.view.addSubview(star_counter_fragments[1])
        //self.view.addSubview(star_counter_fragments[2])
        //self.view.addSubview(star_counter_fragments[3])
        star_counter_fragment_width = star_counter_fragments[2].frame.width
        self.view.bringSubview(toFront: star_board)
      print(star_counter_fragment_width)
    }
    
    func reorder_star_counter() -> Void{
        
        self.view.sendSubview(toBack: self.star_store_button)
        self.view.sendSubview(toBack: self.star_board)
        self.view.sendSubview(toBack: self.star_counter_fragments[0])
        self.view.sendSubview(toBack: self.star_counter_fragments[1])
        self.view.sendSubview(toBack: self.star_counter_fragments[2])
        self.view.sendSubview(toBack: self.star_counter_fragments[3])
        self.view.sendSubview(toBack: background_image)
    }
    
    var star_board_original_width = CGFloat(0)
    var star_counter_fragment_width = CGFloat(0)
    var star_counter_total_length = CGFloat(0)
    func update_star_counter_length(i: Int) -> Void{
    print("star_board_original_width: \(star_board_original_width)")
    
    star_board.frame.size = CGSize(width: star_board_original_width + (CGFloat(i)*pause_screen_x_transform(5)), height: star_board.frame.height)
    print("star_board width: \(star_board.frame.width)")
    star_counter_fragments[2].frame.size = CGSize(width: star_counter_fragment_width + CGFloat(i)*pause_screen_x_transform(5), height: star_counter_fragments[2].frame.height)
    star_counter_fragments[3].frame.origin.x = star_counter_fragments[2].frame.origin.x + star_counter_fragments[2].frame.width
    star_counter_total_length = star_counter_fragments[0].frame.width + star_counter_fragments[1].frame.width + star_counter_fragments[2].frame.width + star_counter_fragments[3].frame.width
    star_store_button.frame.size = CGSize(width: star_counter_total_length, height: star_counter_fragments[0].frame.height)
    //star_counter.frame.size = CGSize(width: star_counter_total_length, height: star_counter_fragments[0].frame.height)
    }
    
    func update_star_counter_length_according_to_string_length() -> Void{
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
        update_star_counter_length(i: argument_integer)
    }
    
//current star total auto resize
    var current_star_total_fragments : Array<UIView> = []
    var current_star_total_text_width = CGFloat(0)
    var current_star_fragments_width = CGFloat(0)
    var current_star_total_length = CGFloat(0)
    func split_current_star_total() -> Void{
        current_star_total_fragments = []
        current_star_total.alpha = 1
        current_star_total_fragments = current_star_total.generateFragmentsFrom(current_star_total, with: 4.0, in: self.view)
        _ = 0
        current_star_total.alpha = 0
        current_star_total_fragments[0].frame.origin.x = current_star_total.frame.origin.x
        current_star_total_fragments[1].frame.origin.x = current_star_total_fragments[0].frame.origin.x + current_star_total_fragments[0].frame.width
        current_star_total_fragments[2].frame.origin.x = current_star_total_fragments[1].frame.origin.x + current_star_total_fragments[1].frame.width
        current_star_total_fragments[3].frame.origin.x = current_star_total_fragments[2].frame.origin.x + current_star_total_fragments[2].frame.width
        print("current_star_total_fragments 0 width is \(current_star_total_fragments[0].frame.width)")
        print("0 x is \(current_star_total_fragments[0].frame.origin.x)")
        self.view.addSubview(current_star_total_fragments[0])
        self.view.addSubview(current_star_total_fragments[1])
        self.view.addSubview(current_star_total_fragments[2])
        self.view.addSubview(current_star_total_fragments[3])
        current_star_fragments_width = current_star_total_fragments[2].frame.width
        self.view.bringSubview(toFront: current_star_total_text)
        
        //print(star_counter_fragment_width)
    }
    func remove_all_current_star_fragments() -> Void{
        treasuer_box_star_store_button.removeFromSuperview()
        current_star_total_fragments[0].removeFromSuperview()
        current_star_total_fragments[1].removeFromSuperview()
        current_star_total_fragments[2].removeFromSuperview()
        current_star_total_fragments[3].removeFromSuperview()
    }
    
    func update_current_star_length_according_to_string_length() -> Void{
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
        update_current_star_length(i: argument_integer)
    }
    func update_current_star_length(i: Int) -> Void{
        //print("star_board_original_width: \(star_board_original_width)")
        current_star_total_text.frame.size = CGSize(width: current_star_total_text_width + (CGFloat(i)*pause_screen_x_transform(2)), height: current_star_total_text.frame.height)
       // print("star_board width: \(star_board.frame.width)")
        current_star_total_fragments[2].frame.size = CGSize(width: current_star_fragments_width + CGFloat(i)*pause_screen_x_transform(2), height: current_star_total_fragments[2].frame.height)
        current_star_total_fragments[3].frame.origin.x = current_star_total_fragments[2].frame.origin.x + current_star_total_fragments[2].frame.width
        current_star_total_length = current_star_total_fragments[0].frame.width + current_star_total_fragments[1].frame.width + current_star_total_fragments[2].frame.width + current_star_total_fragments[3].frame.width
        treasuer_box_star_store_button.frame.size = CGSize(width: current_star_total_length, height: current_star_total_fragments[0].frame.height)
    }
 ///// theme star counter auto resize
    var theme_star_counter_fragments : Array<UIView> = []
    var theme_star_board_width = CGFloat(0)
    var theme_star_counter_fragments_width = CGFloat(0)
    
    func split_theme_star_counter() -> Void{
        theme_star_counter_fragments = []
        theme_star_counter.alpha = 1
        theme_star_counter_fragments = theme_star_counter.generateFragmentsFrom(theme_star_counter, with: 4.0, in: self.view)
        _ = 0
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
        theme_star_counter_fragments[0].removeFromSuperview()
        theme_star_counter_fragments[1].removeFromSuperview()
        theme_star_counter_fragments[2].removeFromSuperview()
        theme_star_counter_fragments[3].removeFromSuperview()
        theme_menu_star_store_button.removeFromSuperview()
    }
    
    func remove_all_theme_star_counter_fragments_with_fading() -> Void{
        theme_menu_star_store_button.fadeOutandRemove()
        theme_star_counter_fragments[0].fadeOutandRemove()
        theme_star_counter_fragments[1].fadeOutandRemove()
        theme_star_counter_fragments[2].fadeOutandRemove()
        theme_star_counter_fragments[3].fadeOutandRemove()
        
        
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
       theme_star_total_length = theme_star_counter_fragments[0].frame.width + theme_star_counter_fragments[1].frame.width + theme_star_counter_fragments[2].frame.width + theme_star_counter_fragments[3].frame.width
        theme_menu_star_store_button.frame.size = CGSize(width: theme_star_total_length, height: theme_star_counter_fragments[0].frame.height)

    }
  
//tool select menu auto resizing  first divide into four then combine all togather as one image
    var total_price_fragments : Array<UIView> = []
    var total_price_text_width = CGFloat(0)
    var total_price_fragments_width = CGFloat(0)
    
    func split_total_price_counter() -> Void{
        total_price_fragments = []
        total_price_image.alpha = 1
        total_price_fragments = total_price_image.generateFragmentsFrom(total_price_image, with: 4.0, in: self.view)
        //var i = 0
        let total_price_fragments_image = total_price_image.generateImageFragmentsFrom(total_price_image, with: 4.0, in: self.view)
        //let image_super_temp = total_price_fragments_image[0]
        total_price_fragments_image[0].draw(at: CGPoint.zero)
        total_price_image.alpha = 0
        total_price_fragments[0].frame.origin.x = total_price_image.frame.origin.x
        total_price_fragments[1].frame.origin.x = total_price_fragments[0].frame.origin.x + total_price_fragments[0].frame.width
        total_price_fragments[2].frame.origin.x = total_price_fragments[1].frame.origin.x + total_price_fragments[1].frame.width
        total_price_fragments[3].frame.origin.x = total_price_fragments[2].frame.origin.x + total_price_fragments[2].frame.width
        //print("current_star_total_fragments 0 width is \(current_star_total_fragments[0].frame.width)")
        //print("0 x is \(current_star_total_fragments[0].frame.origin.x)")
        self.view.addSubview(total_price_fragments[0])
        self.view.addSubview(total_price_fragments[1])
        self.view.addSubview(total_price_fragments[2])
        self.view.addSubview(total_price_fragments[3])
        total_price_fragments[0].alpha = 0
        total_price_fragments[1].alpha = 0
        total_price_fragments[2].alpha = 0
        total_price_fragments[3].alpha = 0
        total_price_fragments[0].fadeIn()
        total_price_fragments[1].fadeIn()
        total_price_fragments[2].fadeIn()
        total_price_fragments[3].fadeIn()
        total_price_fragments_width = total_price_fragments[2].frame.width
        self.view.bringSubview(toFront: total_star_need_label)
        //let temp_image = combine_total_price_fragments()
        //print(star_counter_fragment_width)
    }
    func remove_all_total_price_fragments() -> Void{
        total_price_fragments[0].removeFromSuperview()
        total_price_fragments[1].removeFromSuperview()
        total_price_fragments[2].removeFromSuperview()
        total_price_fragments[3].removeFromSuperview()
    }
    
    func update_total_star_length_according_to_string_length() -> Void{
        var i = 0
        var loop = true
        var argument_integer = 0
        if(star_quantiry_needed != 0){
            while(loop){
                let first_pow = pow(10, Double(i))
                let second_pow = pow(10, Double(i+1))
                if(Double(star_quantiry_needed) >= first_pow && Double(star_quantiry_needed) < second_pow){
                    loop = false
                }
                i += 1
            }
        }else{
            i = 0
        }
        argument_integer = i - 2
        update_total_star_length(i: argument_integer)
        total_star_full_length = total_price_fragments[0].frame.width + total_price_fragments[1].frame.width + total_price_fragments[2].frame.width + total_price_fragments[3].frame.width
    }
    func update_total_star_length(i: Int) -> Void{
        //print("star_board_original_width: \(star_board_original_width)")
        final_price_button.frame.size = CGSize(width: final_price_button_length + (CGFloat(i)*pause_screen_x_transform(2)) , height: final_price_button.frame.height)
        total_star_need_label.frame.size = CGSize(width: total_price_text_width + (CGFloat(i)*pause_screen_x_transform(2)), height: total_star_need_label.frame.height)
        // print("star_board width: \(star_board.frame.width)")
        total_price_fragments[2].frame.size = CGSize(width: total_price_fragments_width + CGFloat(i)*pause_screen_x_transform(2), height: total_price_fragments[2].frame.height)
        total_price_fragments[3].frame.origin.x = total_price_fragments[2].frame.origin.x + total_price_fragments[2].frame.width
        
    }
    
    func combine_total_price_fragments() -> UIImage{
    total_price_fragments[0].alpha = 1
        total_price_fragments[1].alpha = 1
        total_price_fragments[2].alpha = 1
        total_price_fragments[3].alpha = 1
        self.view.bringSubview(toFront: total_price_fragments[0])
        self.view.bringSubview(toFront: total_price_fragments[1])
        self.view.bringSubview(toFront: total_price_fragments[2])
        self.view.bringSubview(toFront: total_price_fragments[3])

    let total_width = total_price_fragments[0].frame.width + total_price_fragments[1].frame.width + total_price_fragments[2].frame.width + total_price_fragments[3].frame.width
    let new_size = CGSize(width: total_width, height: total_price_fragments[0].frame.height)
    let point_0 = CGPoint.zero
    let point_1 = CGPoint(x: total_price_fragments[0].frame.width, y: 0)
    let point_2 = CGPoint(x: point_1.x + total_price_fragments[1].frame.width, y: 0)
    let point_3 = CGPoint(x: point_2.x + total_price_fragments[2].frame.width, y: 0)
    let image_0 = total_price_fragments[0].createImage()
    
    
    //image_0.draw(at: CGPoint(x: 200, y: 200))
    let image_1 = total_price_fragments[1].createImage()
    let image_2 = total_price_fragments[2].createImage()
    let image_3 = total_price_fragments[3].createImage()

    UIGraphicsBeginImageContext(new_size)
    image_0.draw(in: CGRect(origin: point_0, size:total_price_fragments[0].frame.size))
    image_1.draw(in: CGRect(origin: point_1, size:total_price_fragments[1].frame.size))
    image_2.draw(in: CGRect(origin: point_2, size:total_price_fragments[2].frame.size))
    image_3.draw(in:  CGRect(origin: point_3, size:total_price_fragments[3].frame.size))
    let new_image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return new_image!
    }

//like button action
    
    @IBAction func like_button_action(_ sender: UIButton) {
        if(settings_scene_is_opened){
            close_settings_scene()
        }
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
        //sender.materialAnimation()
        
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
        self.treasure_box_icon.isEnabled = false
        self.tutorial_button.isEnabled = false
        self.settings_button.isEnabled = false
        self.gift_button.isEnabled = false
        self.star_counter.isEnabled = false
        self.like_button.isEnabled = false
        self.continue_button.isEnabled = false
        self.shopping_cart.isEnabled = false
        self.star_store_button.isEnabled = false
        
        self.day_apply_button.isEnabled = false
        self.night_apply_button.isEnabled = false
        self.BW_apply_button.isEnabled = false
        self.school_apply_button.isEnabled = false
        self.colors_apply_button.isEnabled = false
        self.theme_menu_star_store_button.isEnabled = false
        self.return_button.isEnabled = false
        
        
        self.treasuer_box_star_store_button.isEnabled = false
        self.new_life_button.isEnabled = false
        self.same_color_eliminator.isEnabled = false
        self.shape_bomb.isEnabled = false
        self.times_two.isEnabled = false
        self.three_triangles.isEnabled = false
        self.clear_all.isEnabled = false
        
        
        self.treasure_cancel.isEnabled = false
        
        
        
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
            self.treasure_box_icon.isEnabled = true
            self.tutorial_button.isEnabled = true
            self.settings_button.isEnabled = true
            self.gift_button.isEnabled = true
            self.star_counter.isEnabled = true
            self.like_button.isEnabled = true
            self.continue_button.isEnabled = true
            self.shopping_cart.isEnabled = true
            self.day_apply_button.isEnabled = true
            self.night_apply_button.isEnabled = true
            self.BW_apply_button.isEnabled = true
            self.school_apply_button.isEnabled = true
            self.star_store_button.isEnabled = true
            self.colors_apply_button.isEnabled = true
            self.theme_menu_star_store_button.isEnabled = true
            self.treasuer_box_star_store_button.isEnabled = true
            self.new_life_button.isEnabled = true
            self.same_color_eliminator.isEnabled = true
            self.shape_bomb.isEnabled = true
            self.times_two.isEnabled = true
            self.three_triangles.isEnabled = true
            self.clear_all.isEnabled = true
            self.return_button.isEnabled = true
            
            self.treasure_cancel.isEnabled = true
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
        self.treasure_box_icon.isEnabled = true
        self.tutorial_button.isEnabled = true
        self.settings_button.isEnabled = true
        self.gift_button.isEnabled = true
        self.star_counter.isEnabled = true
        self.like_button.isEnabled = true
        self.continue_button.isEnabled = true
        self.shopping_cart.isEnabled = true
        self.day_apply_button.isEnabled = true
        self.star_store_button.isEnabled = true
        self.night_apply_button.isEnabled = true
        self.BW_apply_button.isEnabled = true
        self.school_apply_button.isEnabled = true
        self.colors_apply_button.isEnabled = true
        self.theme_menu_star_store_button.isEnabled = true
        self.treasuer_box_star_store_button.isEnabled = true
        self.new_life_button.isEnabled = true
        self.same_color_eliminator.isEnabled = true
        self.shape_bomb.isEnabled = true
        self.times_two.isEnabled = true
        self.three_triangles.isEnabled = true
        self.clear_all.isEnabled = true
         self.return_button.isEnabled = true
        self.treasure_cancel.isEnabled = true
        
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
        self.treasure_box_icon.isEnabled = true
        self.tutorial_button.isEnabled = true
        self.settings_button.isEnabled = true
        self.gift_button.isEnabled = true
        self.star_counter.isEnabled = true
        self.like_button.isEnabled = true
        self.continue_button.isEnabled = true
        self.shopping_cart.isEnabled = true
        self.day_apply_button.isEnabled = true
        self.night_apply_button.isEnabled = true
        self.BW_apply_button.isEnabled = true
        self.star_store_button.isEnabled = true
        self.school_apply_button.isEnabled = true
        self.colors_apply_button.isEnabled = true
        self.theme_menu_star_store_button.isEnabled = true
        self.treasuer_box_star_store_button.isEnabled = true
        self.new_life_button.isEnabled = true
        self.same_color_eliminator.isEnabled = true
        self.shape_bomb.isEnabled = true
        self.times_two.isEnabled = true
        self.three_triangles.isEnabled = true
        self.clear_all.isEnabled = true
         self.return_button.isEnabled = true
        self.treasure_cancel.isEnabled = true
        
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
            print (trans.error as Any)
            
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
    
    
    //game center
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    func openGameCenter() -> Void{
    let game_center_controller = GKGameCenterViewController()
    game_center_controller.gameCenterDelegate = self
    self.present(game_center_controller, animated: true, completion: nil)
        
        
    }
    
    func saveBestScore() {
        let leaderboardID = "tri_tri_highest_score"
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(Int(highest_score.text!)!)
        GKScore.report([sScore], withCompletionHandler: nil)
    }
    
    func authPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view,error) -> Void in
            
            if view != nil{
                self.present(view!, animated: true, completion: nil)
            }else if(GKLocalPlayer.localPlayer().isAuthenticated){
                print(GKLocalPlayer.localPlayer().isAuthenticated)
                self.gcEnabled = true
                
               // //get default leader board id
                /**localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                } as! (String?, Error?) -> Void)  **/
            }else{
                //game center not enabled
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error as Any)
                
            }
            
            
            
        }
        
        
        
        
        
    }

    
    
    @IBAction func openGC(_ sender: UIButton) {
        openGameCenter()
    }
    
  
    func apply_button_restore(){
        if(ThemeType == 1){
            UIView.transition(with: self.day_apply_button, duration: 0.4, options: .transitionFlipFromLeft , animations: {
                self.day_apply_button.frame.origin.x += self.pause_screen_x_transform(16)
                self.day_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                if (self.language == "English"){
                    self.day_apply_button.setImage(#imageLiteral(resourceName: "day_mode_use"), for: .normal)
                }
                else {
                    self.day_apply_button.setImage(#imageLiteral(resourceName: "day_mode_use_ch"), for: .normal)
                }
                
            })
            
            
        }else if(ThemeType == 2){
            UIView.transition(with: self.night_apply_button, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.night_apply_button.frame.origin.x += self.pause_screen_x_transform(16)
                self.night_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                if (self.language == "English"){
                    self.night_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
                }
                else {
                    self.night_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
                }
            })
            
        }else if(ThemeType == 3){
            UIView.transition(with: self.BW_apply_button, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.BW_apply_button.frame.origin.x += self.pause_screen_x_transform(16)
                self.BW_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                if (self.language == "English"){
                    self.BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
                }
                else {
                    self.BW_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
                }
            })
            
            
        }else if(ThemeType == 5){
            UIView.transition(with: self.school_apply_button, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.school_apply_button.frame.origin.x += self.pause_screen_x_transform(16)
                self.school_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                if (self.language == "English"){
                    self.school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use"), for: .normal)
                }
                else {
                    self.school_apply_button.setImage(#imageLiteral(resourceName: "school_mode_use_ch"), for: .normal)
                }
            })
            
        }else if(ThemeType == 6){
            UIView.transition(with: self.colors_apply_button, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.colors_apply_button.frame.origin.x += self.pause_screen_x_transform(16)
                self.colors_apply_button.frame.size = CGSize(width: self.pause_screen_x_transform(100), height: self.pause_screen_y_transform(36))
                if (self.language == "English"){
                    self.colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use"), for: .normal)
                }
                else {
                    self.colors_apply_button.setImage(#imageLiteral(resourceName: "night_mode_use_ch"), for: .normal)
                }
            })
        }
    }
    
   var settings_scene_is_opened = false
    
    @IBAction func settings_action(_ sender: UIButton) {
    
        if(!sound_is_muted){
        do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
            self.button_player.prepareToPlay()
        }
        catch{
            
        }
        self.button_player.play()
        }

        if(!settings_scene_is_opened){
            open_settings_scene()
        }else{
            close_settings_scene()
        }
        
        
        
    }
    
    func open_settings_scene(){
        settings_functional_button_location_decider()
        settings_functional_button_image_decider()
        self.view.addSubview(language_button)
        self.view.addSubview(mute_button)
        self.view.addSubview(gameCenter_button)
        settings_button.isUserInteractionEnabled = false
        language_button.alpha = 0
        mute_button.alpha = 0
        gameCenter_button.alpha = 0
        language_button.fadeIn()
        mute_button.fadeIn()
        gameCenter_button.fadeIn()
        UIView.animate(withDuration: 0.5, delay: 00, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, options: .curveLinear, animations: {
        self.gear_icon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2.0))
        }, completion: nil)
        UIView.animate(withDuration: 0.5, animations: {
        self.settings_scene.frame = CGRect(x: self.settings_button.frame.origin.x - self.pause_screen_x_transform(100), y: self.settings_button.frame.origin.y, width: self.pause_screen_x_transform(100) + self.settings_button.frame.width, height: self.pause_screen_x_transform(100) + self.settings_button.frame.width)
        }, completion: {
            (finished) -> Void in
        self.settings_scene_is_opened = true
        self.set_settings_functional_button_functionality()
        self.settings_button.isUserInteractionEnabled = true
        })
    }
    
    func close_settings_scene(){
        language_button.fadeOutandRemove()
        mute_button.fadeOutandRemove()
        gameCenter_button.fadeOutandRemove()
        self.settings_button.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, delay: 00, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, options: .curveLinear, animations: {
            self.gear_icon.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.settings_scene.frame = self.settings_scene_original
        }, completion: {
            (finished) -> Void in
            self.settings_scene_is_opened = false
            self.settings_button.isUserInteractionEnabled = true
        })
        
    }
    
    func set_settings_functional_button_functionality(){
        //language button
        language_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
            }
            
            if(self.language == "English"){
                self.language = "Chinese"
            }else{
                self.language = "English"
            }
            defaults.set(self.language, forKey: "language")
            self.language_button_image_decider()
            self.triangle_title_image_decider()
        })
        //mute button
        mute_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
            }
            
            if(self.sound_is_muted){
                self.sound_is_muted = false
            }else{
                self.sound_is_muted = true
            }
            defaults.set(self.sound_is_muted, forKey: "tri_tri_sound_is_muted")
            self.mute_image_decider()
        })
        //gamecenter button
        gameCenter_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
                do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                    self.button_player.prepareToPlay()
                }
                catch{
                    
                }
                self.button_player.play()
            }

            self.openGameCenter()
        })
        
        
    }
    

    func settings_functional_button_image_decider(){
    //language button
    language_button.contentMode = .scaleAspectFit
    language_button_image_decider()
    //now decide mute button
    mute_button.contentMode = .scaleAspectFit
     mute_image_decider()
    //now gamecenter button
    gameCenter_button.contentMode = .scaleAspectFit
        if(ThemeType == 1){
        gameCenter_button.setImage(#imageLiteral(resourceName: "gameCenter_day&night"), for: .normal)
        }else if(ThemeType == 2){
        gameCenter_button.setImage(#imageLiteral(resourceName: "gameCenter_day&night"), for: .normal)
        }else if(ThemeType == 3){
        gameCenter_button.setImage(#imageLiteral(resourceName: "gameCenter_colors&BW"), for: .normal)
        }else if(ThemeType == 5){
        gameCenter_button.setImage(#imageLiteral(resourceName: "gameCenter_school"), for: .normal)
        }else if(ThemeType == 6){
        gameCenter_button.setImage(#imageLiteral(resourceName: "gameCenter_colors&BW"), for: .normal)
        }
    }
    
    func settings_functional_button_location_decider(){
     language_button.frame = CGRect(x: settings_button.frame.origin.x - pause_screen_x_transform(40), y: pause_screen_y_transform(6), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45))
        mute_button.frame = CGRect(x: settings_button.frame.origin.x + pause_screen_x_transform(12) , y: pause_screen_y_transform(61), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45))
    gameCenter_button.frame = CGRect(x: settings_button.frame.origin.x + pause_screen_x_transform(60) , y: pause_screen_y_transform(116), width: pause_screen_x_transform(45), height: pause_screen_y_transform(45))
    }
    
    func mute_image_decider(){
        //all sound is on
        if(!sound_is_muted){
            if(ThemeType == 1){
            mute_button.setImage(#imageLiteral(resourceName: "mute_day&night"), for: .normal)
            }else if(ThemeType == 2){
            mute_button.setImage(#imageLiteral(resourceName: "mute_day&night"), for: .normal)
            }else if(ThemeType == 3){
            mute_button.setImage(#imageLiteral(resourceName: "mute_bw&colors"), for: .normal)
            }else if(ThemeType == 5){
           mute_button.setImage(#imageLiteral(resourceName: "mute_school"), for: .normal)
            }else if(ThemeType == 6){
                mute_button.setImage(#imageLiteral(resourceName: "mute_bw&colors"), for: .normal)
                
            }
        }else{
        //all sound is off
            if(ThemeType == 1){
            mute_button.setImage(#imageLiteral(resourceName: "unmute_day&night"), for: .normal)
            }else if(ThemeType == 2){
            mute_button.setImage(#imageLiteral(resourceName: "unmute_day&night"), for: .normal)
            }else if(ThemeType == 3){
                mute_button.setImage(#imageLiteral(resourceName: "unmute_bw&colors"), for: .normal)
            }else if(ThemeType == 5){
            mute_button.setImage(#imageLiteral(resourceName: "unmute_school"), for: .normal)
            }else if(ThemeType == 6){
                mute_button.setImage(#imageLiteral(resourceName: "unmute_bw&colors"), for: .normal)
                
            }
           
        }
    }
    
    
}




public extension UIView{
    
//only horizontal gap
func generateFragmentsFrom(_ originView:UIView, with splitRatio:CGFloat, in containerView:UIView) -> [UIView] {
    
        let size = originView.frame.size
        let snapshots = originView.snapshotView(afterScreenUpdates: true)
        var fragments = [UIView]()
        
        //let shortSide = min(size.width, size.height)
        let gap =  size.width/splitRatio
        
        for x in stride(from: 0.0, to: Double(size.width), by: Double(gap)) {
            
                
                let fragmentRect = CGRect(x: CGFloat(x), y: CGFloat(0.0), width: size.width/splitRatio, height: size.height)
                let fragment = snapshots?.resizableSnapshotView(from: fragmentRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
                
                fragment?.frame = originView.convert(fragmentRect, to: containerView)
                containerView.addSubview(fragment!)
                fragments.append(fragment!)
                
            
        }
        
        return fragments
        
    }
   
    func generateImageFragmentsFrom(_ originView:UIView, with splitRatio:CGFloat, in containerView:UIView) -> [UIImage] {
        
        let size = originView.frame.size
        let snapshots = originView.snapshotView(afterScreenUpdates: true)
        var fragments = [UIImage]()
        
        //let shortSide = min(size.width, size.height)
        let gap =  size.width/splitRatio
        
        for x in stride(from: 0.0, to: Double(size.width), by: Double(gap)) {
            
            
            let fragmentRect = CGRect(x: CGFloat(x), y: CGFloat(0.0), width: size.width/splitRatio, height: size.height)
            UIGraphicsBeginImageContext(fragmentRect.size)
            snapshots?.drawHierarchy(in: fragmentRect, afterScreenUpdates: false)
            //let fragment = snapshots?.resizableSnapshotView(from: fragmentRect, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
            
            let fragment = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //containerView.addSubview(fragment!)
            fragments.append(fragment!)
            
            
        }
        
        return fragments
        
    }

    
    func createImage() -> UIImage {
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            // Fallback on earlier versions
            let rect: CGRect = self.frame
            
            UIGraphicsBeginImageContext(rect.size)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            self.layer.render(in: context)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img!
        }
    }
    
    func shake(duration: CFTimeInterval) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            ( degrees: Double) -> Double in
            let radians: Double = (M_PI * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
    
    
    func twoPointBounceOut(translation1_y: CGFloat, translation2_y: CGFloat , final_completetion:  @escaping ()->()){
    //self.final_action
    self.frame.origin.y = self.frame.origin.y + translation1_y
    self.transform = CGAffineTransform(translationX: 0, y: -translation1_y)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = .identity
        }, completion: {
            (finish) -> Void in
            self.frame.origin.y = self.frame.origin.y - translation1_y + translation2_y
            self.transform = CGAffineTransform(translationX: 0, y: -translation2_y + translation1_y)
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = .identity
            }, completion: {
                (finished) -> Void in
                self.removeFromSuperview()
                final_completetion()
            })
        })
     
        
     
        
        
        
    }
    
    
    func blink(final_completetion:  @escaping ()->()){
        self.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            
            self.alpha = 0
        }, completion: {
            (finished) -> Void in
            UIView.animate(withDuration: 0.2, animations: {
             self.alpha = 1
                
            }, completion: {
                (finished) -> Void in
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0
                }, completion: {
                    (finished) -> Void in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.alpha = 1
                    }, completion: {
                        (finished) -> Void in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.alpha = 0
                        }, completion: {
                            (finished) -> Void in
                            UIView.animate(withDuration: 0.2, animations: {
                                self.alpha = 1
                                final_completetion()
                            })//
                        })//
                    })
                })
                
            })
       
        })
        
        
    }
    
  
    
   }


extension UIButton{
  
    func materialAnimation(){
    
    let mask = UIView(frame: self.frame)
    mask.backgroundColor = UIColor.white
    mask.alpha = 0.4
    self.addSubview(mask)
        
    //add UIBenzier Path
    let intialRec = CGRect(x: self.center.x, y: self.center.y, width: 0.01, height: 0.01)
    let circleMaskPathInit = UIBezierPath(ovalIn: intialRec)
    let circleMaskPathFinal = UIBezierPath(ovalIn: self.frame)
    _ = sqrt(Double(self.frame.width*self.frame.width + self.frame.height*self.frame.height))
        
        
    let maskLayer = CAShapeLayer()
    maskLayer.path = circleMaskPathFinal.cgPath
    self.layer.mask = maskLayer
        
    CATransaction.begin()
    let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        CATransaction.setCompletionBlock({
            mask.removeFromSuperview()
        })
    maskLayerAnimation.fromValue = circleMaskPathInit
    maskLayerAnimation.toValue = circleMaskPathFinal
    maskLayerAnimation.duration = 0.5
    //maskLayerAnimation.delegate = self
    maskLayer.add(maskLayerAnimation, forKey: "path")
    CATransaction.commit()
    }
    
    
    
    
    
    
    
}



