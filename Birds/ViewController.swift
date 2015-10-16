//
//  ViewController.swift
//  Birds
//
//  Created by Administrator on 2/25/15.
//  Copyright (c) 2015 iZaapTechnology. All rights reserved.
//

import UIKit
import iAd


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate
{
    //var languages : NSArray!
    @IBOutlet var adView : ADBannerView!
    @IBOutlet var mainTable:UITableView!
    var returndata_videos: NSMutableData! = NSMutableData()
    var value_diction:NSMutableArray! = NSMutableArray()
    var valuedict:NSDictionary! = NSDictionary()
    var languages:NSMutableArray! = NSMutableArray()
    var selectedCell: Int! = Int()
    @IBOutlet var navBar: UINavigationBar!
    let queue : dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        
      /* dispatch_async(queue,{
            
            dispatch_async(dispatch_get_main_queue(),{
                
                });
            
            sleep(5);
            
            dispatch_async(dispatch_get_main_queue(),{
                
                });
            
            });
        */
        
        
        canDisplayBannerAds = true
        let app = UIApplication .sharedApplication().delegate as AppDelegate
        NSLog("lang index %d", app.selectedCellLang)
        self.navigationItem.title = "Birds";
        navBar.barTintColor = UIColor (red: 69.0/255.0, green: 170.0/255.0, blue: 59.0/255.0, alpha: 1)
        var urlString:NSString! = NSString(format: "http://izaapinnovations.com/CI/index.php/api/get_all_language")
        var request:NSMutableURLRequest?
        let url = NSURL(string: urlString)
        request = NSMutableURLRequest(URL: url!)
        
        var myConnection:NSURLConnection = NSURLConnection(request: request!, delegate: self)!
        myConnection.start()
       
        // Do any additional setup after loading the view, typically from a nib.
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
        dispatch_async(queue, {
        var err: NSError
        var dic: NSDictionary = NSJSONSerialization.JSONObjectWithData(self.returndata_videos , options:    NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        print(dic)
        self.value_diction = dic.valueForKey("languagelist") as NSMutableArray
        print(self.value_diction)
        for (var i:Int=0; i<self.value_diction.count; i++ )
        {
            self.valuedict=self.value_diction .objectAtIndex(i) as NSDictionary
            var s:NSDictionary = self.valuedict .objectForKey("lang_list") as NSDictionary
            print(s)
            self.languages .addObject(s .objectForKey("language")!)
        }
        NSLog("string in the dict %@", self.languages)
            
            dispatch_async(dispatch_get_main_queue(),{
                self.mainTable .reloadData()
            });
        
        });
    }
    
    func connecstion(connection: NSURLConnection, didFailWithError error: NSError)
    {
        print("Error")
    }
    

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.backgroundColor = UIColor .clearColor()
        cell.backgroundColor = UIColor .clearColor()
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return languages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        cell.textLabel!.text = languages[indexPath.row] as? String
        cell.textLabel?.textColor = UIColor .whiteColor()
       // cell.detailTextLabel.text="subtitle#\(indexPath.row)"
        if(indexPath.row == selectedCell)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.selected = true;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selected = false;
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        self.selectedCell = indexPath.row
        app.selectedCellLang = indexPath.row
        mainTable .reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

