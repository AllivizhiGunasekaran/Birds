//
//  RandomSlide.swift
//  Birds
//
//  Created by Administrator on 2/25/15.
//  Copyright (c) 2015 iZaapTechnology. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import iAd

class RandomSlide: UIViewController, ADBannerViewDelegate
{
    @IBOutlet var activity : UIActivityIndicatorView!
    @IBOutlet var image: UIImageView!
    var soundTimer: NSTimer = NSTimer()
    var audioPlayer2 = AVAudioPlayer()
    var index : Int = 0
    var error5 : NSError?
    var returndata_videos: NSMutableData! = NSMutableData()
    var value_diction:NSMutableArray! = NSMutableArray()
    var valuedict:NSDictionary! = NSDictionary()
    var arrcommentscount:NSMutableArray! = NSMutableArray()
    var pictures : NSMutableArray! = NSMutableArray()
    @IBOutlet var label : UILabel?
    var pictureDesc:NSMutableArray! = NSMutableArray()
    var audio:NSMutableArray! = NSMutableArray()
    @IBOutlet var navBar: UINavigationBar!
    let queue : dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        canDisplayBannerAds = true
        navBar.barTintColor = UIColor (red: 69.0/255.0, green: 170.0/255.0, blue: 59.0/255.0, alpha: 1)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        soundTimer .invalidate()
        index = 0
    }
    
    override func viewWillAppear(animated: Bool)
    {
        activity.hidden = false
        activity .startAnimating()
        
        var urlString:NSString! = NSString(format: "http://izaapinnovations.com/CI/index.php/api/get_all_detailsby_catid")
        var request:NSMutableURLRequest?
        let url = NSURL(string: urlString)
        request = NSMutableURLRequest(URL: url!)
        var myConnection:NSURLConnection = NSURLConnection(request: request!, delegate: self)!
        myConnection.start()        

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
            self.soundTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("soundTimerPlayed"), userInfo: nil, repeats: true)
            });            
        });
    }
    
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        print("Error")
        activity.hidden = true
        activity .stopAnimating()
    }

    
    func soundTimerPlayed()
    {
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        var count : Int
        count = app.pictures.count
        index = index + 1
        
        NSLog("TotalCount %d", count)
        NSLog("int i value %d", index);
        if(index < count)
        {
            dispatch_async(queue, {
             dispatch_async(dispatch_get_main_queue(),{
            self.label?.text = self.pictureDesc .objectAtIndex(self.index) as NSString
            let url = NSURL(string: app.pictures[self.index] as NSString)
            if(url != nil)
            {
                let block: SDWebImageCompletionBlock! =
                {
                    (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                }
                let url = NSURL(string: app.pictures[self.index] as NSString)
                self.image.sd_setImageWithURL(url, completed: block)
            }
            
            if let audioUrl = NSURL(string:NSString(format: app.audio .objectAtIndex(self.index) as NSString))
            {
                let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL
                let destinationUrl = documentsUrl.URLByAppendingPathComponent(audioUrl.lastPathComponent!)
                println(destinationUrl, destinationUrl.path)
                
                if NSFileManager().fileExistsAtPath(destinationUrl.path!)
                {
                    self.audioPlayer2 = AVAudioPlayer(contentsOfURL: destinationUrl, error: &self.error5)
                    self.audioPlayer2.stop()
                    self.audioPlayer2.prepareToPlay()
                    self.audioPlayer2.play()
                }
                    
                else
                {
                    if let myAudioDataFromUrl = NSData(contentsOfURL: audioUrl)
                    {
                        if myAudioDataFromUrl.writeToURL(destinationUrl, atomically: true)
                        {
                            println("file saved")
                            self.audioPlayer2 = AVAudioPlayer(contentsOfURL: destinationUrl, error: &self.error5)
                            self.audioPlayer2.stop()
                            self.audioPlayer2.prepareToPlay()
                            self.audioPlayer2.play()
                        }
                        else
                        {
                            println("error saving file")
                        }
                    }
                }
            }
             });
            });
        }
        else
        {
           soundTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("soundTimerPlayed"), userInfo: nil, repeats: true)
           index = 0;
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
