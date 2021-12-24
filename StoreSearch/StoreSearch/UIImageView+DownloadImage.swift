//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Islam Abd El Hakim on 18/12/2021.
//

import UIKit
// extention means : extend the ability of existing class without subclass even to the system framework classes
extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    let downloadTask = session.downloadTask(with: url) {
      [weak self] url, _, error in // this url in closure points to local file location url where file was downloaded in atemporary location
      if error == nil, let url = url,
          let data = try? Data(contentsOf: url),   // 3
         let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image // sets imageView's image prperty to the created image from data downloaded
          }
        }
      }
    }
    downloadTask.resume()
    return downloadTask
  }
}
