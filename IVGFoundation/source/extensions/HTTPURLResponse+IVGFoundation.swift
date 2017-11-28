//
//  HTTPURLResponse+IVGFoundation.swift
//  IVGFoundation
//
//  Created by Douglas Sjoquist on 11/28/17.
//  Copyright © 2017 Ivy Gulch. All rights reserved.
//

import Foundation

public struct HTTPURLResponseFields {
    public let httpVersion: String?
    public let statusCode: Int
    public let headerFields: [String: String]?
    public let responseData: Data?

    public init?(rawData: Data) {
        guard let string = String(data: rawData, encoding: .utf8) else { return nil }

        let lines = string.components(separatedBy: "\n")
        guard !lines.isEmpty else { return nil }

        var breakLineIndex: Int?
        var httpVersion: String?
        var statusCode: Int!
        var headerFields: [String: String] = [:]
        for (index,line) in lines.enumerated() {
            if index == 0 {
                let pieces = line.components(separatedBy: " ")
                httpVersion = pieces.first
                guard pieces.count > 1, let checkStatusCode = Int(pieces[1]) else { return nil }
                statusCode = checkStatusCode
            } else if line == "" {
                breakLineIndex = index
            } else {
                var pieces = line.components(separatedBy: ": ")
                let name = pieces.removeFirst()
                let value = pieces.joined(separator: ": ")
                headerFields[name] = value
            }
        }
        self.httpVersion = httpVersion
        self.statusCode = statusCode
        self.headerFields = headerFields.isEmpty ? nil : headerFields
        if let breakLineIndex = breakLineIndex,
            (breakLineIndex + 1) < lines.count {
            let bodyString = lines[(breakLineIndex + 1)..<lines.count].joined(separator: "\n")
            responseData = bodyString.data(using: .utf8)
        } else {
            responseData = nil
        }
    }

}

/*
 HTTP/1.1 400 Bad Request
 Server: nginx
 Date: Tue, 28 Nov 2017 15:37:36 GMT
 Content-Type: application/json
 Content-Length: 377
 Access-Control-Allow-Origin: https://sendgrid.api-docs.io
 Access-Control-Allow-Methods: POST
 Access-Control-Allow-Headers: Authorization, Content-Type, On-behalf-of, x-sg-elas-acl
 Access-Control-Max-Age: 600
 X-No-CORS-Reason: https://sendgrid.com/docs/Classroom/Basics/API/cors.html
 Expires: 0
 Cache-Control: no-cache
 Connection: Keep-alive

 {"errors":[{"message":"The from email does not contain a valid address.","field":"from.email","help":"http://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/errors.html#message.from"},{"message":"Does not contain a valid address.","field":"personalizations.0.to.0.email","help":"http://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/errors.html#message.personalizations.to"}]}
*/
