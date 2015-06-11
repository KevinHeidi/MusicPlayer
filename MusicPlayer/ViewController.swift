//
//  ViewController.swift
//  MusicPlayer
//
//  Created by LUOKEFENG on 9/6/2015.
//  Copyright (c) 2015年 LUOKEFENG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var promptLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設置主界面背景
        var rect:CGRect = self.view.bounds
        var imageView:UIImageView = UIImageView(frame: rect)
        
        let image = UIImage(named: "MusicBG")
        imageView.image = image
        self.view.addSubview(imageView)
        //將imageView設置到最底層
        self.view.sendSubviewToBack(imageView)
        //self.view.bringSubviewToFront(promptLabel)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

