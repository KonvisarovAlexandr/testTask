//
//  Extencions.swift
//  RickAndMorty

import Foundation
import UIKit
fileprivate let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String?, completion:(() -> Void)? = nil) {
        guard let str = urlString,
              let url = URL(string: str)
        else {
            return
        }
        image = nil
        if let cachedImage = imageCache.object(forKey: str as NSString)  {
            image = cachedImage
            completion?()
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
                completion?()
                return
            }
            
            DispatchQueue.main.async {
                if let data = data,
                   let image = UIImage(data: data)
                {
                    imageCache.setObject(image, forKey: str as NSString)
                    self.image = image
                }
                completion?()
                activityIndicator.removeFromSuperview()
            }
        }).resume()
    }
}
