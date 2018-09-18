//
//  ViewController.swift
//  Giantbomb
//
//  Created by HeAVeN on 9/17/18.
//  Copyright © 2018 HeAVeN. All rights reserved.
//

import UIKit

//structs for json data
struct Game : Decodable{
    let name : String
    let original_release_date : String
    let image : imageURLs
    let deck : String?
    let description : String?
    let platforms : [Platform]
}

struct Platform : Decodable {
    let name : String
}

struct imageURLs : Decodable{
    let thumb_url : String
    let super_url : String
}

struct SearchResult : Decodable{
    let error : String
    let number_of_total_results : Int
    let limit : Int
    let results : [Game]
}


class ViewController: UIViewController {
    @IBOutlet weak var txtBox01: UITextField!
    @IBOutlet weak var SearchBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    var errMsg = ""
    var totalResults = 0
    var games = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Giant Bomb Game Search"
        txtBox01.center.x = self.view.center.x
        txtBox01.placeholder = "Type something interesting..."
        SearchBtn.center.x = self.view.center.x
        SearchBtn.center.y = self.view.center.y
        SearchBtn.layer.cornerRadius = (SearchBtn.layer.frame.size.width) / 6
        SearchBtn.clipsToBounds = true
        SearchBtn.layer.borderWidth = 2
        SearchBtn.layer.borderColor = UIColor.blue.cgColor
        logo.center.x = self.view.center.x
        logo.image = #imageLiteral(resourceName: "logo")
        logo.contentMode = .scaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool){
        self.txtBox01.text = ""
    }

    //search action
    @IBAction func Search(_ sender: Any) {
        guard let searchInput = txtBox01.text
            else { return }
        let res = "https://www.giantbomb.com/api/search/?api_key=a9da4221bd6ec64963b9a5b31dbcce6a600f02b0&format=json&query=" + searchInput.replacingOccurrences(of: " ", with: "%20") + "&resources=game"
        fetchJSON(url: res)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResults" {
            if let vc = segue.destination as? ResultViewController {
                vc.games = self.games
                vc.totalResults = self.totalResults
            }
        }
    }
    
    //fetch JSON data
    fileprivate func fetchJSON(url : String)
    {
        let urlObj = URL(string: url)
        URLSession.shared.dataTask(with: urlObj!){(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let results = try JSONDecoder().decode(SearchResult.self, from: data)
                    self.games = results.results
                    
                    self.totalResults = results.limit <= results.number_of_total_results ? results.limit : results.number_of_total_results
                    if results.error != "OK"{
                        self.showAlert(msg : "Something went wrong, please try again later")
                        return
                    }else if results.number_of_total_results < 1 {
                        self.showAlert(msg : "Sorry, no matching result.")
                        return
                    }else {
                        self.performSegue(withIdentifier: "ShowResults", sender: nil)
                    }
                }
                catch {
                    self.showAlert(msg : "Something went wrong, please try again later")
                    return
                }
                
            }
            }.resume()
    }
    
    //show alertview
    func showAlert(msg : String) {
        let alertController = UIAlertController(title: "Error", message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

