//
//  DetailController+Extention.swift
//  HalaalApp
//
//  Created by ZainAnjum on 12/06/2018.
//  Copyright © 2018 ZainAnjum. All rights reserved.
//
import UIKit
extension DetailController{
    
    func getRelityInfo() {
        self.SetupLoading()
        let headers = [
            "authentication": "1234567890",
            "platform": "ios",
            "vnumber": "1",
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control": "no-cache",
            "Postman-Token": "fb81683a-1e13-4d80-8761-0f35a8077bb2"
        ]
        
        let postData = NSMutableData(data: "realty_id=84".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://halaalappinvestment.com/admin/services/get_reality_info.php")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
            do {
                let myJson = try JSONDecoder().decode(Halal.self, from: data)
                //*********
                self.HalalData = myJson
                //********
                
                
                DispatchQueue.main.async { // Correct
                    self.stopLoading()
                    self.title = myJson.description
                    
                    
                    self.getNearestRestaurents(lat: myJson.latitude!, long: myJson.longitude!)
                    if let long = myJson.longitude, let lat = myJson.latitude{
                        
                        let longitute = Double(long)
                        let latitute = Double(lat)
                        
                        if let safelong = longitute, let safelat = latitute{
                                self.setupMapView(long: safelong, lat: safelat)
                        }
                        
                        
                  
                        if let imageString = myJson.image_models?[0].image{
                            
                            self.userProfileImageView.loadImageUsingCacheFromUrlString(urlString: self.base_url + imageString)
                            
                            self.userProfileImageView.backgroundColor = .white
                        }
                        
                    }
                    
                    
                    self.CollectionView?.reloadData()
                    self.tableView.reloadData()
                    
                }
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
                self.stopLoading()
            }
            
        })
        
        
        dataTask.resume()
    }
    
    func getNearestRestaurents(lat: String, long: String) {
        self.SetupLoading()
        let headers = [
            "Cache-Control": "no-cache",
            "Postman-Token": "38d72f0b-f275-4ae6-b82d-3ca57bcae543"
        ]
        let first = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + lat + "," + long
        let second = "&radius=500&types=%E2%80%8Bfood%E2%80%8B&key=AIzaSyAQS_zD0hfumZN7HgzZYdj5YMoobDGd8ac"
       
        let completeUrl = first + second
        
        print(completeUrl)
        
        let request = NSMutableURLRequest(url: NSURL(string: completeUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
            do {
                let myJson = try JSONDecoder().decode(nearestMaps.self, from: data)
                //*********
                self.NearestCafe = myJson
                //********
                
                
                DispatchQueue.main.async { // Correct
                        self.tableView.reloadData()
                        self.stopLoading()
                }
            }
                catch{
                    print(error)
                    self.stopLoading()
                }
        })
        
        dataTask.resume()
    }
    func SetupLoading() {
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = "Loading..."
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        if let window = UIApplication.shared.keyWindow{
            
            
            
            effectView.frame = CGRect(x: window.frame.midX - strLabel.frame.width/2, y: window.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
            effectView.layer.cornerRadius = 15
            effectView.layer.masksToBounds = true
            
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            activityIndicator.startAnimating()
            
            effectView.layer.zPosition = 1
            effectView.backgroundColor = UIColor.lightGray
            effectView.contentView.addSubview(activityIndicator)
            effectView.contentView.addSubview(strLabel)
            window.addSubview(effectView)
        }
    }
    func stopLoading() {
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
    }
}
