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

class Page1ViewController: UITableViewController, SegementSlideContentScrollViewDelegate {

    //JSONデータを全て１つのArrayに入れても良いが、ここでは分ける
    var youtubeData = YoutubeData()
    
    var videoIdArray = [String]()
    var publishedAtArray = [String]()
    var titleArray = [String]()
    var imageURLStringArray = [String]()
    var youtubeURLArray = [String]()
    var channelTitleArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()

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
        cell.imageView?.sd_setImage(with: profileImageURL, completed: nil)
        
        cell.textLabel!.text = titleArray[indexPath.row]
        cell.detailTextLabel!.text = publishedAtArray[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.numberOfLines = 5
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexNumber = indexPath.row
        let webViewController = UIViewController()
        let url = youtubeURLArray[indexNumber]
        UserDefaults.standard.set(url, forKey: "url")
        present(webViewController, animated: true, completion: nil)
        
        
        
    }

    func getData() {
        
        var text = "https://www.googleapis.com/youtube/v3/search?key=APIKEY&q=那須川天心&part=snippet&maxResults=40&order=date"
        
        // URLに日本語等が入っている場合に変換するメソッド
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Requestを送る
        request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (responce) in
            
            //JSON解析
            //40個値が入ってくるので、for文で全て配列に入れる
            
            print(responce)
            
            switch responce.result {
                
            case .success:
                
                for i in 0...39 {
                    
                    let json: JSON = JSON(responce.data as Any)
                    let videoId = json["items"][i]["id"]["videoId"].string
                    let publishedAt = json["items"][i]["snippet"]["publishedAt"].string
                    let title = json["items"][i]["snippet"]["title"].string
                    let imageURL = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
                    let youtubeURL = "https://www.youtube.com/watch?v=\(videoId)"
                    let channelTitle = json["items"][i]["snippet"]["channelTitle"].string
                    
                    self.videoIdArray.append(videoId!)
                    self.publishedAtArray.append(publishedAt!)
                    self.titleArray.append(title!)
                    self.imageURLStringArray.append(imageURL!)
                    self.channelTitleArray.append(channelTitle!)
                    self.youtubeURLArray.append(youtubeURL)
                }
                
            case .failure(let error):
                print(error)
                break
                
            }
        }

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
