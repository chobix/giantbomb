//
//  DetailedViewController.swift
//  Giantbomb
//
//  Created by HeAVeN on 9/18/18.
//  Copyright © 2018 HeAVeN. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    var game : Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = game?.name
        
        let url = URL(string: (game?.image.super_url)!)
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
                            self.img1.image = UIImage(data: imageData)
                            self.img1.contentMode = .scaleAspectFit
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
        
        self.txtView.text = "Supported Platforms:"
        for pf in (game?.platforms)!
        {
            self.txtView.text = self.txtView.text + " | " + pf.name
        }
        self.txtView.text = self.txtView.text + "\n\n"
        self.txtView.text = self.txtView.text + "Release Date: " + (game?.original_release_date)! + "\n\n"
        self.txtView.text = self.txtView.text + game!.deck! + "\n"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
