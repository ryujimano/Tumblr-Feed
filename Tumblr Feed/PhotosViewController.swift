//
//  PhotosViewController.swift
//  Tumblr Feed
//
//  Created by Ryuji Mano on 2/2/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow = -1

    
    let CLIENT_ID = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
    
    var posts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 300
    
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        let post = posts[indexPath.row]
        
        if let user = post["blog_name"] as? String {
            cell.userLabel.text = user
            cell.profileImage.setImageWith(URL(string: "https://api.tumblr.com/v2/blog/\(user)/avatar")!)
        }
        else {
            return cell
        }
        
        if let comment = post.value(forKey: "reblog") as? NSDictionary {
            guard let comment = comment.value(forKey: "comment") as? String else {
                return cell
            }
            let com = comment.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            cell.commentLabel.text = com
        }
        else {
            return cell
        }
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageURLPath = photos[0].value(forKeyPath: "original_size.url") as? String
            if let url = URL(string: imageURLPath!) {
                cell.photoView.setImageWith(url)
            }
            else {
                return cell
            }
        }
        else {
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedRow == indexPath.row {
            return 500
        }
        else {
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.frame.height == 300 {
            selectedRow = indexPath.row
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        else {
            selectedRow = indexPath.row
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
