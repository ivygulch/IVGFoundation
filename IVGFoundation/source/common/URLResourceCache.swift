//
//  URLResourceCache.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/2/16.
//  Copyright © 2016 CR Tech. All rights reserved.
//

import Foundation

public enum URLResourceCacheError: ErrorType {
    case InvalidResponse(value: NSURLResponse?)
}

public class URLResourceCache {

    // MARK: - class functions

    // MARK: - public functions

    public init() {
    }

    public func doWithURL(url: NSURL?, expiration: NSDate?, completion: (NSData? -> Void)) {
        guard let url = url else {
            completion(nil)
            return
        }

        getData(withURL: url, expiration: expiration) {
            result in
            switch result {
            case .Success(let data):
                completion(data)
            case .Failure(let error):
                print("WARNING: error loading \(url): \(error)")
                completion(nil)
            }
        }
    }

    public func getData(withURL url: NSURL, expiration: NSDate?, completion: (Result<NSData> -> Void)) {
        if let expiration = expiration {
            flushURL(url, withExpiration: expiration)
        }

        if let cachedData = getCachedData(url) {
            completion(.Success(cachedData))
            return
        }


        let session = NSURLSession.sharedSession()

        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            [weak self] (data, response, error) in

            if let data = data {
                completion(.Success(data))
                self?.cacheData(data, withURL: url)
            } else if let error = error {
                completion(.Failure(error))
            } else {
                completion(.Failure(URLResourceCacheError.InvalidResponse(value: response)))
            }
        }
        
        task.resume()
    }

    // MARK: - private functions

    private func flushURL(url: NSURL, withExpiration expiration: NSDate) {
        do {
            try url.localFilename.removeLocallyCachedData(withExpiration: expiration)
        } catch (let error) {
            print("WARNING: Could not remove locally cached data at \(url): \(error)")
        }
    }

    private func cacheData(data: NSData, withURL url: NSURL) {
        synchronizer.execute {
            do {
                try url.localFilename.saveLocallyCachedData(data)
            } catch (let error) {
                print("WARNING: Could not save locally cached data at \(url): \(error)")
            }
        }
    }

    private func getCachedData(url: NSURL) -> NSData? {
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
    
    public func doWithImageURL(url: NSURL?, expiration: NSDate?, completion: (UIImage? -> Void)) {
        let urlCompletion: (NSData? -> Void) = { data in
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
        let cacheDirectory = try NSFileManager.defaultManager().cachesSubdirectory(String(URLResourceCache), create: shouldCreateDirectories)
        return cacheDirectory.stringByAppendingPathComponent(self)
    }

    func getLocallyCachedData() throws -> NSData? {
        return try NSData(contentsOfFile: localPath(createDirectories: false))
    }

    func removeLocallyCachedData(withExpiration expiration: NSDate) throws {
        let path = try localPath(createDirectories: false)
        guard NSFileManager.defaultManager().fileExistsAtPath(path) else {
            return
        }
        let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(path)
        guard let modifiedDate = attributes[NSFileModificationDate] as? NSDate else {
            print("WARNING: Could not get modificationDate for \(path): \(attributes)")
            return
        }
        if modifiedDate.compare(expiration) == .OrderedAscending {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        }
    }

    func saveLocallyCachedData(data: NSData) throws {
        try data.writeToFile(localPath(createDirectories: true), options: [.AtomicWrite])
    }

}