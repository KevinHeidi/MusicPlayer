//
//  Channel.swift
//  MusicPlayer
//
//  Created by LUOKEFENG on 9/6/2015.
//  Copyright (c) 2015年 LUOKEFENG. All rights reserved.
//

import UIKit

class Channel: NSObject {
    var id:NSString!
    var title:NSString!
    var cate_id:NSString!
    var cate:NSString!
    
    init(dict:NSDictionary){
        super.init()
        
        self.id = dict["id"] as! NSString
        self.title = dict["title"] as! NSString
        self.cate_id = dict["cate_id"] as! NSString
        self.cate = dict["cate"] as! NSString
    }
}
