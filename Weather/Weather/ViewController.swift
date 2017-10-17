//
//  ViewController.swift
//  Weather
//
//  Created by Nusri Samath on 10/17/17.
//  Copyright © 2017 Nusri Samath. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityName_Lbl: UILabel!
    @IBOutlet weak var condition_Lbl: UILabel!
    @IBOutlet weak var temp_Lbl: UILabel!
    @IBOutlet weak var urlImage_img: UIImageView!
    

    var condition : String!
    var temp_c : Int!
    var urlImage : String!
    var city : String!
    
    var exist : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //@available(iOS 2.0, *)
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // called when keyboard search button pressed
        //cityName_Lbl.text = searchBar.text
        let urlRequest = URLRequest(url: URL(string:"http://api.apixu.com/v1/current.json?key=5786a7ad84c4498182674733171710&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        //\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))
        URLSession.shared.dataTask(with: urlRequest){data,responds,err in
//                        guard let data = data else{return}
//
//                        do{
//                            let location = try JSONDecoder().decode(Location.self, from: data)
//                            print("temp :-",location)
//                        }catch let JsonErr{
//                            print(JsonErr.localizedDescription)
//                        }
            if err == nil{
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] else {return}
                    if let current = json["current"] as? [String: AnyObject]{
                        if let temp = current["temp_c"] as? Int{
                            print("temp : ",temp)
                            self.temp_c = temp
                            }
                        if let condition = current["condition"] as? [String: AnyObject]{
                            self.condition = condition["text"] as! String
                            print(self.condition)
                            let icon = condition["icon"] as! String
                            self.urlImage = "http:\(icon)"
                            //self.urlImage.downloadimage(stringImageUrl: icon)
                            print("image",self.urlImage)
                        }
                    }
                    if let location = json["location"] as? [String: AnyObject]{
                        self.city = location["name"] as? String!
                        print(self.city)
                    }
                    
                    if let _ = json["error"]{
                        self.exist = false
                    }
                    
                    DispatchQueue.main.async {
                        if self.exist{
                            self.condition_Lbl.isHidden = false
                            self.temp_Lbl.isHidden = false
                            self.urlImage_img.isHidden = false
                            self.condition_Lbl.text = self.condition
                            self.cityName_Lbl.text = self.city
                            self.temp_Lbl.text = "\(self.temp_c.description)°"
                            self.urlImage_img.downloadimage(from: self.urlImage)
                            
                        }else{
                            self.cityName_Lbl.text = "No matching city found."
                            self.condition_Lbl.isHidden = true
                            self.temp_Lbl.isHidden = true
                            self.urlImage_img.isHidden = true
                            
                        }
                    }
                    
                }catch let JsonErr{
                    print(JsonErr.localizedDescription)
                }
            }

        }.resume()
    }
}

extension UIImageView{
    func downloadimage(from url: String){
        let urlRequest = URLRequest(url : URL(string:url)!)
        URLSession.shared.dataTask(with: urlRequest){(data,responds,error) in
            if error == nil{
                DispatchQueue.main.async {
                //guard let data = data else{return}
                self.image =  UIImage(data:data!)
                }
            }
        }.resume()
    }
}

