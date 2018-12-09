//
//  DailyGiftViewController.swift
//  tri-tri
//
//  Created by Feiran Hu on 2017-06-29.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import UserNotifications

class DailyGiftViewController: UIViewController {
    //screen width and height
    
    var button_player = AVAudioPlayer()
    var screen_width : CGFloat = 0
    var screen_height : CGFloat = 0
    var real_velocity = Double(0)
    var display_reward : Bool = false
    var quit_during_spinning = false
    var during_spinning = false
    var defaults = UserDefaults.standard
    var star_score = 0
    var gesture_passing_area = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    var time_storing = [0,0,0,0,0,0]
    var previous_time_storing = [0,0,0,0,0,0]
    var count_down_end = true
    var count_down_time_string = String()
    
    //clock trick sound
    var clock_player = AVAudioPlayer()
    //unlock sound
    var unlock_player = AVAudioPlayer()
    var unlock_player_played_time = 0
    //spinning player
    var spinning_player = AVAudioPlayer()
    
    var count_down_timer_during_reward = Timer()
    var lock_screen_count_down_timer = Timer()
    
    
    var clock_sound_effect_should_on = true
    var spin_sound_effect_should_on = true
    var unlock_sound_effect_should_on = true
    
    //left up: 0 right up: 1 right down: 2 left down: 3 unknown: -1
    
    @IBOutlet weak var wheel_background: UIImageView!
    @IBOutlet weak var wheel_text: UIImageView!
    
    @IBOutlet weak var wheel_pointer: UIImageView!
    
    @IBOutlet weak var wheel_outer: UIImageView!
    @IBOutlet weak var wheel: UIImageView!
    
    
    //spin category
    var spin_category = 0
    
    
    var final_translation = CGPoint(x: 0, y: 0)
    var spin_initial_point = CGPoint(x: 0, y: 0)
    
    var current_passing_area = 0
    var current_passing_array_index = 0
    
    var total_seconds = 12*60*60
    //rotation_direction == 0 (clockwise)
    //rotation_direction == 1 (counterclockwise)
    var rotation_direction = 0
    
    
    var last_final_angle = 0
    
    //lock screen
    var lock_screen = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var count_down_label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var grey_transparent_image = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var cancel_button_lock = MyButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //rewards count down
    var rewards_count_down = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //rewards screen
    var ten_points = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var twenty_five_points = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var thirty_five_points = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //override touch begin function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        spin_initial_point = touches.first!.location(in: view)
        //print("initial touch location is x: \(spin_initial_point.x), y: \(spin_initial_point.y)")
        current_passing_array_index = 0
        if((spin_initial_point.x - wheel.frame.origin.x) < wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y < wheel.frame.height/2 ){
            current_passing_area = 0
            gesture_passing_area[0] = 0
        }
            
