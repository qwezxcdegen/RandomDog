//
//  ViewController.swift
//  RandomDog
//
//  Created by Степан Фоминцев on 15.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    struct DogData: Decodable {
        var message: URL?
    }
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
    var finalURL = URL(string: "https://dog.ceo/api/breeds/image/random")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchURL(from: url)
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
            fetchURL(from: url)
            downloadImage(from: finalURL)
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.imageViewOutlet.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func fetchURL(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data else { return }
                guard error == nil else { return }
                do {
                    self.finalURL = try JSONDecoder().decode(DogData.self, from: data).message!
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

