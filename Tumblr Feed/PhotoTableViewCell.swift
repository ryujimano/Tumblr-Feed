//
//  PhotoTableViewCell.swift
//  Tumblr Feed
//
//  Created by Ryuji Mano on 2/2/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //set profile image to a circular view
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        //add border around profile image
        profileImage.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        profileImage.layer.borderWidth = 2
    }

}