            //current position in right uper boundary
        else if((spin_initial_point.x - wheel.frame.origin.x) > wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y < wheel.frame.height/2 ){
            current_passing_area = 1
            gesture_passing_area[0] = 1
        }
            //current postion in right downer boundary
        else if((spin_initial_point.x - wheel.frame.origin.x) > wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y > wheel.frame.height/2 ){
            current_passing_area = 2
            gesture_passing_area[0] = 2
        }
            //current position in left downer
        else if((spin_initial_point.x - wheel.frame.origin.x) < wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y > wheel.frame.height/2 ){
            current_passing_area = 3
            gesture_passing_area[0] = 3
        }
        
        
    }
    
    func background_music_pause() -> Void{
        clock_sound_effect_should_on = false
        spin_sound_effect_should_on = false
        unlock_sound_effect_should_on = false
    }
    
    func background_music_continue() -> Void{
        clock_sound_effect_should_on = true
        spin_sound_effect_should_on = true
        unlock_sound_effect_should_on = true
        
    }
    
    var sound_is_muted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //when enter background
        NotificationCenter.default.addObserver(self, selector: #selector(DailyGiftViewController.background_music_pause) , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DailyGiftViewController.background_music_continue), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        unlock_player_played_time = 0
        display_reward = false
        screen_width = self.view.frame.width
        screen_height = self.view.frame.height
        wheel_background.frame = self.view.frame
        wheel_background.image = #imageLiteral(resourceName: "treasure_background")
        wheel_background.contentMode = .scaleAspectFill
        star_score = defaults.value(forKey: "tritri_star_score") as! NSInteger
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "wheel_background.png")!)
        let cancel_button = MyButton(frame: CGRect(x: screen_x_transform(250), y: screen_y_transform(542), width: screen_x_transform(125), height: screen_y_transform(125)))
        cancel_button.setImage(UIImage(named: "wheel_cancel"), for: .normal)
        self.view.addSubview(cancel_button)
        // Do any additional setup after loading the view.
        cancel_button.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            nextViewController.modalTransitionStyle = .crossDissolve
            self.count_down_timer_during_reward.invalidate()
            self.lock_screen_count_down_timer.invalidate()
            if(self.during_spinning){
                self.quit_during_spinning = true
            }
            self.present(nextViewController, animated: true, completion: nil)
            
        })
        wheel_text.frame = CGRect(x: screen_x_transform(Double(wheel_text.frame.origin.x)), y: screen_y_transform(Double(wheel_text.frame.origin.y)), width: screen_x_transform(Double(wheel_text.frame.width)), height: screen_y_transform(Double(wheel_text.frame.height)))
        if (defaults.value(forKey: "language") as! String == "English"){
            wheel_text.image = #imageLiteral(resourceName: "wheel_text")
        }
        else {
            wheel_text.image = #imageLiteral(resourceName: "dailygift_text_chinese")
        }
        
        wheel.frame = CGRect(x: screen_x_transform(Double(wheel.frame.origin.x)), y: screen_y_transform(Double(wheel.frame.origin.y)), width: screen_x_transform(Double(wheel.frame.width)), height: screen_y_transform(Double(wheel.frame.height)))
        wheel.image = #imageLiteral(resourceName: "wheel")
        //self.view.bringSubview(toFront: wheel)
        //wheel.contentMode = .scaleAspectFit
        wheel_outer.frame = CGRect(x: screen_x_transform(Double(wheel_outer.frame.origin.x)), y: screen_y_transform(Double(wheel_outer.frame.origin.y)), width: screen_x_transform(Double(wheel_outer.frame.width)), height: screen_y_transform(Double(wheel_outer.frame.height)))
        wheel_outer.image = #imageLiteral(resourceName: "wheel_outer")
        wheel_pointer.frame = CGRect(x: screen_x_transform(Double(wheel_pointer.frame.origin.x)), y: screen_y_transform(Double(wheel_pointer.frame.origin.y)), width: screen_x_transform(Double(wheel_pointer.frame.width)), height: screen_y_transform(Double(wheel_pointer.frame.height)))
        wheel_pointer.image = #imageLiteral(resourceName: "wheel_pointer")
        //self.view.sendSubview(toBack: wheel_outer)
        //self.view.bringSubview(toFront: wheel)
        
        //add pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        //count down
        //initialize count board
        real_time_handler()
        if(!count_down_end){
            let hours = total_seconds/(60*60)
            let seconds_times_min = total_seconds%(60*60)
            let min = seconds_times_min/60
            let seconds = seconds_times_min%60
            count_down_time_string = hours_formatter(hours: hours) + " : " + min_formatter(min: min) + " : " + sec_formatter(sec: seconds)
            lock_screen_function()
            lock_screen_count_down_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DailyGiftViewController.auto_count_down), userInfo: nil, repeats: true)
            
            //
        }
        if (defaults.value(forKey: "tri_tri_sound_is_muted") == nil){
            sound_is_muted = false
            defaults.set(sound_is_muted, forKey: "tri_tri_sound_is_muted")
        }
        else {
            sound_is_muted = defaults.value(forKey: "tri_tri_sound_is_muted") as! Bool
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func lock_screen_function() -> Void {
        
        lock_screen = UIView(frame: CGRect(origin: CGPoint(x: 0, y:0),size: CGSize(width: screen_width, height: screen_height)))
        lock_screen.backgroundColor = UIColor(red:CGFloat(255.0/255.0), green:CGFloat(255.0/255.0), blue:CGFloat(255.0/255.0), alpha:CGFloat(1))
        lock_screen.alpha = 0
        self.view.addSubview(lock_screen)
        lock_screen.fadeInTrans()
        grey_transparent_image = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y:0),size: CGSize(width: screen_width, height: screen_height)))
        if (defaults.value(forKey: "language") as! String == "English"){
            grey_transparent_image.image = #imageLiteral(resourceName: "grey_transparent")        }
        else {
            grey_transparent_image.image = #imageLiteral(resourceName: "time_remaining_chinese")
        }
        
        grey_transparent_image.alpha = 0
        self.view.addSubview(grey_transparent_image)
        grey_transparent_image.fadeIn()
        cancel_button_lock = MyButton(frame: CGRect(x: screen_x_transform(250), y: screen_y_transform(542), width: screen_x_transform(125), height: screen_y_transform(125)))
        cancel_button_lock.setImage(UIImage(named: "wheel_cancel"), for: .normal)
        self.view.addSubview(cancel_button_lock)
        cancel_button_lock.whenButtonIsClicked(action: {
            if(!self.sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            nextViewController.modalTransitionStyle = .crossDissolve
            self.count_down_timer_during_reward.invalidate()
            self.lock_screen_count_down_timer.invalidate()
            self.present(nextViewController, animated: true, completion: nil)
            
        })
        count_down_label = UILabel(frame: CGRect(x: screen_width/2 - screen_x_transform(120), y: screen_height/2 - screen_y_transform(18), width: screen_x_transform(330), height: screen_y_transform(100)))
        self.view.addSubview(count_down_label)
        count_down_label.text = count_down_time_string
        count_down_label.font = UIFont(name: "Fresca-Regular", size: 63)
        count_down_label.textColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1.0)
        
        
    }
    
    //modify position according to iphone generation functions
    func screen_x_transform(_ x: Double) -> CGFloat {
        let const = x/Double(375)
        let new_x = Double(screen_width)*const
        return CGFloat(new_x)
        
    }
    func screen_y_transform(_ y: Double) -> CGFloat {
        let const = y/Double(667)
        let new_y = Double(screen_height)*const
        return CGFloat(new_y)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    class MyButton: UIButton {
        var action: (()->())?
        
        func whenButtonIsClicked(action: @escaping ()->()) {
            self.action = action
            self.addTarget(self, action: #selector(MyButton.clicked), for: .touchUpInside)
        }
        
        
        func clicked() {
            action?()
        }
    }
    
    
    
    //pan gesture recognizer
    func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer){
        if(!during_spinning){
        if(wheel.frame.contains(spin_initial_point) && !display_reward && count_down_end){
            let velocity = gesture.velocity(in: view)
            //print("velocity x: \(velocity.x), velocity y: \(velocity.y)")
            if(velocity.x != 0 || velocity.y != 0){
                real_velocity = Double(velocity.x*velocity.x + velocity.y*velocity.y)
                real_velocity = sqrt(real_velocity)
                //print("real_velocity is : \(real_velocity)")
            }
            let translation = gesture.translation(in: view)
            let current_position = CGPoint(x: spin_initial_point.x+translation.x, y: spin_initial_point.y+translation.y)
            //record passing area
            //current position in left upper boundary
            if((current_position.x - wheel.frame.origin.x) < wheel.frame.width/2 && current_position.y - wheel.frame.origin.y < wheel.frame.height/2 ){
                if(current_passing_area != 0){
                    current_passing_array_index += 1
                    current_passing_area = 0
                    gesture_passing_area[current_passing_array_index] = 0
                }
            }
                
                //current position in right uper boundary
            else if((current_position.x - wheel.frame.origin.x) > wheel.frame.width/2 && current_position.y - wheel.frame.origin.y < wheel.frame.height/2 ){
                if(current_passing_area != 1){
                    current_passing_array_index += 1
                    current_passing_area = 1
                    gesture_passing_area[current_passing_array_index] = 1
                }
            }
                //current postion in right downer boundary
            else if((current_position.x - wheel.frame.origin.x) > wheel.frame.width/2 && current_position.y - wheel.frame.origin.y > wheel.frame.height/2 ){
                if(current_passing_area != 2){
                    current_passing_array_index += 1
                    current_passing_area = 2
                    gesture_passing_area[current_passing_array_index] = 2
                }
            }
                //current position in left downer
            else if((current_position.x - wheel.frame.origin.x) < wheel.frame.width/2 && current_position.y - wheel.frame.origin.y > wheel.frame.height/2 ){
                if(current_passing_area != 3){
                    current_passing_array_index += 1
                    current_passing_area = 3
                    gesture_passing_area[current_passing_array_index] = 3
                }
            }
            
            final_translation = translation
            if(gesture.state == .ended){
                var i = 0
                while(gesture_passing_area[i] != -1){
                    // print("gesture passing at index \(i) is \(gesture_passing_area[i])")
                    i += 1
                }
                let direction = determine_rotation_direction()
                //print("final translation: x: \(final_translation.x) y: \(final_translation.y)")
                if(direction != -1){
                    rotation_direction = direction
                    count_down_timer_during_reward.invalidate()
                    spin_wheel()
                    //let date = NSDate()
                    //defaults.set(date, forKey: "tritri_wheel_last_access_time_new")
                }
                //print("\(translation.x)")
                //print("\(translation.y)")
            }
            
        }
        }
    }
    
    
    func spin_wheel () -> Void {
        
        do{spinning_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "spin_new", ofType: "mp3")!))
            spinning_player.prepareToPlay()
            
        }
        catch{
        }
        
        during_spinning = true
        var last_duration = 0
        var final_angle = Int(arc4random_uniform(UInt32(360)))
        var final_proportion = Double(final_angle) / Double(360)
        let fullRotation = CGFloat(Double.pi * 2)
        let spin_animation = CAKeyframeAnimation()
        print("final_angle is \(final_angle)")
        CATransaction.begin()
        var spinning_timer = Timer()
        if(!quit_during_spinning){
            spinning_timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DailyGiftViewController.spinning_sound_effect), userInfo: nil, repeats: true)}
        else{
            spinning_timer.invalidate()
        }
        
        CATransaction.setCompletionBlock({
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                CATransaction.begin()
                self.display_reward = true
                
                CATransaction.setCompletionBlock({
                    spinning_timer.invalidate()
                    var category = self.determine_final_case(final_angle: final_angle)
                    self.spin_category = category
                    //print("category is \(category)")
                    if(category == 0){
                        self.ten_points = UIImageView(frame: self.view.frame)
                        self.ten_points.image = #imageLiteral(resourceName: "ten_points")
                        self.view.addSubview(self.ten_points)
                        self.ten_points.alpha = 0
                        self.ten_points.fadeIn()
                        self.star_score += 10
                        self.defaults.set(self.star_score, forKey: "tritri_star_score")
                        
                        
                    }else if(category == 1){
                        self.twenty_five_points = UIImageView(frame: self.view.frame)
                        self.twenty_five_points.image = #imageLiteral(resourceName: "twenty-five_points")
                        self.view.addSubview(self.twenty_five_points)
                        self.twenty_five_points.alpha = 0
                        self.twenty_five_points.fadeIn()
                        self.star_score += 25
                        self.defaults.set(self.star_score, forKey: "tritri_star_score")
                        
                        
                    }else if(category == 2){
                        self.thirty_five_points = UIImageView(frame: self.view.frame)
                        self.thirty_five_points.image = #imageLiteral(resourceName: "thirty-five_points")
                        self.view.addSubview(self.thirty_five_points)
                        self.thirty_five_points.alpha = 0
                        self.thirty_five_points.fadeIn()
                        self.star_score += 35
                        self.defaults.set(self.star_score, forKey: "tritri_star_score")
                    }
                    let date = NSDate()
                    self.defaults.set(date, forKey: "tritri_wheel_last_access_time_new")
                    self.total_seconds = 12*60*60
                    
                    self.during_spinning = false
                    self.rewards_count_down = UILabel(frame: CGRect(x: self.screen_width/2 - self.screen_x_transform(39), y: self.screen_height/2 - self.screen_y_transform(89), width: self.screen_x_transform(330), height: self.screen_y_transform(100)))
                    self.view.addSubview(self.rewards_count_down)
                    self.rewards_count_down.text = self.count_down_time_string
                    self.rewards_count_down.font = UIFont(name: "Fresca-Regular", size: 23)
                    self.rewards_count_down.textColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1.0)
                    self.rewards_count_down.fadeIn()
                    //add notification
                    let dailyGiftNotification = UNMutableNotificationContent()
                    if (self.defaults.value(forKey: "language") as! String == "English"){
                        dailyGiftNotification.title = NSString.localizedUserNotificationString(forKey: "Spin the Wheel", arguments: nil)
                        dailyGiftNotification.body = NSString.localizedUserNotificationString(forKey: "Time for Daily Gift", arguments: nil)
                    }
                    else {
                        dailyGiftNotification.title = NSString.localizedUserNotificationString(forKey: "转动幸运转盘", arguments: nil)
                        dailyGiftNotification.body = NSString.localizedUserNotificationString(forKey: "每日礼物放送时间到！", arguments: nil)
                    }
                    dailyGiftNotification.sound = UNNotificationSound.default()
                    dailyGiftNotification.badge = 1
                    //deliver the notification
                    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 12*60*60, repeats: false)
                    let request = UNNotificationRequest.init(identifier: "DailyGift", content: dailyGiftNotification, trigger: trigger)
                    //schedule notification
                    let center = UNUserNotificationCenter.current()
                    center.add(request){ (error) in
                        if let error = error {
                            print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                        }
                    }
                
                    
                    //
                    
                    self.count_down_timer_during_reward.invalidate()
                    if(!self.quit_during_spinning){
                        self.count_down_timer_during_reward = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(DailyGiftViewController.count_down_during_reward), userInfo: nil, repeats: true)
                        self.count_down_timer_during_reward.fire()
                    }
                    else{
                        self.count_down_timer_during_reward.invalidate()
                    }
                    
                })
                /**if(self.rotation_direction == 0){
                 if(final_angle < 180){
                 UIView.animate(withDuration: 0.75, animations: {
                 self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(final_proportion)*fullRotation)
                 })
                 }else{
                 UIView.animate(withDuration: 0.75, animations: {
                 self.wheel.transform = CGAffineTransform(rotationAngle: 0.5*fullRotation)
                 }, completion: {
                 (finished) -> Void in
                 UIView.animate(withDuration: 0.75, animations: {
                 self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(final_proportion)*fullRotation)
                 
                 })
                 
                 })
                 }
                 
                 }else if(self.rotation_direction == 1){
                 if(final_angle < 180){
                 UIView.animate(withDuration: 0.5, animations: {
                 self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(3/4)*fullRotation)
                 }, completion: {
                 (finished) -> Void in
                 UIView.animate(withDuration: 0.5, animations: {
                 self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(0.5)*fullRotation)
                 }, completion: {
                 (finished) -> Void in
                 UIView.animate(withDuration: 1, animations: {
                 self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(final_proportion)*fullRotation)
                 
                 })
                 
                 })
                 
                 
                 
                 })
                 }else{
                 UIView.animate(withDuration: 2.5, animations: {
                 self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(final_proportion)*fullRotation)
                 })
                 
                 
                 }
                 
                 }**/
                let final_animation = CAKeyframeAnimation()
                final_animation.keyPath = "transform.rotation.z"
                if(self.real_velocity < 1000){
                final_animation.duration = 2
                }else if(self.real_velocity >= 1000 && self.real_velocity < 1500){
                    final_animation.duration = 1.2
                    //wheel.layer.add(spin_animation, forKey: "rotate")
                }else if(self.real_velocity >= 1500){
                    final_animation.duration = 1.1
                    //wheel.layer.add(spin_animation, forKey: "rotate")
                    //spinning_player.rate = Float(spinning_player.duration)/0.4
                }
                final_animation.isRemovedOnCompletion = false
                final_animation.fillMode = kCAFillModeForwards
                final_animation.repeatCount = Float(0)
                if(self.rotation_direction == 0){
                    if(final_angle < 180){
                        final_animation.values = [0, CGFloat(final_proportion)*fullRotation]
                        
                    }else{
                        final_animation.values = [0 , fullRotation/4, fullRotation/2, CGFloat(final_proportion)*fullRotation]
                    }
                }else if(self.rotation_direction == 1){
                    if(final_angle < 180){
                        final_animation.values = [fullRotation, fullRotation*3/4, fullRotation/2, CGFloat(final_proportion)*fullRotation]
                    }else{
                        final_animation.values = [fullRotation, CGFloat(final_proportion)*fullRotation]
                        
                    }
                }
                self.wheel.layer.add(final_animation, forKey: "final_rotate")
                CATransaction.commit()
            })
            //low speed one round
            let slow_spin = CAKeyframeAnimation()
            slow_spin.keyPath = "transform.rotation.z"
            if(self.real_velocity >= 1000 && self.real_velocity < 1500){
            slow_spin.duration = 1
                //wheel.layer.add(spin_animation, forKey: "rotate")
            }else if(self.real_velocity >= 1500){
                slow_spin.duration = 0.9
                //wheel.layer.add(spin_animation, forKey: "rotate")
                //spinning_player.rate = Float(spinning_player.duration)/0.4
            }

            //slow_spin.duration = 1.5
            slow_spin.isRemovedOnCompletion = false
            slow_spin.fillMode = kCAFillModeForwards
            if(self.rotation_direction == 0){
                slow_spin.values = [0, fullRotation/4, fullRotation/2, fullRotation*3/4, fullRotation]
            }else if(self.rotation_direction == 1){
                slow_spin.values = [fullRotation, fullRotation*3/4, fullRotation/2, fullRotation/4, 0]
                
            }
            if(self.real_velocity >= 1000){
            self.wheel.layer.add(slow_spin, forKey: "rotate")
            }
           
            
            
            
            CATransaction.commit()
            
        })
        
        spin_animation.keyPath = "transform.rotation.z"
        
        spin_animation.isRemovedOnCompletion = false
        spin_animation.fillMode = kCAFillModeForwards
        print("rotation direction is \(rotation_direction)")
        if(rotation_direction == 0){
            spin_animation.values = [0,fullRotation/4, fullRotation/2, fullRotation*3/4, fullRotation]
        }else if(rotation_direction == 1){
            spin_animation.values = [fullRotation,fullRotation*3/4, fullRotation/2, fullRotation/4, 0]
            
        }

        if(real_velocity<500){
            final_angle = Int(arc4random_uniform(UInt32(180)))
            while(final_angle%45 == 0){
                final_angle = Int(arc4random_uniform(UInt32(360)))
            }
            final_proportion = Double(final_angle) / Double(360)
            spin_animation.repeatCount = Float(0)
            spin_animation.duration = 1
            spinning_player.rate = Float(spinning_player.duration)/1
        }else if(real_velocity >= 500 && real_velocity < 1000){
            final_angle = Int(arc4random_uniform(UInt32(180))) + 90
            while(final_angle%45 == 0){
                final_angle = Int(arc4random_uniform(UInt32(360)))
            }
            final_proportion = Double(final_angle) / Double(360)
            spin_animation.repeatCount = Float(0)
            spin_animation.duration = 0.9
            spinning_player.rate = Float(spinning_player.duration)/0.8
        }else if(real_velocity >= 1000 && real_velocity < 1500){
            final_angle = Int(arc4random_uniform(UInt32(90)))
            while(final_angle%45 == 0){
                final_angle = Int(arc4random_uniform(UInt32(360)))
            }
            final_proportion = Double(final_angle) / Double(360)
            spin_animation.repeatCount = Float(0)
            spin_animation.duration = 0.8
            wheel.layer.add(spin_animation, forKey: "rotate")
        }else if(real_velocity >= 1500){
            final_angle = Int(arc4random_uniform(UInt32(360)))
            while(final_angle%45 == 0){
                final_angle = Int(arc4random_uniform(UInt32(360)))
            }
            final_proportion = Double(final_angle) / Double(360)
            spin_animation.repeatCount = Float(1)
            spin_animation.duration = 0.7
            wheel.layer.add(spin_animation, forKey: "rotate")
            //spinning_player.rate = Float(spinning_player.duration)/0.4
        }
        print("real velocity is \(real_velocity)")
        last_final_angle = final_angle
        CATransaction.commit()
        
    }
    
    
    
    
    //count_down_during_reward
    func count_down_during_reward() -> Void {
        if(display_reward){
            if(total_seconds > 0){
                
                unlock_player_played_time = 0
                if(clock_sound_effect_should_on){
                    if(!sound_is_muted){
                    do{clock_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "clock_sound", ofType: "mp3")!))
                        clock_player.prepareToPlay()
                        
                    }
                    catch{
                    }
                    clock_player.play()
                    }
                }
                count_down_end = false
                total_seconds = total_seconds - 1
                let hours = total_seconds/(60*60)
                let seconds_times_min = total_seconds%(60*60)
                let min = seconds_times_min/60
                let seconds = seconds_times_min%60
                count_down_time_string = hours_formatter(hours: hours) + " : " + min_formatter(min: min) + " : " + sec_formatter(sec: seconds)
                rewards_count_down.text = count_down_time_string
            }else if(total_seconds == 0){
                
                count_down_timer_during_reward.invalidate()
                
                do{unlock_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "door_open_and_reming", ofType: "mp3")!))
                    unlock_player.prepareToPlay()
                    
                }
                catch{
                }
                if(unlock_sound_effect_should_on){
                    if(!sound_is_muted){
                    unlock_player.play()
                    }
                }
                
                unlock_player_played_time = unlock_player_played_time + 1
                
                display_reward = false
                if(spin_category == 0){
                    ten_points.fadeOutandRemove()
                }else if(spin_category == 1){
                    twenty_five_points.fadeOutandRemove()
                }else if(spin_category == 2 ){
                    thirty_five_points.fadeOutandRemove()
                }
                rewards_count_down.fadeOutandRemove()
                //reset animation
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.count_down_end = true
                })
                let reset_animation = CAKeyframeAnimation()
                reset_animation.keyPath = "transform.rotation.z"
                reset_animation.isRemovedOnCompletion = false
                reset_animation.fillMode = kCAFillModeForwards
                reset_animation.repeatCount = Float(1)
                reset_animation.duration = 1.5
                print("last final angle is \(last_final_angle)")
                let fullRotation = CGFloat(2*Double.pi)
                let final_proportion = Double(last_final_angle)/Double(360)
                if(final_proportion >= 0.5){
                    reset_animation.values = [CGFloat(final_proportion)*fullRotation, fullRotation]
     
                }else{
                    reset_animation.values = [CGFloat(final_proportion)*fullRotation, 0]
                }
                wheel.layer.add(reset_animation, forKey: "rotate")
                CATransaction.commit()
                
                
               
            }
            
            
            
        }
    }
    
    //spinning sound effect
    func spinning_sound_effect() -> Void {
        if(!display_reward){
            if(spin_sound_effect_should_on){
                if(!sound_is_muted){
                spinning_player.play()
                }
            }
            if(spinning_player.currentTime == spinning_player.duration){
                spinning_player.currentTime = 0
                if(spin_sound_effect_should_on){
                    if(!sound_is_muted){
                    spinning_player.play()
                    }
                }
            }
        }else{
            spinning_player.stop()
        }
    }
    
    
    
    
    
    //function to determine spinning direction (need more implementation)
    func determine_rotation_direction() -> Int{
        let wheel_center = CGPoint(x: (wheel.frame.origin.x + wheel.frame.width/2), y: (wheel.frame.origin.y + wheel.frame.height/2))
        let final_position = CGPoint(x: spin_initial_point.x+final_translation.x, y: spin_initial_point.y+final_translation.y)
        //print("inital point: x: \(spin_initial_point.x) y: \(spin_initial_point.y)")
        //print("final point: x: \(final_position.x) y: \(final_position.y)")
        
        var valid_length = 0
        var i = 0
        //get valid length first
        while(gesture_passing_area[i] != -1 && valid_length != gesture_passing_area.count){
            //clockwise find the pattern of 0 -> 1 -> 2 -> 3 -> 4
            i += 1
            valid_length += 1
        }
        
        
        //left upper area
        if((spin_initial_point.x - wheel.frame.origin.x) < wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y < wheel.frame.height/2 ){
            let angle_init = atan((spin_initial_point.y - wheel_center.y)/(spin_initial_point.x - wheel_center.x))
            let angle_final = atan((final_position.y - wheel.center.y)/(final_position.x - wheel_center.x))
            let degree_angle_init = Double(angle_init)*180/Double.pi
            let degree_angle_final = Double(angle_final)*180/Double.pi
            //print("init angle : \(degree_angle_init)  final angle: \(degree_angle_final)")
            //final_position in left upper boundary (same area)
            /** if((final_position.x - wheel.frame.origin.x) < wheel.frame.width/2 && final_position.y - wheel.frame.origin.y < wheel.frame.height/2 ){
             if(degree_angle_init > degree_angle_final){
             return 1
             }else if(degree_angle_init < degree_angle_final){
             return 0
             }else{
             return -1
             }
             }
             **/
            //use the last two area to get the direction
            //only one area
            if(valid_length == 1){
                if(degree_angle_init > degree_angle_final){
                    return 1
                }else if(degree_angle_init < degree_angle_final){
                    return 0
                }else{
                    return -1
                }
                
            }
                //two areas
            else if(valid_length == 2){
                if(gesture_passing_area[1] == 1){
                    return 0
                }else if(gesture_passing_area[1] == 3){
                    return 1
                }
            }else{
                let second_last_area = gesture_passing_area[valid_length-2]
                let last_area = gesture_passing_area[valid_length-1]
                if(last_area == second_last_area+1 || last_area == second_last_area - 3){
                    return 0
                }else if(last_area == second_last_area-1 || last_area == second_last_area + 3){
                    return 1
                }
            }
            
            
            
            
            
            /**final position in right_upper boundary
             else if((final_position.x - wheel.frame.origin.x) > wheel.frame.width/2 && final_position.y - wheel.frame.origin.y < wheel.frame.height/2 ){
             return 0
             }
             //final postion in right downer boundary
             else if((final_position.x - wheel.frame.origin.x) > wheel.frame.width/2 && final_position.y - wheel.frame.origin.y > wheel.frame.height/2 ){
             if(degree_angle_init > degree_angle_final){
             return 0
             }else if(degree_angle_init < degree_angle_final){
             return 1
             }else{
             return -1
             }
             }
             //final position in left downer
             else if((final_position.x - wheel.frame.origin.x) < wheel.frame.width/2 && final_position.y - wheel.frame.origin.y > wheel.frame.height/2 ){
             return 1
             
             
             
             }
             **/
            
        }//right upper area
        else if((spin_initial_point.x - wheel.frame.origin.x) > wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y < wheel.frame.height/2 ){
            let angle_init = atan((spin_initial_point.y - wheel_center.y)/(spin_initial_point.x - wheel_center.x))
            let angle_final = atan((final_position.y - wheel.center.y)/(final_position.x - wheel_center.x))
            let degree_angle_init = Double(angle_init)*180/Double.pi
            let degree_angle_final = Double(angle_final)*180/Double.pi
            print("init angle : \(degree_angle_init)  final angle: \(degree_angle_final)")
            //use the last two area to get the direction
            //only one area
            if(valid_length == 1){
                if(degree_angle_init > degree_angle_final){
                    return 1
                }else if(degree_angle_init < degree_angle_final){
                    return 0
                }else{
                    return -1
                }
                
            }
                //more areas
            else {
                let second_last_area = gesture_passing_area[valid_length-2]
                let last_area = gesture_passing_area[valid_length-1]
                if(last_area == second_last_area+1 || last_area == second_last_area - 3){
                    return 0
                }else if(last_area == second_last_area-1 || last_area == second_last_area + 3){
                    return 1
                }
            }
            
            
            
            
            
            
            
            
            
            
            
        }
            
            //right downer area
        else if((spin_initial_point.x - wheel.frame.origin.x) > wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y > wheel.frame.height/2 ){
            let angle_init = atan((spin_initial_point.y - wheel_center.y)/(spin_initial_point.x - wheel_center.x))
            let angle_final = atan((final_position.y - wheel.center.y)/(final_position.x - wheel_center.x))
            let degree_angle_init = Double(angle_init)*180/Double.pi
            let degree_angle_final = Double(angle_final)*180/Double.pi
            print("init angle : \(degree_angle_init)  final angle: \(degree_angle_final)")
            //use the last two area to get the direction
            //only one area
            if(valid_length == 1){
                if(degree_angle_init > degree_angle_final){
                    return 1
                }else if(degree_angle_init < degree_angle_final){
                    return 0
                }else{
                    return -1
                }
                
            }
                //more areas
            else {
                let second_last_area = gesture_passing_area[valid_length-2]
                let last_area = gesture_passing_area[valid_length-1]
                if(last_area == second_last_area+1 || last_area == second_last_area - 3){
                    return 0
                }else if(last_area == second_last_area-1 || last_area == second_last_area + 3){
                    return 1
                }
            }
            
            
            
        }
            //left downer area
        else if((spin_initial_point.x - wheel.frame.origin.x) < wheel.frame.width/2 && spin_initial_point.y - wheel.frame.origin.y > wheel.frame.height/2 ){
            let angle_init = atan((spin_initial_point.y - wheel_center.y)/(spin_initial_point.x - wheel_center.x))
            let angle_final = atan((final_position.y - wheel.center.y)/(final_position.x - wheel_center.x))
            let degree_angle_init = Double(angle_init)*180/Double.pi
            let degree_angle_final = Double(angle_final)*180/Double.pi
            print("init angle : \(degree_angle_init)  final angle: \(degree_angle_final)")
            //use the last two area to get the direction
            //only one area
            if(valid_length == 1){
                print("same area")
                if(degree_angle_init > degree_angle_final){
                    return 1
                }else if(degree_angle_init < degree_angle_final){
                    return 0
                }else{
                    return -1
                }
                
            }
                //more areas
            else {
                let second_last_area = gesture_passing_area[valid_length-2]
                let last_area = gesture_passing_area[valid_length-1]
                if(last_area == second_last_area+1 || last_area == second_last_area - 3){
                    return 0
                }else if(last_area == second_last_area-1 || last_area == second_last_area + 3){
                    return 1
                }
            }
        }
        
        return 1
    }
    
    //determine case:
    //case 0 : +10
    //case 1 : +25
    //case 2 : +35
    //case -1 : none
    func determine_final_case(final_angle : Int) -> Int{
        if(final_angle > 0 && final_angle < 45 ){
            return 2
        }else if(final_angle > 45 && final_angle < 90){
            return 0
        }else if(final_angle > 90 && final_angle < 135){
            return 1
        }else if(final_angle > 135 && final_angle < 180){
            return 0
        }else if(final_angle > 180 && final_angle < 225 ){
            return 2
        }else if(final_angle > 225 && final_angle < 270){
            return 0
        }else if(final_angle > 270 && final_angle < 315){
            return 1
        }else if(final_angle > 315 && final_angle < 360){
            return 0
        }else{
            return -1
        }
    }
    
    
    
    func auto_count_down() -> Void{
        if(total_seconds > 0){
            unlock_player_played_time = 0
            if(clock_sound_effect_should_on){
                if(!sound_is_muted){
                do{clock_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "clock_sound", ofType: "mp3")!))
                    clock_player.prepareToPlay()
                    
                }
                catch{
                }
                clock_player.play()
                }
            }
            count_down_end = false
            total_seconds = total_seconds - 1
            let hours = total_seconds/(60*60)
            let seconds_times_min = total_seconds%(60*60)
            let min = seconds_times_min/60
            let seconds = seconds_times_min%60
            count_down_time_string = hours_formatter(hours: hours) + " : " + min_formatter(min: min) + " : " + sec_formatter(sec: seconds)
            count_down_label.text = count_down_time_string
        }else if(total_seconds == 0){
            if(unlock_player_played_time == 0){
                do{unlock_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "door_open_and_reming", ofType: "mp3")!))
                    unlock_player.prepareToPlay()
                    
                }
                catch{
                }
                if(unlock_sound_effect_should_on){
                    if(!sound_is_muted){
                    unlock_player.play()
                    }
                }
                unlock_player_played_time = unlock_player_played_time + 1
            }
            
            count_down_end = true
            lock_screen.fadeOutandRemove()
            count_down_label.fadeOutandRemove()
            grey_transparent_image.fadeOutandRemove()
            cancel_button_lock.fadeOutandRemove()}
        
    }
    
    
    
    
    func real_time_handler() -> Void{
        var current_date = NSDate()
        var previous_date = NSDate()
        let calendar = NSCalendar.current
        var passed_seconds = 0
        if(defaults.value(forKey: "tritri_wheel_last_access_time_new") != nil ){
            previous_date = defaults.value(forKey: "tritri_wheel_last_access_time_new") as! NSDate!
            let elapsed = Date().timeIntervalSince(previous_date as Date)
            passed_seconds = Int(elapsed)
            print("passed_seconds: \(elapsed)")
            if(passed_seconds < 43200){
                count_down_end = false
                total_seconds = 43200 - passed_seconds
            }else{
                total_seconds = 0
                count_down_end = true
            }
        }else{
            count_down_end = true
            total_seconds = 0
            
        }
        
    }
    
    
    func hours_formatter(hours: Int) -> String {
        if(hours < 10){
            var formatted_hours = String()
            formatted_hours = String(0)+String(hours)
            return formatted_hours}
        else{
            return String(hours)
        }
    }
    
    func min_formatter(min: Int) -> String {
        if(min<10){
            var formatted_min = String()
            formatted_min = String(0) + String(min)
            return formatted_min
        }else{
            return String(min)
        }
    }
    
    func sec_formatter(sec: Int) -> String {
        if(sec<10){
            var formatted_sec = String()
            formatted_sec = String(0) + String(sec)
            return formatted_sec
        }else{
            return String(sec)
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


public extension UIView {
    func fadeInTrans(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.5
        })
    }
    
    func fadeOutandRemove(withDuration duration: TimeInterval = 0.5){
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: {
            (finished) -> Void in
            self.removeFromSuperview()
        })
    }
}

