//
//  FullScreenPhotoViewController.swift
//  Tumblr Feed
//
//  Created by Ryuji Mano on 2/9/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var photoURL: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        // Do any additional setup after loading the view.
        photoView.setImageWith(URL(string: photoURL)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
    
    @IBAction func onButtonPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
