//
//  Share.swift
//  Birds
//
//  Created by Administrator on 2/25/15.
//  Copyright (c) 2015 iZaapTechnology. All rights reserved.
//

import Foundation
import UIKit
import iAd

class Share: UIViewController, ADBannerViewDelegate, UIActionSheetDelegate
{
   // var image : UIImage? = UIImage()
    @IBOutlet var navBar: UINavigationBar!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        canDisplayBannerAds = true
        navBar.barTintColor = UIColor (red: 69.0/255.0, green: 170.0/255.0, blue: 59.0/255.0, alpha: 1)
       // image = UIImage(named: "backgroung-img.png")
       // self.view.backgroundColor = UIColor(patternImage: image!)
        self.view.backgroundColor = UIColor (patternImage: (UIImage (named: "backgroung-img.png"))!)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.view.backgroundColor = UIColor (patternImage: (UIImage (named: "backgroung-img.png"))!)
        let activityItems = ["Birds App!"]
        let actviewcon = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        //actviewcon.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypeSaveToCameraRoll]
        self.presentViewController(actviewcon, animated: true, completion: nil)

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}