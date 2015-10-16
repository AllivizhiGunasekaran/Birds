//
//  Play.swift
//  Birds
//
//  Created by Administrator on 2/25/15.
//  Copyright (c) 2015 iZaapTechnology. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import iAd

extension PlayCell
{
    
}






class Play: UIViewController, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, NSURLConnectionDataDelegate, AVAudioPlayerDelegate, ADBannerViewDelegate
{
    @IBOutlet var mainTable : UITableView! = UITableView()
    var returndata_videos: NSMutableData! = NSMutableData()
    var value_diction:NSMutableArray! = NSMutableArray()
    var valuedict:NSDictionary! = NSDictionary()
    var arrcommentscount:NSMutableArray! = NSMutableArray()
    var pictures : NSMutableArray! = NSMutableArray()
    var pictureDesc:NSMutableArray! = NSMutableArray()
    var audio:NSMutableArray! = NSMutableArray()
    @IBOutlet var activity : UIActivityIndicatorView!
    var beepPlayer : AVAudioPlayer!
    var beepSound : NSURL!
    var timer:NSTimer!
    @IBOutlet var navBar: UINavigationBar!
    let queue : dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        canDisplayBannerAds = true
        self.navigationItem.title = "Birds";
        navBar.barTintColor = UIColor (red: 69.0/255.0, green: 170.0/255.0, blue: 59.0/255.0, alpha: 1)
        activity.hidden = false
        activity .startAnimating()
        var urlString:NSString! = NSString(format: "http://izaapinnovations.com/CI/index.php/api/get_all_detailsby_catid")
        var request:NSMutableURLRequest?
        let url = NSURL(string: urlString)
        request = NSMutableURLRequest(URL: url!)
        var myConnection:NSURLConnection = NSURLConnection(request: request!, delegate: self)!
        myConnection.start()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?)
    {
        if segue!.identifier == "PlayDetail"
        {
            let viewController:UINavigationController = segue!.destinationViewController as UINavigationController
            let indexPath = mainTable.indexPathForSelectedRow()
            //viewController.pinCode = self.exams[indexPath.row]
        }
        
    }
    
    //NSURLConnectionDelegate methods
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    {
        returndata_videos?.length=0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        returndata_videos?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        self.activity.hidden = true
        self.activity .stopAnimating()
        dispatch_async(queue, {
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        var err: NSError
        var dic: NSDictionary = NSJSONSerialization.JSONObjectWithData(self.returndata_videos , options:    NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        print(dic)
        self.value_diction = dic.valueForKey("languagelist") as NSMutableArray
        print(self.value_diction)
        
        for (var i:Int=0; i<self.value_diction.count; i++ )
        {
            self.valuedict=self.value_diction .objectAtIndex(i) as NSDictionary
            var s:NSDictionary = self.valuedict .objectForKey("detail_list") as NSDictionary
            self.pictures? .addObject(s .objectForKey("picture")!)
            self.pictureDesc? .addObject(s .objectForKey("text")!)
            self.audio?.addObject(s.objectForKey("audio")!)
        }
        NSLog("string in the dict %@", self.pictures)
        app.pictures = self.pictures
        app.pictureDesc = self.pictureDesc
        app.audio = self.audio
        dispatch_async(dispatch_get_main_queue(),{
            self.mainTable .reloadData()
        });
    });
}
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        print("Error")
        activity.hidden = true
        activity .stopAnimating()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.backgroundColor = UIColor .clearColor()
        cell.backgroundColor = UIColor .clearColor()
    }

    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        NSLog("Pictures %d %d", pictures.count, pictureDesc.count)
        return pictures.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        NSLog("picture %@\n text %@\n", pictures, pictureDesc)
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayCell", forIndexPath: indexPath) as PlayCell
        cell.label?.text = pictureDesc[indexPath.row] as? String
        cell.label.textColor = UIColor .whiteColor()
        //cell.imageView!.image = UIImage(named: pictures[indexPath.row] as NSString)
        let url = NSURL(string: pictures[indexPath.row] as NSString)
        if((url) != nil)
        {
            //let data = NSData(contentsOfURL: url!)
            //Make sure your image in this url does exist, otherwise unwrap in a if let check
            let block: SDWebImageCompletionBlock! = {
                (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                //			println(self)
            }
            let url = NSURL(string: pictures[indexPath.row] as NSString)
            cell.images.sd_setImageWithURL(url, completed: block)
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        tableView .cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        var view: PlayDetailedView = self.storyboard?.instantiateViewControllerWithIdentifier("PlayDetailedView") as PlayDetailedView
        app.text = app.pictureDesc .objectAtIndex(indexPath.row) as NSString
        let url = NSURL(string: app.pictures .objectAtIndex(indexPath.row) as NSString)
        if((url) != nil)
        {
            let data = NSData(contentsOfURL: url!)
            //Make sure your image in this url does exist, otherwise unwrap in a if let check
            app.image = UIImage(data:data!)
        }
        let fileURL = NSURL(string:NSString(format: app.audio .objectAtIndex(indexPath.row) as NSString))
        app.fileURL = fileURL
        NSLog("File %@ Image %@ Text %@", app.fileURL!, app.image, app.text);
        
    }
    
    
   func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
   {
    
   }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



/*
func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
{
    let app = UIApplication.sharedApplication().delegate as AppDelegate
    tableView .cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    // let storyboard = UIStoryboard(name: "Main", bundle: nil)
    // let vc = storyboard.instantiateViewControllerWithIdentifier("PlayDetailedView") as UIViewController
    
    var view: PlayDetailedView = self.storyboard?.instantiateViewControllerWithIdentifier("PlayDetailedView") as PlayDetailedView
    //view.image.image = app.pictures .objectAtIndex(indexPath.row) as? UIImage
    
    self.presentViewController(view, animated: true, completion: nil)
    
    view.label.text = app.pictureDesc .objectAtIndex(indexPath.row) as NSString
    let url = NSURL(string: app.pictures .objectAtIndex(indexPath.row) as NSString)
    if((url) != nil)
    {
        let data = NSData(contentsOfURL: url!)
        //Make sure your image in this url does exist, otherwise unwrap in a if let check
        view.image.image = UIImage(data:data!)
    }
    let fileURL = NSURL(string:NSString(format: app.audio .objectAtIndex(indexPath.row) as NSString))
    NSLog("File %@", fileURL!);
    let sound = NSData(contentsOfURL: fileURL!, options: nil, error: nil)
    var error5: NSError?
    var player = AVAudioPlayer(data: sound, error: &error5)
    if player == nil
    {
        if let e = error5
        {
            println(e.localizedDescription)
        }
    }
    player.prepareToPlay()
    player.volume = 1.0
    player.delegate = self
    player.play()
}
*/

