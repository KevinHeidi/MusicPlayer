//
//  OnlineViewController.swift
//  MusicPlayer
//
//  Created by LUOKEFENG on 9/6/2015.
//  Copyright (c) 2015年 LUOKEFENG. All rights reserved.
//

import UIKit
import AVFoundation

class OnlineViewController: UIViewController,AVAudioPlayerDelegate {
    //網絡頻道數據存儲類
    var channel:Channel!
    //歌曲列表存儲數組
    var songList:Array<Song> = []
    //當前播放歌曲數據類
    var currentSong:Song!
    //播放器
    var player:AVAudioPlayer!
    //Slider數字更變定時器
    var timer = NSTimer()
    //當前播放歌曲在歌曲列表的Index
    var currentIndex:Int!
    
    //控件定義
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var playTimer: UILabel!
    @IBOutlet weak var playSlider: UISlider!
    
    //收藏執行函數
    @IBAction func didFavClicked(sender: AnyObject) {
        var song = self.currentSong
        //將對象存檔於文件
        NSKeyedArchiver.archiveRootObject(song, toFile: "/Users/KevinLaw/Desktop/test.plist")
        //測試存檔是否成功
        var song2:Song = NSKeyedUnarchiver.unarchiveObjectWithFile("/Users/KevinLaw/Desktop/test.plist") as! Song
        //println("\(song2)")
    }
    
    //Slider拉動進度條播放歌曲
    @IBAction func valueChanged(sender: UISlider) {
        player.currentTime = NSTimeInterval(sender.value) * player.duration
    }

    //根據Index去設置播放的歌曲
    func loadSongWithIndex(index:Int)
    {
        if index < self.songList.count && index >= 0{
            currentSong = self.songList[index]
            self.currentIndex = index
            player.stop()
            self.loadSongInfo(currentSong.id)
        }
    }
    
    //前一首歌執行函數
    @IBAction func prevSong(sender: UIButton) {
        var index = currentIndex - 1
        loadSongWithIndex(index)
    }

    //播放暫停執行函數
    @IBAction func playingSong(sender: UIButton) {
    }
    
    //下一首歌執行函數
    @IBAction func nextSong(sender: UIButton) {
        var index = currentIndex + 1
        loadSongWithIndex(index)
    }
    
    func printCurrentTime(){
        var time = NSDate()
        println("Current Time is : \(time)")
    }
    //進入播放歌曲介面的時候更新介面信息
    func showSongInfo(){
        //必須對String值進行解包
        self.songLabel.text! = (self.currentSong.songName as? String)!
        self.singerLabel.text! = (self.currentSong.artistName as? String)!
        //println(" show iiiiiiiii\(self.singerLabel.text! )")
    }
    
    func downloadData(path:String,dataHandler:(NSData) -> Void){
        var url = NSURL(string: path)
        var request = NSURLRequest(URL: url!) //Mutable
        //println("\(url)")
        //獲取主隊列
        var mainQueue = NSOperationQueue()
        //執行異步操作
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler:{
            (response:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
            var httpStatusCode = response as! NSHTTPURLResponse
            //判斷HTTP返回Code
            if httpStatusCode.statusCode == 200 {
               dataHandler(data!)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rect:CGRect = self.view.bounds
        var imageView:UIImageView = UIImageView(frame: rect)
        
        let image = UIImage(named: "MusicBG")
        imageView.image = image
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
       // println("Running Online View Controller")
        //加載歌曲列表
        self.printCurrentTime()
        loadSongList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //執行播放操作
    func playSong(data:NSData){
        self.printCurrentTime()
        player = AVAudioPlayer(data:data, error: nil)
        player.prepareToPlay()
        player.play()
        //實現調用AVFoundation類函數停止播放時 optional func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool)
        player.delegate = self
        
        //timer = NSTimer(timeInterval: 0.01, target: self, selector: "refreshSlider", userInfo: nil, repeats: true)
        //增加定時器去更新Slider的顯示
        self.printCurrentTime()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,target:self,selector:"refreshSlider:",userInfo:nil,repeats:true)
        println("Timer = \(self.timer)")
        
        var runLoop = NSRunLoop.currentRunLoop()
        runLoop.addTimer(self.timer, forMode: NSDefaultRunLoopMode)
        //runLoop.addTimer(self.timer, forMode: UITrackingRunLoopMode)
        runLoop.run()
        
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,target:self,selector:"refreshSlider:",userInfo:nil,repeats:true)
            var runLoop = NSRunLoop.currentRunLoop()
            runLoop.addTimer(self.timer, forMode: NSDefaultRunLoopMode)
            //runLoop.addTimer(self.timer, forMode: UITrackingRunLoopMode)
            runLoop.run()
        })*/
        
        self.timer.fire()
    }
    
