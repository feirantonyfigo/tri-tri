//
//  TutorialViewController.swift
//  tri-tri
//
//  Created by mac on 2017-07-03.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
    
    }
    
   var sound_is_muted = false
    
    @IBOutlet weak var about_us_button: UIButton!
    var language = String()
    
    var button_player = AVAudioPlayer()
    
    let tuto_text = UIImageView()
    let tuto_case_1 = UIImageView()
    let tuto_case_2 = UIImageView()
    let tuto_case_3 = UIImageView()
    let tuto_case_4 = UIImageView()
    let tuto_reward = UIImageView()

    
    var pageCount = Int()
    
    func pause_screen_x_transform(_ x: Double) -> CGFloat {
        let const = x/Double(375)
        let new_x = Double(view.frame.width)*const
        print(view.frame.width)
        print(new_x)
        return CGFloat(new_x)
        
    }
    func pause_screen_y_transform(_ y: Double) -> CGFloat {
        let const = y/Double(667)
        let new_y = Double(view.frame.height)*const
        print(view.frame.height)
        print(new_y)
        return CGFloat(new_y)
    }
    
    @IBOutlet var exit_button: UIButton!
    @IBAction func exit(_ sender: Any) {
        if(!sound_is_muted){
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
        self.present(nextViewController, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet var tuto_page_con: UIPageControl!
    
    @IBOutlet var tuto_bg: UIImageView!
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        language = defaults.value(forKey: "language") as! String
        
        mainScrollView.delegate = self
        
        
        
        
        exit_button.setTitle("", for: .normal)
        exit_button.setBackgroundImage(UIImage(named:"tuto_exit"), for: .normal)
        exit_button.frame = CGRect(x:0, y: pause_screen_y_transform(537), width: pause_screen_x_transform(130), height: pause_screen_y_transform(130))
        tuto_page_con.frame = CGRect(x:pause_screen_x_transform(Double(tuto_page_con.frame.origin.x)), y: pause_screen_y_transform(Double(tuto_page_con.frame.origin.y)), width: pause_screen_x_transform(Double(tuto_page_con.frame.width)), height: pause_screen_y_transform(Double(tuto_page_con.frame.height)))
        self.view.bringSubview(toFront: exit_button)
        tuto_page_con.isUserInteractionEnabled = false
        about_us_button.frame = CGRect(x:pause_screen_x_transform(Double(about_us_button.frame.origin.x)), y: pause_screen_y_transform(Double(about_us_button.frame.origin.y)), width: pause_screen_x_transform(Double(about_us_button.frame.width)), height: pause_screen_y_transform(Double(about_us_button.frame.height)))
        
        if (defaults.value(forKey: "tri_tri_sound_is_muted") == nil){
            sound_is_muted = false
            defaults.set(sound_is_muted, forKey: "tri_tri_sound_is_muted")
        }
        else {
            sound_is_muted = defaults.value(forKey: "tri_tri_sound_is_muted") as! Bool
        }
        

        self.view.bringSubview(toFront: tuto_page_con)
        self.mainScrollView.frame = self.view.frame
        tuto_bg.frame = self.view.frame
        tuto_bg.contentMode = .scaleAspectFill
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tuto_bg")!)
        if (language == "English"){
            tuto_text.image = UIImage(named:"tuto_text")
            current_about_us_image = #imageLiteral(resourceName: "about_us_english")
            about_us_text.image = #imageLiteral(resourceName: "about_us_text_english")
            
        } else {
            tuto_text.image = UIImage(named:"tuto_text_chinese")
            current_about_us_image = #imageLiteral(resourceName: "about_us_chinese")
            about_us_text.image = #imageLiteral(resourceName: "about_us_text_chinese")
        }
        about_us_button.setImage(current_about_us_image, for: .normal)
        tuto_text.frame = CGRect(x:0, y:0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
        
        
        tuto_case_1.image = UIImage(named:"tuto_case_1")
        tuto_case_1.frame = CGRect(x:0, y:0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
        
        
        tuto_case_2.image = UIImage(named:"tuto_case_2")
        tuto_case_2.frame = CGRect(x:mainScrollView.frame.width, y:0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
        
        tuto_case_3.image = UIImage(named:"tuto_case_3")
        tuto_case_3.frame = CGRect(x:2*mainScrollView.frame.width, y:0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
        
        
        tuto_case_4.image = UIImage(named:"tuto_case_4")
        tuto_case_4.frame = CGRect(x:3*mainScrollView.frame.width, y:0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
        
        
                tuto_reward.frame = CGRect(x:4*mainScrollView.frame.width, y:0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
        
        
        if (language == "English"){
            tuto_reward.image = #imageLiteral(resourceName: "tuto_reward")
    
        }else
        {
            tuto_reward.image = #imageLiteral(resourceName: "tuto_reward_chinese")
        }
      
        tuto_text.isUserInteractionEnabled = true
        tuto_case_1.isUserInteractionEnabled = true
        tuto_case_2.isUserInteractionEnabled = true
        tuto_case_3.isUserInteractionEnabled = true
        tuto_case_4.isUserInteractionEnabled = true
        tuto_reward.isUserInteractionEnabled = true
        tuto_bg.isUserInteractionEnabled = true
        mainScrollView.isUserInteractionEnabled = true
        mainScrollView.contentSize.width = mainScrollView.frame.width * 5
        mainScrollView.addSubview(tuto_case_1)
        mainScrollView.addSubview(tuto_case_2)
        mainScrollView.addSubview(tuto_case_3)
        mainScrollView.addSubview(tuto_case_4)
        mainScrollView.addSubview(tuto_reward)
        mainScrollView.addSubview(tuto_text)
        
        pageCount = 0
        // Do any additional setup after loading the view.
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        mainScrollView.addGestureRecognizer(scrollViewTap)
        
        
    }
   
    func scrollViewTapped(_ gesture: UITapGestureRecognizer ) {
    let location = gesture.location(in: mainScrollView)
        if(about_page_open && !in_about_us_animation){
            
            if(!about_us_back2.frame.contains(location)){
            close_about_us()
        }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      let  location = scrollView.panGestureRecognizer.location(in: mainScrollView)
        if(about_page_open && !in_about_us_animation){
            
            if(!about_us_back2.frame.contains(location)){
                close_about_us()
            }
        }   
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer){
        
    }
    
    func swipeGestureRecognizerAction(_ gesture: UISwipeGestureRecognizer){
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        tuto_page_con.currentPage = Int(pageIndex)
        print(tuto_page_con.currentPage)
        if (scrollView.contentOffset.x <= 3 * view.frame.width){
            tuto_text.frame = CGRect(x:scrollView.contentOffset.x, y:0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
        }
        
        
        
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
    
    var about_page_open = false
    var in_about_us_animation = false
    var current_about_us_image = UIImage()
    var about_us_back0 = UIImageView()
    var about_us_back1 = UIImageView()
    var about_us_back2 = UIImageView()
    var about_us_text = UIImageView()
    @IBAction func about_us_action(_ sender: UIButton) {
        if(!about_page_open && !in_about_us_animation){
            if(!sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
        open_about_us()
        
        
        }else if(about_page_open && !in_about_us_animation){
            if(!sound_is_muted){
            do{self.button_player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "general_button", ofType: "wav")!))
                self.button_player.prepareToPlay()
            }
            catch{
                
            }
            self.button_player.play()
            }
        close_about_us()
            
        }
    }

    func open_about_us(){
        about_page_open = true
        in_about_us_animation = true
        about_us_button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.3, delay: 00, usingSpringWithDamping: 0.5, initialSpringVelocity: 4.0, options: .curveLinear, animations: {
            self.about_us_button.transform = CGAffineTransform(translationX: 1, y: 1).rotated(by: CGFloat(Double.pi))
        }, completion: {
            (finished) -> Void in
            //set backs
            self.about_us_back0.frame = self.about_us_button.frame
            self.about_us_back1.frame = self.about_us_button.frame
            self.about_us_back2.frame = self.about_us_button.frame
            /**
             self.about_us_back0.frame = CGRect(x: self.about_us_button.frame.origin.x - self.pause_screen_x_transform(200), y: self.about_us_button.frame.origin.y - self.pause_screen_y_transform(190), width: self.pause_screen_x_transform(380), height: self.pause_screen_y_transform(380))
             self.about_us_back1.frame = CGRect(x: self.about_us_button.frame.origin.x - self.pause_screen_x_transform(220), y: self.about_us_button.frame.origin.y - self.pause_screen_y_transform(210), width: self.pause_screen_x_transform(420), height: self.pause_screen_y_transform(420))
             self.about_us_back2.frame = CGRect(x: self.about_us_button.frame.origin.x - self.pause_screen_x_transform(240), y: self.about_us_button.frame.origin.y - self.pause_screen_y_transform(230), width: self.pause_screen_x_transform(460), height: self.pause_screen_y_transform(460))
             **/
            self.about_us_back0.image = #imageLiteral(resourceName: " white_circle")
            self.about_us_back1.image = #imageLiteral(resourceName: " white_circle")
            self.about_us_back2.image = #imageLiteral(resourceName: " white_circle")
            self.about_us_back0.contentMode = .scaleAspectFit
            self.about_us_back1.contentMode = .scaleAspectFit
            self.about_us_back2.contentMode = .scaleAspectFit
            self.about_us_back0.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            self.about_us_back1.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            self.about_us_back2.transform =  CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            self.about_us_back0.alpha = 1.0
            self.about_us_back1.alpha = 0.57
            self.about_us_back2.alpha = 0.35
            self.view.addSubview(self.about_us_back0)
            self.view.addSubview(self.about_us_back1)
            self.view.addSubview(self.about_us_back2)
            self.view.addSubview(self.about_us_text)
            self.view.bringSubview(toFront: self.about_us_button)
            
            //self.about_us_back0.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/3.0))
            self.about_us_text.contentMode = .scaleAspectFit
            self.about_us_text.frame = CGRect(x: self.about_us_button.frame.origin.x - self.pause_screen_x_transform(220), y: self.about_us_button.frame.origin.y - self.pause_screen_y_transform(203), width: self.pause_screen_x_transform(292), height: self.pause_screen_y_transform(292))
            self.about_us_text.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.about_us_back0.frame = CGRect(x: self.about_us_button.frame.origin.x - self.pause_screen_x_transform(180), y: self.about_us_button.frame.origin.y - self.pause_screen_y_transform(170), width: self.pause_screen_x_transform(380), height: self.pause_screen_y_transform(380))
                self.about_us_back1.frame = CGRect(x: self.about_us_button.frame.origin.x - self.pause_screen_x_transform(200), y: self.about_us_button.frame.origin.y - self.pause_screen_y_transform(190), width: self.pause_screen_x_transform(420), height: self.pause_screen_y_transform(420))
                self.about_us_back2.frame = CGRect(x: self.about_us_button.frame.origin.x - self.pause_screen_x_transform(220), y: self.about_us_button.frame.origin.y - self.pause_screen_y_transform(210), width: self.pause_screen_x_transform(460), height: self.pause_screen_y_transform(460))
                self.about_us_text.fadeIn()
            })
            
            
            
            UIView.transition(with: self.about_us_button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.about_us_button.setImage(#imageLiteral(resourceName: "about_us_cancel"), for: .normal)
            }, completion: {
                (finished) -> Void in
                self.view.bringSubview(toFront: self.about_us_button)
                self.in_about_us_animation = false
            })
    })
    
}
    
    func close_about_us() {
        about_page_open = false
        in_about_us_animation = true
        about_us_button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.3, delay: 00, usingSpringWithDamping: 0.5, initialSpringVelocity: 4.0, options: .curveLinear, animations: {
            self.about_us_button.transform = CGAffineTransform(translationX: 1, y: 1).rotated(by: CGFloat(Double.pi))
        }, completion: {
            (finished) -> Void in
            self.about_us_button.transform = .identity
            UIView.transition(with: self.about_us_button, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.about_us_button.setImage(self.current_about_us_image, for: .normal)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.about_us_back0.frame = self.about_us_button.frame
                self.about_us_back1.frame = self.about_us_button.frame
                self.about_us_back2.frame = self.about_us_button.frame
                self.about_us_text.fadeOutandRemove()
            }, completion: {
                (finished) -> Void in
                self.about_us_back0.removeFromSuperview()
                self.about_us_back1.removeFromSuperview()
                self.about_us_back2.removeFromSuperview()
                
                self.in_about_us_animation = false
            })
            
            
        })
    }
    

    
    
    
}


