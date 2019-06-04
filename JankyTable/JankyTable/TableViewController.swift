//
//  TableViewController.swift
//  JankyTable
//
//  Created by Thomas Vandegriff on 5/28/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private var photosDict: [String: String] = [:]
//    lazy var photos = NSDictionary(contentsOf: dataSourceURL)!
    lazy var photos = NSDictionary(dictionary: photosDict)


    
     private var urls: [URL] = []
//    lazy var photos = NSDictionary(contentsOf: dataSourceURL)!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Rework bundle stuff...
        
        guard let plist = Bundle.main.url(forResource: "PhotosDictionary", withExtension: "plist"),
            let contents = try? Data(contentsOf: plist),
            let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
//            let serialUrls = serial as? [String] else {
//                print("Something went horribly wrong!")
//                return
            let serialUrls = serial as? [String: String] else {
                print("Something went horribly wrong!")
                return
        }
        
//        urls = serialUrls.compactMap { URL(string: $0) }
        
        photosDict = serialUrls

         print(urls)
    }
    

    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        
        return photosDict.count
    }
    
//     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//              let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "normal", for: indexPath) as! PhotoCell
//
//        if let data = try? Data(contentsOf: urls[indexPath.item]),
//            let image = UIImage(data: data) {
//
//            cell.imageView?.image = image
//
////            cell.textLabel?.text =
////            if image != nil {
////                cell.imageView?.image = image
////            }
//
//
////            cell.display(image)
////        } else {
////            cell.display(nil)
////        }
////
//
//        //        // Configure the cell...
//        //        cell.textLabel?.text = rowKey
//        //        if image != nil {
//        //            cell.imageView?.image = image!
//        //        }
//
//
//
////        return cell
//    }
//        return cell
//    }
    
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let rowKey = self.photos.allKeys[indexPath.row] as! String
        
        //TODO: Send filtering to BG queue, then set image on main queue...
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let self = self else {
                return
            }
            
        
//        let queue = DispatchQueue(label: "com.makeschool.queue")
        
        
        var image : UIImage?
        
        guard let imageURL = URL(string:self.photos[rowKey] as! String),
        let imageData = try? Data(contentsOf: imageURL) else {
//            return cell
            return
        }
        
        // Simulate a network wait
        Thread.sleep(forTimeInterval: 1)
        print("sleeping 1 sec")
        
        //1
        let unfilteredImage = UIImage(data:imageData)
        //2
        image = self.applySepiaFilter(unfilteredImage!)
        
        DispatchQueue.main.async {
            // Configure the cell...
            cell.textLabel?.text = rowKey
            if image != nil {
                cell.imageView?.image = image!
            }
        }
        
//        return cell
    }
        return cell
    }
    
    /* Working cellForRowAt - no Concurrency */
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
//        let rowKey = photos.allKeys[indexPath.row] as! String
//
//        var image : UIImage?
//
//        guard let imageURL = URL(string:photos[rowKey] as! String),
//            let imageData = try? Data(contentsOf: imageURL) else {
//                return cell
//        }
//
//        // Simulate a network wait
//        Thread.sleep(forTimeInterval: 1)
//        print("sleeping 1 sec")
//
//        //1
//        let unfilteredImage = UIImage(data:imageData)
//        //2
//        image = self.applySepiaFilter(unfilteredImage!)
//
//        // Configure the cell...
//        cell.textLabel?.text = rowKey
//        if image != nil {
//            cell.imageView?.image = image!
//        }
//
//        return cell
//    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
////        let rowKey = photos.allKeys[indexPath.row] as! String
////        let rowKey = photosDict.(forKey: indexPath.row]
//        let title = self.photosDict[indexPath.row]
//
//        var image : UIImage?
//
////        guard let imageURL = URL(string:photos[rowKey] as! String),
//        guard let imageURL = URL(string:photosDict[rowKey] as! String),
//            let imageData = try? Data(contentsOf: imageURL) else {
//                return cell
//        }
//
//        //1
//        let unfilteredImage = UIImage(data:imageData)
//        //2
//        image = self.applySepiaFilter(unfilteredImage!)
//
//        // Configure the cell...
//        cell.textLabel?.text = rowKey
//        if image != nil {
//            cell.imageView?.image = image!
//        }
//
//        return cell
//    }
    
    // MARK: - image processing
    
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:image.pngData()!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        
        guard let outputImage = filter!.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        return UIImage(cgImage: outImage)
    }
}


