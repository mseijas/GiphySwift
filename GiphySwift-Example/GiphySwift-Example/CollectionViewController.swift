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
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}

class CollectionViewController: UICollectionViewController {
    
    var images = [GiphyImage]()
    var config: (section: Section, row: Row)!
    
    let layout = UICollectionViewFlowLayout()
    let searchBar = UISearchBar()
    var displaySearchBar = false
    
    private let queue = DispatchQueue(label: "com.giphyswift.example", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        requestImages(with: config, searchText: nil)
        title = "\(config.section.title): \(config.row.title)"
        
        layout.headerReferenceSize = CGSize(width: 100, height: displaySearchBar == true ? 44 : 0)
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionView?.collectionViewLayout = layout
        
        searchBar.delegate = self
    }
    
    func requestImages(with config: (section: Section, row: Row)?, searchText: String?) {
        guard let config = config else { return }

        switch config.section {
        case .gifs:
            switch config.row {
            case .trending:
                Giphy.Gif.request(.trending, completionHandler: processResult)
            
            case .search:
                guard let searchText = searchText else {
                    displaySearchBar = true
                    return
                }
                
                Giphy.Gif.request(.search(searchText), completionHandler: processResult)
                
            case .translate:
                guard let searchText = searchText else {
                    displaySearchBar = true
                    return
                }
                
                Giphy.Gif.request(.translate(searchText), completionHandler: processResult)
                
            case .byID:
                guard let searchText = searchText else {
                    displaySearchBar = true
                    return
                }
                
                Giphy.Gif.request(.withId(searchText), completionHandler: processResult)
                
            case .random:
                displaySearchBar = true
                Giphy.Gif.request(.random(tag: searchText), completionHandler: processResult)
            }
            
        case .stickers:
            switch config.row {
            case .trending:
                Giphy.Sticker.request(.trending, completionHandler: processResult)
                
            case .search:
                guard let searchText = searchText else {
                    displaySearchBar = true
                    return
                }
                
                Giphy.Sticker.request(.search(searchText), completionHandler: processResult)
                
            case .translate:
                guard let searchText = searchText else {
                    displaySearchBar = true
                    return
                }
                
                Giphy.Sticker.request(.translate(searchText), completionHandler: processResult)
                
            case .random:
                displaySearchBar = true
                Giphy.Sticker.request(.random(tag: searchText), completionHandler: processResult)
                
            default: return
            }
        }
    }
    
    func processResult(result: Any) {
        if let result = result as? GiphyRequestResult {
            if case .success(let images) = result {
                self.images = images.result
                self.updateUI()
            }
        }
        
        if let result = result as? GiphyRandomRequestResult {
            if case .success(let images) = result {
                self.images = images.result
                self.updateUI()
            }
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
        
        // NOTE: The Giphy API returns these URLs as HTTP - Here we convert them first to HTTPS
        if let image = image as? GiphyRandomImageResult {
            var urlComponents = URLComponents(string: image.images.fixedHeight.downsampled.gif.url)
            urlComponents?.scheme = "https"
            return urlComponents?.url
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else { return UICollectionReusableView() }
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
        reusableView.addSubview(searchBar)
        searchBar.sizeToFit()
        return reusableView
    }
    
}

extension CollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestImages(with: config, searchText: searchBar.text)
    }
}
