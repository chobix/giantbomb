//
//  ResultViewController.swift
//  Giantbomb
//
//  Created by HeAVeN on 9/17/18.
//  Copyright © 2018 HeAVeN. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainTable: UITableView!

    var totalResults = 0
    var games = [Game]()
    var targetGame : Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        mainTable.dataSource = self
        self.title = "Results: " + String(totalResults)
        mainTable.reloadData()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalResults
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        targetGame = games[indexPath.row]
        self.performSegue(withIdentifier: "ResultsToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsToDetail" {
            let vc = segue.destination as! DetailedViewController
            vc.game = self.targetGame!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell
        let game = games[indexPath.row]
        cell?.titlelbl?.text = game.name
        cell?.releaselbl?.text = "Release Date: " + game.original_release_date.replacingOccurrences(of: " 00:00:00", with: "")

        let url = URL(string: game.image.thumb_url)
        let session = URLSession(configuration: .default)
        //download image
        let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async {
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            cell?.img1?.image = UIImage(data: imageData)
                            cell?.img1?.layer.cornerRadius = (cell?.img1?.layer.frame.size.width)! / 2
                            cell?.img1?.clipsToBounds = true
                            cell?.img1.contentMode = .scaleAspectFill
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
        }
        downloadPicTask.resume()
        
        return cell!
    }
    

}