    func changeSecondsToMinutes(time:Float) ->String{
        var mins = Int(time) / 60
        var secs = Int(time) % 60
        var mins_ex = String(mins) + ":" + String(secs)
        return mins_ex
    }
    
    //更新Slider函數
    func refreshSlider(timer:NSTimer){
        println("Current Play Time :\(player.currentTime)")
        println("Play Duration : \(player.duration)")
        playSlider.value = Float(player.currentTime) / Float(player.duration)  //CGFloat(player.currentTime / player.duration)
        self.playTimer.text = changeSecondsToMinutes(Float(player.currentTime)) + "/" + changeSecondsToMinutes(Float(player.duration))
    }
    
    //當一首歌播放完畢時執行函數
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        //當一首歌停止播放時，將timer停掉
        println("\nFinish Playing  Music ...\n")
        timer.invalidate()
        
        var index = currentIndex + 1
        loadSongWithIndex(index)
    }
    
    //下載歌曲圖片並顯示
    func downloadPic(path:String){
        downloadData(path,dataHandler:{
            (data:NSData) -> Void in
            println("Start Downloading Pic")
            var image = UIImage(data: data)
            self.songImageView.image = image
        })
    }
    
    //執行歌曲下載操作
    func downloadSong(path:String){
        downloadData(path,dataHandler:{
            (data:NSData) -> Void in
            println("Start Downloading Song")
            self.printCurrentTime()
            self.playSong(data)
        })
    }
    
    //根據歌曲id獲取歌曲信息
    func loadSongInfo(id:Int){
        //根據ID去獲取歌曲列表
        var path:String = "http://music.baidu.com/data/music/fmlink?type=mp3&rate=1&format=json&songIds=\(id)"
        
        downloadData(path,dataHandler:{
            (data:NSData) -> Void in
            //將獲取到的數據執行Json序列化，然後賦值給一個字典
            var dict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            //將字典結構中的data賦值給另外一個字典
            var dataDict:NSDictionary = dict["data"] as! NSDictionary
            //將SongList轉換成數組
            var list:NSArray = dataDict["songList"] as! NSArray
            //獲取列表中第一首歌進行下載
            var songDict:NSDictionary = list[0] as! NSDictionary
            //self.currentSong.songName = songDict[""] as! NSString
            //更新song存儲結構
            self.currentSong.refreshSong(songDict)
           // println("\(self.currentSong.artistName)")
            //顯示歌曲信息
            self.showSongInfo()
            self.printCurrentTime()
            self.downloadPic(self.currentSong.songPicBig as String)
            self.printCurrentTime()
            //開始下載歌曲
            self.downloadSong(self.currentSong.songLink as String)
            self.printCurrentTime()
        })
    }
    //下載歌曲列表
    func loadSongList(){
        var path:String = "http://fm.baidu.com/dev/api/?tn=playlist&special=flash&prepend=&format=json&_=1378945264366&id=" + String(channel.id)
        
        downloadData(path,dataHandler:{
            (data:NSData) -> Void in
            var str = NSString(data: data, encoding: NSUTF8StringEncoding)
            // println("\(str)")
            var dict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            //println("\(dict)")
            
            var list:NSArray = dict["list"] as! NSArray
            //println("\(list)")
            //遍歷List，將song id進行存儲。
            for d:AnyObject in list {
                var song = Song()
                song.id = d["id"] as! Int
                self.songList.append(song)
            }
            //如果歌曲列表的歌曲數目不為0，則開始下載第一首歌。。
            if self.songList.count != 0 {
                self.currentSong = self.songList[0]
                self.printCurrentTime()
                self.loadSongInfo(self.currentSong.id)
                self.currentIndex = 0
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
