//
//  PlayCell.swift
//  Birds
//
//  Created by Administrator on 3/6/15.
//  Copyright (c) 2015 iZaapTechnology. All rights reserved.
//


import UIKit

class PlayCell: UITableViewCell
{
    @IBOutlet var label: UILabel! = UILabel()
    @IBOutlet var images: UIImageView! = UIImageView()
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    
}
