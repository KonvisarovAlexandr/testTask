//
//  Extencions.swift
//  RickAndMorty

import Foundation
import UIKit
fileprivate let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String?, completion:((UIImage?) -> Void)? = nil) {
        guard let str = urlString,
              let url = URL(string: str)
        else {
            return
        }
        image = nil
        if let cachedImage = imageCache.object(forKey: str as NSString)  {
            image = cachedImage
            completion?(cachedImage)
            return
        }
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    activityIndicator.removeFromSuperview()
                }
                print(error)
                completion?(nil)
                return
            }
            
            DispatchQueue.main.async {
                var imageContainer:UIImage? = nil
                if let data = data,
                   let image = UIImage(data: data)
                {
                    imageCache.setObject(image, forKey: str as NSString)
                    self.image = image
                    imageContainer = image
                }
                completion?(imageContainer)
                activityIndicator.removeFromSuperview()
            }
        }).resume()
    }
}


extension UIImage{
    func convertImageToData() -> Data {
        let data = self.jpegData(compressionQuality: 1.0) ?? Data()
        return data
    }
}
