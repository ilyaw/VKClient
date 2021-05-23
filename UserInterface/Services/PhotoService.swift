//
//  PhotoService.swift
//  UserInterface
//
//  Created by Ilya on 22.05.2021.
//

import Foundation
import PromiseKit
import Alamofire

class ThreadSafeMemoryCache {
    private let queue = DispatchQueue(label: "ru.geekbrains.cache.vk", attributes: .concurrent)
    
    var cache = [String: UIImage]()
    
    func get(for key: String) -> UIImage? {
        var image: UIImage?
        queue.sync {
            image = self.cache[key]
        }
        return image
    }
    
    func set(image: UIImage?, for key: String) {
        queue.async(flags: .barrier) {
            self.cache[key] = image
        }
    }
}

class PhotoService {
    
    private let cacheLifetime: TimeInterval = 60 * 60 * 24 * 7
    private static var memoryCache = ThreadSafeMemoryCache()
    static let shared = PhotoService()
    
    private init() {}
    
    private var imageCacheUrl: URL? {
        let dirname = "Images"
        
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let url = cacheDir.appendingPathComponent(dirname, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        
        return url
    }
    
    private func getFilePath(urlString: String) -> URL? {
        let filename = urlString.split(separator: "/").last ?? "default.png"
        guard let imageCacheUrl = self.imageCacheUrl else { return nil }
        return imageCacheUrl.appendingPathComponent(String(filename))
    }
    
    private func saveImageToFilesystem(urlString: String, image: UIImage) {
        guard let data = image.pngData(),
              let fileUrl = getFilePath(urlString: urlString) else { return }
        
        try? data.write(to: fileUrl)
    }
    
    private func loadImageFromFilesystem(urlString: String) -> UIImage? {
        guard let fileUrl = getFilePath(urlString: urlString),
              let info = try? FileManager.default.attributesOfItem(atPath: fileUrl.path),
              let modificationDate = info[.modificationDate] as? Date,
              cacheLifetime > Date().distance(to: modificationDate),
              let image = UIImage(contentsOfFile: fileUrl.path) else { return nil }
        
        DispatchQueue.global().async {
            PhotoService.memoryCache.set(image: image, for: urlString)
        }
        
        return image
    }
    
    private func loadImage(urlString: String, saveFilesystem: Bool) -> Promise<UIImage> {
        let promise = Promise<Data>(resolver: { resolver -> Void in
            Alamofire.request(urlString).responseData(queue: .global()) { response in
                switch response.result {
                case let .success(data):
                    resolver.fulfill(data)
                case let .failure(error):
                    resolver.reject(error)
                }
            }
        })
        
        return promise
            .map {
                guard let image = UIImage(data: $0) else { throw PMKError.badInput };
                return image
            }
            .get(on: .global()) {
                PhotoService.memoryCache.set(image: $0, for: urlString)
            }
            .get {
                if saveFilesystem {
                    self.saveImageToFilesystem(urlString: urlString, image: $0)
                }
            }
    }
    
    public func photo(urlString: String, filesystem: Bool = true) -> Promise<UIImage>  {
        return Promise.value(urlString)
            .then(on: .global()) { url -> Promise<UIImage> in
                if let image = PhotoService.memoryCache.get(for: urlString) {
                    return Promise.value(image)
                }
                
                if filesystem, let image = self.loadImageFromFilesystem(urlString: urlString) {
                    return Promise.value(image)
                }
                
                return self.loadImage(urlString: urlString, saveFilesystem: filesystem)
            }
    }
}
