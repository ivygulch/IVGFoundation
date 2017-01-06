//
//  URLResourceCache.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/2/16.
//  Copyright © 2016 CR Tech. All rights reserved.
//

import Foundation

public enum URLResourceCacheError: Error {
    case invalidResponse(value: URLResponse?)
}

public class URLResourceCache {

    // MARK: - class functions

    // MARK: - public functions

    public init() {
    }

    public func doWithURL(_ url: URL?, expiration: Date?, completion:@escaping  ((Data?) -> Void)) {
        guard let url = url else {
            completion(nil)
            return
        }

        getData(withURL: url, expiration: expiration) {
            result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("WARNING: error loading \(url): \(error)")
                completion(nil)
            }
        }
    }

    public func getData(withURL url: URL, expiration: Date?, completion: @escaping ((Result<Data>) -> Void)) {
        if let expiration = expiration {
            flushURL(url, withExpiration: expiration)
        }

        if let cachedData = getCachedData(url) {
            completion(.success(cachedData))
            return
        }


        let session = URLSession.shared

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: {
            [weak self] (data, response, error) in

            if let data = data {
                completion(.success(data))
                self?.cacheData(data, withURL: url)
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(URLResourceCacheError.invalidResponse(value: response)))
            }
        }) 
        
        task.resume()
    }

    // MARK: - private functions

    private func flushURL(_ url: URL, withExpiration expiration: Date) {
        do {
            try url.localFilename.removeLocallyCachedData(withExpiration: expiration)
        } catch (let error) {
            print("WARNING: Could not remove locally cached data at \(url): \(error)")
        }
    }

    private func cacheData(_ data: Data, withURL url: URL) {
        synchronizer.execute {
            do {
                try url.localFilename.saveLocallyCachedData(data)
            } catch (let error) {
                print("WARNING: Could not save locally cached data at \(url): \(error)")
            }
        }
    }

    private func getCachedData(_ url: URL) -> Data? {
        return synchronizer.valueOf {
            do {
                return try url.localFilename.getLocallyCachedData()
            } catch (let error) {
                print("WARNING: Could not get locally cached data at \(url): \(error)")
            }
            return nil
        }
    }

    // MARK: - private variables

    let synchronizer = Synchronizer()
    
}

public extension URLResourceCache {
    
    public func doWithImageURL(_ url: URL?, expiration: Date?, completion: @escaping ((UIImage?) -> Void)) {
        let urlCompletion: ((Data?) -> Void) = { data in
            if let data = data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }
        doWithURL(url, expiration: expiration, completion: urlCompletion)
    }

}

private extension String {

    func localPath(createDirectories shouldCreateDirectories: Bool) throws -> String {
        let cacheDirectory = try FileManager.default.cachesSubdirectory(String(describing: URLResourceCache.self), create: shouldCreateDirectories)
        return cacheDirectory.stringByAppendingPathComponent(self)
    }

    func getLocallyCachedData() throws -> Data? {
        return try Data(contentsOf: URL(fileURLWithPath: localPath(createDirectories: false)))
    }

    func removeLocallyCachedData(withExpiration expiration: Date) throws {
        let path = try localPath(createDirectories: false)
        guard FileManager.default.fileExists(atPath: path) else {
            return
        }
        let attributes = try FileManager.default.attributesOfItem(atPath: path)
        guard let modifiedDate = attributes[FileAttributeKey.modificationDate] as? Date else {
            print("WARNING: Could not get modificationDate for \(path): \(attributes)")
            return
        }
        if modifiedDate.compare(expiration) == .orderedAscending {
            try FileManager.default.removeItem(atPath: path)
        }
    }

    func saveLocallyCachedData(_ data: Data) throws {
        try data.write(to: URL(fileURLWithPath: localPath(createDirectories: true)), options: [.atomicWrite])
    }

}
