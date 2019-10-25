//
//  Page1ViewController.swift
//  YoutuberApp
//
//  Created by 長坂豪士 on 2019/10/23.
//  Copyright © 2019 NagaKe. All rights reserved.
//

import UIKit
import SegementSlide
import Alamofire
import SwiftyJSON
import SDWebImage

class Page3ViewController: UITableViewController, SegementSlideContentScrollViewDelegate {

    //JSONデータを全て１つのArrayに入れても良いが、ここでは分ける
    var youtubeData = YoutubeData()
    
    var videoIdArray = [String]()
    var publishedAtArray = [String]()
    var titleArray = [String]()
    var imageURLStringArray = [String]()
    var youtubeURLArray = [String]()
    var channelTitleArray = [String]()
    
    let refresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        
        
        getData()
        tableView.reloadData()

    }
    
    @objc func update() {
        
        getData()
        tableView.reloadData()
        refresh.endRefreshing()
        
    }

    @objc var scrollView: UIScrollView {
        return tableView
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        // セルを選択時に背景をグレーにしない
        cell.selectionStyle = .none
        // URL型にキャスト
        let profileImageURL = URL(string: imageURLStringArray[indexPath.row] as String)!
        // URLを画像に変換
//        cell.imageView?.sd_setImage(with: profileImageURL, completed: nil)
        cell.imageView?.sd_setImage(with: profileImageURL, completed: { (image, error, _, _) in
            
            if error == nil {
                
                cell.setNeedsLayout()
            }
        })
        
        cell.textLabel!.text = titleArray[indexPath.row]
//        cell.detailTextLabel!.text = publishedAtArray[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.numberOfLines = 5
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexNumber = indexPath.row
        let webViewController = WebViewController()
        let url = youtubeURLArray[indexNumber]
        UserDefaults.standard.set(url, forKey: "url")
        present(webViewController, animated: true, completion: nil)
        
        
        
    }

    func getData() {
        
        var text = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBSRfx6mz-9qI5G9wuJ95roA7guu8y3gKk&q=犬&part=snippet&maxResults=40&order=date"
        
        // URLに日本語等が入っている場合に変換するメソッド
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Requestを送る
        request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (responce) in
            
            //JSON解析
            //40個値が入ってくるので、for文で全て配列に入れる
            
            print(responce)
            
            switch responce.result {
                
            case .success:
                
                for i in 0...19 {
                    
                    let json: JSON = JSON(responce.data as Any)
                    let videoId = json["items"][i]["id"]["videoId"].string
                    let publishedAt = json["items"][i]["snippet"]["publishedAt"].string
                    let title = json["items"][i]["snippet"]["title"].string
                    let imageURL = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
                    let youtubeURL = "https://www.youtube.com/watch?v=\(videoId!)"
                    let channelTitle = json["items"][i]["snippet"]["channelTitle"].string
                    
                    self.videoIdArray.append(videoId!)
//                    self.publishedAtArray.append(publishedAt!)
                    self.titleArray.append(title!)
                    self.imageURLStringArray.append(imageURL!)
                    self.channelTitleArray.append(channelTitle!)
                    self.youtubeURLArray.append(youtubeURL)
                }
                break
                
            case .failure(let error):
                print(error)
                break
                
            }
            
            self.tableView.reloadData()
            
        }

    }
    

}
