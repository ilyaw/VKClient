//
//  NewsTableViewController.swift
//  UserInterface
//
//  Created by Илья Руденко on 13.03.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    //высота ячейки - height forRowAt indexPath
    
    let allNews = getAllNews()
    let newsCell = "NewsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: newsCell)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
    }
    
    // MARK: - Table view data source
    
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
