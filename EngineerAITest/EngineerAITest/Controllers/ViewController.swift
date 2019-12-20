//
//  ViewController.swift
//  EngineerAITest
//
//  Created by Kushal Mandala on 20/12/19.
//  Copyright © 2019 Indovations. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var postListTableView: UITableView!
    
    var postInfo : PostInfo!
    var posts : [Post] = []
    var selectedPosts : [Post] = []
    
    var refreshController : UIRefreshControl =  UIRefreshControl()
    
    var reqPage : Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setupRefresh()
    
        self.requestForPosts(page: reqPage)
        self.updateTitle(count: 0)
    }
    
    func updateTitle(count : Int) {
        self.title = "Selected Posts "+"\(count)"
    }
    
    func setupRefresh() {
        self.postListTableView.refreshControl = self.refreshController
        self.refreshController.attributedTitle = NSAttributedString(string: "Refresh Posts...")
        self.refreshController.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
    }
    
    @objc func refreshPosts() {
        self.reqPage = 1
        self.requestForPosts(page: self.reqPage)
        self.refreshController.endRefreshing()
    }
    
    func appendPosts(additionalPosts : [Post]) {
        for post in additionalPosts {
            self.posts.append(post)
        }
    }
    
    func requestForPosts(page:Int) {
        let requestUrl = SyncInfo.BASE_URL+"\(page)";
        Service.shared.requestPosts(url: requestUrl) { postInfo in
            guard postInfo.hits.count > 0 else {
                self.posts = []
                return
            }
            
            self.postInfo = postInfo
            
            if page == 1 {
                self.posts = postInfo.hits
            } else {
                self.appendPosts(additionalPosts: postInfo.hits)
            }
            
            DispatchQueue.main.async {
                self.postListTableView.reloadData()
            }
        }
    }
    
    func registerCell() {
        self.postListTableView.register(UINib(nibName: "PostTableViewCell", bundle: .main), forCellReuseIdentifier: "PostCell")
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.postInfo != nil else {
            return 0
        }
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        
        let post : Post = self.posts[indexPath.row];
        cell.postTitleLabel.text = post.title
        cell.postDateLabel.text = post.created_at
        
        cell.postSwitch.tag = indexPath.row+1
        cell.postSwitch.addTarget(self, action: #selector(postSwitchAction), for: .valueChanged)
        
        
        if self.selectedPosts.contains(where: {$0.objectID == post.objectID}) {
            cell.postSwitch.setOn(true, animated: true)
        } else {
            cell.postSwitch.setOn(false, animated: true)
        }
        
        
        if indexPath.row == self.posts.count-1 {
            self.reqPage += 1
            self.requestForPosts(page: self.reqPage)
        }
        
        return cell
    }
    
    @objc func postSwitchAction(swtch : UISwitch) {
        let index = swtch.tag-1
        let post = self.posts[index]
        self.postSelectOperation(post: post)
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.posts[indexPath.row]
        self.postSelectOperation(post: post)
        
    }
    
    func postSelectOperation(post: Post) {
        if let firstIndex = self.selectedPosts.firstIndex(where: {$0.objectID == post.objectID}) {
            self.selectedPosts.remove(at: firstIndex)
        } else {
            self.selectedPosts.append(post)
        }
        self.postListTableView.reloadData()
        
        self.updateTitle(count: self.selectedPosts.count)
    }
    
    

}

