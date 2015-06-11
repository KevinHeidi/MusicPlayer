//
//  OnlineTableViewController.swift
//  MusicPlayer
//
//  Created by LUOKEFENG on 9/6/2015.
//  Copyright (c) 2015年 LUOKEFENG. All rights reserved.
//

import UIKit

class OnlineTableViewController: UITableViewController {
    
    var channelList:Array<Channel> = []
    var currentChannel:Channel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Running Online Table View Controller")
        var rect:CGRect = self.view.bounds
        var imageView:UIImageView = UIImageView(frame: rect)
        
        let image = UIImage(named: "MusicBG")
        imageView.image = image
        self.tableView.backgroundView = imageView
        
        loadChannelListData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadChannelListData(){
        var url = NSURL(string: "https://gitcafe.com/wcrane/XXXYYY/raw/master/baidu.json")
        var request = NSMutableURLRequest(URL: url!)
        println("\(url)")
        //獲取主隊列
        var mainQueue = NSOperationQueue()
        //執行異步操作
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler:{
            (response:NSURLResponse!,data:NSData!,error:NSError!) -> Void in
            var httpStatusCode = response as! NSHTTPURLResponse
            //println("\(httpStatusCode)")
            if httpStatusCode.statusCode == 200 {
                var str = NSString(data: data, encoding: NSUTF8StringEncoding)
              //  println("\(str)")
                var array:NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSArray
              //  println("\(array)")
                
                for dict in array {
                    var channel = Channel.init(dict:dict as! NSDictionary)
                    self.channelList.append(channel)
                }
                //println("\(self.channelList)")
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //有多少個分組
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.channelList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        var channel = channelList[indexPath.row]
        
        cell.textLabel!.text = channel.title as String
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        currentChannel = self.channelList[indexPath.row]
        
        return indexPath
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        var destViewController = segue.destinationViewController as! OnlineViewController
        
        destViewController.channel = currentChannel
    }


}
