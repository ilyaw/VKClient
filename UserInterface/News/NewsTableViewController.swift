//
//  NewsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    let newsCell = "NewsCell"
    let allNews = getAllNews()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: newsCell)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNews.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsCell, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        
        let news = allNews[indexPath.row]
        
        cell.postAvatar.image = UIImage(named: news.postAvatar)
        cell.author.text = news.postAuthor
        cell.date.text = news.postDate
        cell.contentText.text = news.postContentText
        cell.contentImageView.image = UIImage(named: news.postImage)

        cell.like.setLike(count: news.likeCount)
        cell.comment.setComment(count: news.commentCount)
        cell.share.setShare(count: news.shareCount)
        cell.views.text = String(news.viewsCount)
        
        return cell
    }
    
}
