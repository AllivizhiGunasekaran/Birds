//
//  PlayDetailedView.swift
//  Birds
//
//  Created by Administrator on 2/25/15.
//  Copyright (c) 2015 iZaapTechnology. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import iAd

class PlayDetailedView: UIViewController, AVAudioPlayerDelegate, ADBannerViewDelegate
{
    @IBOutlet var adView : ADBannerView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var scrollView1: UIScrollView!
    var beepPlayer : AVAudioPlayer!
    var beepSound : NSURL!
    var type : NSString!
    var name : NSString!
    var soundFiles : NSArray!
    var url1 : NSURL!
    let kScrollObjHeight: CGFloat 	= 199.0;
    let kScrollObjWidth : CGFloat 	= 280.0;
    let kNumImages: CGFloat 		= 5.0;
    var error5: NSError?
     @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var Next: UIButton!
    @IBOutlet var Previous: UIButton!
    var index : Int = 0
    var count : Int = 0    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        canDisplayBannerAds = true
        self.navigationItem.title = "DetailedView";
        navBar.barTintColor = UIColor (red: 69.0/255.0, green: 170.0/255.0, blue: 59.0/255.0, alpha: 1)
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        
        label.text = app.text;
        image.image = app.image;
        let sound = NSData(contentsOfURL: app.fileURL!, options: nil, error: nil)
        NSLog("Text %@ Image %@ Sound%@", label.text!, image.image!, sound!)
        
        
        
        let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL
        let destinationUrl = documentsUrl.URLByAppendingPathComponent(app.fileURL.lastPathComponent!)
        println(destinationUrl, destinationUrl.path)
        
        if NSFileManager().fileExistsAtPath(destinationUrl.path!)
        {
            beepPlayer = AVAudioPlayer(contentsOfURL: destinationUrl, error: &error5)
            beepPlayer.prepareToPlay()
            beepPlayer.play()
        }
            
        else
        {
            if let myAudioDataFromUrl = NSData(contentsOfURL: app.fileURL)
            {
                if myAudioDataFromUrl.writeToURL(destinationUrl, atomically: true)
                {
                    println("file saved")
                    beepPlayer = AVAudioPlayer(contentsOfURL: destinationUrl, error: &error5)
                    beepPlayer.prepareToPlay()
                    beepPlayer.play()
                }
                else
                {
                    println("error saving file")
                }
            }
        }
    }
    
    
    
    @IBAction func dismiss()
    {
        [self .dismissViewControllerAnimated(true, completion: nil)]
    }
    
    @IBAction func previousImage(sender: AnyObject)
    {
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        count = app.pictures.count
        index = index - 1;
        print(count)
        print(index)
        if(index > 0)
        {
           // let url = NSURL(string: app.pictures[index] as NSString)
           // let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
          //  image.image = UIImage(data: data!)
            
            let url = NSURL(string: app.pictures[index] as NSString)
            if(url != nil)
            {
                let block: SDWebImageCompletionBlock! = {
                    (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    //			println(self)
                }
                let url = NSURL(string: app.pictures[index] as NSString)
                image.sd_setImageWithURL(url, completed: block)
            }
            
            if let audioUrl = NSURL(string:NSString(format: app.audio .objectAtIndex(index) as NSString))
            {
                let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL
                let destinationUrl = documentsUrl.URLByAppendingPathComponent(audioUrl.lastPathComponent!)
                println(destinationUrl, destinationUrl.path)
                
                if NSFileManager().fileExistsAtPath(destinationUrl.path!)
                {
                    beepPlayer = AVAudioPlayer(contentsOfURL: destinationUrl, error: &error5)
                    beepPlayer.prepareToPlay()
                    beepPlayer.play()
                }
                    
                else
                {
                    if let myAudioDataFromUrl = NSData(contentsOfURL: audioUrl)
                    {
                        if myAudioDataFromUrl.writeToURL(destinationUrl, atomically: true)
                        {
                            println("file saved")
                            beepPlayer = AVAudioPlayer(contentsOfURL: destinationUrl, error: &error5)
                            beepPlayer.prepareToPlay()
                            beepPlayer.play()
                        }
                        else
                        {
                            println("error saving file")
                        }
                    }
                }
            }
            Previous.enabled = true
            if(index == count)
            {
                Next.enabled = false
            }
            else
            {
                Next.enabled = true
            }
        }
        else
        {
            Previous.enabled = false
            Next.enabled = true
        }
    }
    
    
    //Next Image
    @IBAction func NextImage(sender: AnyObject)
    {
        let app = UIApplication.sharedApplication().delegate as AppDelegate        
        var count : Int
        count = app.pictures.count
        index = index + 1
        
        NSLog("TotalCount", count)
        NSLog("int i value", index);
        if(index < count)
        {
            let url = NSURL(string: app.pictures[index] as NSString)
            if(url != nil)
            {
                let block: SDWebImageCompletionBlock! = {
                    (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    //			println(self)
                }
                let url = NSURL(string: app.pictures[index] as NSString)
                image.sd_setImageWithURL(url, completed: block)
            }
            
            if let audioUrl = NSURL(string:NSString(format: app.audio .objectAtIndex(index) as NSString))
            {
                let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL
                let destinationUrl = documentsUrl.URLByAppendingPathComponent(audioUrl.lastPathComponent!)
                println(destinationUrl, destinationUrl.path)
                
                if NSFileManager().fileExistsAtPath(destinationUrl.path!)
                {
                    beepPlayer = AVAudioPlayer(contentsOfURL: destinationUrl, error: &error5)
                    beepPlayer.prepareToPlay()                        
                    beepPlayer.play()
                }
                
                else
                {
                    if let myAudioDataFromUrl = NSData(contentsOfURL: audioUrl)
                    {
                        if myAudioDataFromUrl.writeToURL(destinationUrl, atomically: true)
                        {
                                println("file saved")
                                beepPlayer = AVAudioPlayer(contentsOfURL: destinationUrl, error: &error5)
                                beepPlayer.prepareToPlay()
                                beepPlayer.play()
                        }
                        else
                        {
                                println("error saving file")
                        }
                    }
                }
                Next.enabled = true
                if(index == 0)
                {
                    Previous.enabled = false
                }
                else
                {
                    Previous.enabled = true
                }
            }
        }
        else
        {
            Next.enabled = false
            Previous.enabled = true
        }
    }

    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
}
