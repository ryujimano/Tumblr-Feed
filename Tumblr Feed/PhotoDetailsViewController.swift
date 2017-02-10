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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: photoURL) {
            photoView.setImageWith(url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
