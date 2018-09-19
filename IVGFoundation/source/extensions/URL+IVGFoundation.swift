//
//  URL+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 10/11/16.
//  Copyright © 2016 Ivy Gulch. All rights reserved.
//

import Foundation

public extension URL {

    private struct AssociatedKey {
        static var invalidFilenameCharacterSet = "invalidFilenameCharacterSet"
    }

    private var invalidFilenameCharacterSet: CharacterSet {
        get {
            if let result = objc_getAssociatedObject(self, &AssociatedKey.invalidFilenameCharacterSet) as? CharacterSet {
                return result
            }
            let result = NSMutableCharacterSet(charactersIn: ": /")
            result.formUnion(with: CharacterSet.newlines)
            result.formUnion(with: CharacterSet.illegalCharacters)
            result.formUnion(with: CharacterSet.controlCharacters)

            objc_setAssociatedObject(self, &AssociatedKey.invalidFilenameCharacterSet, result, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result as CharacterSet
        }
    }

    var localFilename: String {
        return absoluteString.components(separatedBy: invalidFilenameCharacterSet).joined(separator: "_")
    }

    public func loadData(completion: @escaping  ((Result<Data>) -> Void)) {
        let session = URLSession.shared

        let request = URLRequest(url: self)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    completion(.success(data))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(URLResourceCacheError.invalidResponse(value: response)))
                }
            }
        })

        task.resume()
    }

}
