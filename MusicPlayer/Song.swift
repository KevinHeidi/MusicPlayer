
//
//  Song.swift
//  MusicPlayer
//
//  Created by LUOKEFENG on 9/6/2015.
//  Copyright (c) 2015年 LUOKEFENG. All rights reserved.
//

import UIKit

class Song: NSObject,NSCoding {
    var id:Int!
    var songName:NSString!
    var artistName:NSString!
    var albumName:NSString!
    var songPicSmall:NSString!
    var songPicBig:NSString!
    var songPicRadio:NSString!
    var lrcLink:NSString!
    var songLink:NSString!
    var showLink:NSString!
    
     override init(){
    
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeInteger(self.id, forKey: "id")
        aCoder.encodeObject(self.songName, forKey: "songName")
        //....
    }
    required init(coder aDecoder: NSCoder) // NS_DESIGNATED_INITIALIZER
    {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.songName = aDecoder.decodeObjectForKey("songName") as! NSString
        //....
    }
    
    
    func refreshSong(dict:NSDictionary){
        self.songName = dict["songName"] as! NSString
        self.artistName = dict["artistName"] as! NSString
        self.albumName = dict["albumName"] as! NSString
        self.songPicSmall = dict["songPicSmall"] as! NSString
        self.songPicBig = dict["songPicBig"] as! NSString
        self.lrcLink = dict["lrcLink"] as! NSString
        self.songLink = dict["songLink"] as! NSString
        self.showLink = dict["showLink"] as! NSString
    }
}
