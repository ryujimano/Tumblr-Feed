//
//  PhotoDetailsViewController.swift
//  Tumblr Feed
//
//  Created by Ryuji Mano on 2/9/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {
    @IBOutlet weak var photoView: UIImageView!
    var photoURL: String!
    var post: NSDictionary!

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.isUserInteractionEnabled = true
        
        if let url = URL(string: photoURL) {
            photoView.setImageWith(url)
        }
        if let user = post["blog_name"] as? String {
            userLabel.text = user
            profileImage.setImageWith(URL(string: "https://api.tumblr.com/v2/blog/\(user)/avatar")!)
            //set profile image to a circular view
            profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
            profileImage.clipsToBounds = true
            
            //add border around profile image
            profileImage.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            profileImage.layer.borderWidth = 2
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: Any) {
        
        performSegue(withIdentifier: "photoViewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FullScreenPhotoViewController
        destination.photoURL = photoURL
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
