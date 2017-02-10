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
    
    var selectedRow = -1    //selected row of the tableview
    
    var posts: [NSDictionary] = []
    
    var isMoreDataLoading = false
    
    var page = 0
    
    var loadingView:InfiniteScrollActivityView?
    
    
    // MARK: - View Configuration
    override func viewDidLoad() {
        super.viewDidLoad()

        //configure tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 300
        
        getData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.refresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingView = InfiniteScrollActivityView(frame: frame)
        loadingView!.isHidden = true
        tableView.addSubview(loadingView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }

    
    func getData() {
        //make a network request to Tumblr's API
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(page)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                if error != nil {
                    self.loadingView?.stopAnimating()
                    return
                }
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        self.isMoreDataLoading = false
                        
                        //retrieve the "response" dictionary from JSON
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        //retrieve the "posts" dictionary from "response"
                        self.posts.append(contentsOf: responseFieldDictionary["posts"] as! [NSDictionary])
                        
                        self.loadingView?.stopAnimating()
                        
                        //reload data in tableview
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()

    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        
        //make a network request to Tumblr's API
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
                        
                        //retrieve the "response" dictionary from JSON
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        //retrieve the "posts" dictionary from "response"
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        //reload data in tableview
                        self.tableView.reloadData()
                    }
                }
                refreshControl.endRefreshing()
        });
        task.resume()

    }
    
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        
        let post = posts[indexPath.section]
        /*
        //retrieve username and profile image to put in the cell
        if let user = post["blog_name"] as? String {
            cell.userLabel.text = user
            cell.profileImage.setImageWith(URL(string: "https://api.tumblr.com/v2/blog/\(user)/avatar")!)
        }
        */
        //retrieve the comment of the corresponding image to put in the cell
//        if let comment = post.value(forKey: "reblog") as? NSDictionary {
//            if let comment = comment.value(forKey: "comment") as? String  {
//                
//                //use regex to strip HTML tags
//                let com = comment.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                
//                cell.commentLabel.text = com
//                
//            }
//        }
        
        //retrieve image to put in the cell
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageURLPath = photos[0].value(forKeyPath: "original_size.url") as? String
            if let url = URL(string: imageURLPath!) {
                cell.photoView.setImageWith(url)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //if a cell is selected, change the height of the cell to 500 (to reveal the comment)
        //otherwise, keep it at 300
        /*
        if selectedRow == indexPath.row {
            return 500
        }
        else {
            return 223
        }*/
        return 223
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if the selected cell is at its original height, update the tableview to reveal the comment
        /*
        if tableView.cellForRow(at: indexPath)?.frame.height == 300 {
            selectedRow = indexPath.row
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        */
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        header.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.75)
        
        let post = posts[section]
            //retrieve username and profile image to put in the cell
        let profileImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        
        var userName: String?
        
        if let user = post["blog_name"] as? String {
            userName = user
            profileImage.setImageWith(URL(string: "https://api.tumblr.com/v2/blog/\(user)/avatar")!)
        }
        
        //set profile image to a circular view
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        //add border around profile image
        profileImage.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        profileImage.layer.borderWidth = 2

        header.addSubview(profileImage)
        
        let userLabel = UILabel(frame: CGRect(x: 100, y: 10, width: 250, height: 40))
        userLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        userLabel.text = userName
        
        let dateLabel = UILabel(frame: CGRect(x: 100, y: 60, width: 250, height: 20))
        dateLabel.font = UIFont(name: "Avenir-Book", size: 14)
        dateLabel.text = post["date"] as? String
        
        header.addSubview(userLabel)
        header.addSubview(dateLabel)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! PhotoTableViewCell)
        
        let post = posts[(indexPath?.section)!]
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageURLPath = photos[0].value(forKeyPath: "original_size.url") as! String
                destination.photoURL = imageURLPath
        }
        
        destination.post = posts[(indexPath?.section)!]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollHeight = scrollView.contentSize.height
            let scrollOffset = scrollHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffset && scrollView.isDragging {
                isMoreDataLoading = true
                page = posts.count
                
                
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingView?.frame = frame
                loadingView!.startAnimating()
                
                getData()
            }
        }
    }
}
