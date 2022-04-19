//
//  UIImageExtension.swift
//  Pokedex
//
//  Created by miniMAC Sferea on 19/04/22.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageURLString: String?
    
    func downloaded(from url: URL?, contentMode mode: ContentMode = .scaleAspectFit,retries: Int = 3,authorization: Bool = true) {
        image = #imageLiteral(resourceName: "logo_pokemon")
        contentMode = .scaleAspectFit
        guard let url = url else { return }
        
        imageURLString = url.absoluteString
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage{
            self.contentMode = mode
            loadFade(cachedImage)
        }
        
        
        let urlResquest = Api.makeURLRequest(url: url)
        
        Api.request(url: urlResquest) { [weak self] (data, error) in
            guard error == .success,let info = data,let image = UIImage(data: info) else{
                if retries > 0{
                    DispatchQueue.main.async {
                        self?.downloaded(from: url,retries: retries - 1)
                    }
                    
                }
                return
            }
            DispatchQueue.main.async() {
                if self?.imageURLString == url.absoluteString{
                    self?.contentMode = mode
                    self?.loadFade(image)
                }
                
                imageCache.setObject(image, forKey: url as AnyObject)
                
                
            }
        }
        
    }
    
    func loadFade(_ image: UIImage){
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
    
}
