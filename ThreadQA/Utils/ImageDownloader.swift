//
//  ImageDownloader.swift
//  ThreadQA
//
//  Created by Maxim Makarov on 07.01.2026.
//


import UIKit

class ImageDownloader {
    
    static let shared = ImageDownloader()
    
    // Кеш для изображений
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        // Настройка кеша
        imageCache.countLimit = 100 // Максимум 100 изображений в кеше
        imageCache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    // MARK: - Public Methods
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        // Проверяем кеш
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            print("📱 IMAGE FROM CACHE: \(url)")
            completion(cachedImage)
            return
        }
        
        guard let imageURL = URL(string: url) else {
            print("❌ Invalid image URL: \(url)")
            completion(nil)
            return
        }
        
        print("🌐 DOWNLOADING IMAGE: \(url)")
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            if let error = error {
                print("🔴 IMAGE DOWNLOAD ERROR: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("❌ Failed to create image from data for URL: \(url)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Сохраняем в кеш
            self?.imageCache.setObject(image, forKey: url as NSString)
            print("✅ IMAGE DOWNLOADED & CACHED: \(data.count) bytes")
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    // MARK: - Cache Management
    
    func clearCache() {
        imageCache.removeAllObjects()
        print("🗑️ Image cache cleared")
    }
    
    func getCacheInfo() -> (count: Int, totalCost: Int) {
        return (count: imageCache.countLimit, totalCost: imageCache.totalCostLimit)
    }
}

// MARK: - UIImageView Extension

extension UIImageView {
    
    func loadImage(from url: String, placeholder: UIImage? = nil) {
        // Устанавливаем placeholder
        if let placeholder = placeholder {
            self.image = placeholder
        } else {
            self.image = UIImage(systemName: "person.circle.fill")
        }
        
        // Загружаем изображение
        ImageDownloader.shared.downloadImage(from: url) { [weak self] image in
            self?.image = image ?? placeholder ?? UIImage(systemName: "person.circle.fill")
        }
    }
}
