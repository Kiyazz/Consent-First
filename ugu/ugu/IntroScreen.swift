//
//  ViewController.swift
//  ugu
//
//  Created by Darius Kashani on 9/5/21.
//

import UIKit



class IntroScreen: UIViewController {
    
    @IBOutlet weak var backGround: UIImageView!
    static var programEntered:Bool = false;
    
    @IBSegueAction func loadNewScreen(_ coder: NSCoder, sender: Any?) -> mainScreen? {
        let mc = mainScreen(coder:  coder);
        mc?.modalTransitionStyle = .crossDissolve;
        mc?.modalPresentationStyle = .fullScreen;
        return mc;
    }
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButton(_ sender: UIButton) {
        startButton.isEnabled = false;
        startButton.isHidden = true;
        startButton.isUserInteractionEnabled = false;
        
        IntroScreen.programEntered = true;
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.backgroundColor = UIColor.red;
        startButton.setTitle("", for: UIControl.State.normal);
        startButton.isHidden = false;
        startButton.isEnabled = true;
        
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    
    
    
    
    
    
    


}

