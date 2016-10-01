//
//  CollectionViewController.swift
//  GiphySwift-Example
//
//  Created by Matias Seijas on 9/29/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import UIKit
import GiphySwift
import FLAnimatedImage

class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    @IBOutlet weak var imageView: FLAnimatedImageView!
}

class CollectionViewController: UICollectionViewController {
    
    var images = [GiphyImage]()
    var config: (section: Section, row: Row)!
    
    private let queue = DispatchQueue(label: "com.giphyswift.example", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestImages(with: config)
        title = "\(config.section.title): \(config.row.title)"
    }
    
    func requestImages(with config: (section: Section, row: Row)?) {
        guard let config = config else { return }

        switch config.section {
        case .gifs:
            switch config.row {
            case .trending:
                Giphy.Gif.request(.trending) { result in
                    if case .success(let images) = result {
                        self.images = images.result
                        self.updateUI()
                    }
                }
                
            default: break
            }
            
        default: break
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell
            else { fatalError("Could not dequeue cell with reuseIdentifier: \(ImageCell.reuseIdentifier)") }

        let image = images[indexPath.row]
        guard let url = urlFor(image: image) else { fatalError("Unable to retrieve URL for image") }
        
        queue.async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                OperationQueue.main.addOperation {
                    DispatchQueue.main.async {
                        let gifImage = FLAnimatedImage(animatedGIFData: data)
                        cell.imageView.animatedImage = gifImage
                    }
                }
                
            }.resume()
        }
        
        return cell
    }
    
    func urlFor(image: GiphyImage) -> URL? {
        if let image = image as? GiphyImageResult {
            return URL(string: image.images.fixedHeight.downsampled.gif.url)
        }
        
        if let image = image as? GiphyRandomImageResult {
            return URL(string: image.images.fixedHeight.downsampled.gif.url)
        }
        
        return nil
    }
    
}
