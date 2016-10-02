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

    var cache: [NSURL: NSData] = [:]
    var cacheOrder: [NSURL] = []
    var cacheExpiration: [NSURL: NSDate] = [:]
    let maximumSize: Int
    let synchronizer = Synchronizer()

    public init(maximumMegabytes: Int) {
        maximumSize = maximumMegabytes * 1024 * 1024
    }

    private func flushCache() {
        synchronizer.execute {
            self.flushExpiredURLs()
            self.flushToMaximumSize()
        }
    }

    private func flushURL(url: NSURL) {
        cache[url] = nil
        cacheExpiration[url] = nil
        if let index = cacheOrder.indexOf(url) {
            cacheOrder.removeAtIndex(index)
        }
    }

    private func flushExpiredURLs() {
        let flushDate = Clock.sharedClock.currentDate
        let urls = Array(cache.keys)
        for url in urls {
            if let expirationDate = cacheExpiration[url] where expirationDate.compare(flushDate) == .OrderedAscending {
                print("DBG: expired, flush\(url)")
                flushURL(url)
            }
        }
    }

    private func flushToMaximumSize() {
        let urls = cacheOrder.reverse()
        var totalCacheSize: Int = 0
        var reachedMaximumSize = false
        for url in urls {
            if reachedMaximumSize {
                print("DBG: reachedMaximumSize.1, flush\(url)")
                flushURL(url)
            } else if let data = cache[url] {
                totalCacheSize += data.length
                reachedMaximumSize = totalCacheSize > maximumSize
                if reachedMaximumSize {
                    print("DBG: reachedMaximumSize.2, flush\(url)")
                    flushURL(url)
                }
            }
        }
    }

    private func cacheData(data: NSData, withURL url: NSURL, requestDate: NSDate, expiration: NSTimeInterval?) {
        synchronizer.execute {
            if self.cache[url] != nil {
                if let index = self.cacheOrder.indexOf(url) {
                    self.cacheOrder.removeAtIndex(index)
                }
            }
            self.cacheOrder.append(url)
            self.cache[url] = data
            if let expiration = expiration {
                let expirationDate = requestDate.dateByAddingTimeInterval(expiration)
                self.cacheExpiration[url] = expirationDate
            } else {
                self.cacheExpiration[url] = nil
            }
        }
    }

    private func getCachedData(url: NSURL) -> NSData? {
        return synchronizer.valueOf {
            return self.cache[url]
        }
    }

    public func getData(withURL url: NSURL, expiration: NSTimeInterval? = nil, completion: (Result<NSData> -> Void)) {
        flushCache()
        if let cachedData = getCachedData(url) {
            completion(.Success(cachedData))
            return
        }

        let requestDate = Clock.sharedClock.currentDate

        let session = NSURLSession.sharedSession()

        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            [weak self] (data, response, error) in

            if let data = data {
                completion(.Success(data))
                self?.cacheData(data, withURL: url, requestDate: requestDate, expiration: expiration)
            } else if let error = error {
                completion(.Failure(error))
            } else {
                completion(.Failure(URLResourceCacheError.InvalidResponse(value: response)))
            }
        }

        task.resume()
    }

}