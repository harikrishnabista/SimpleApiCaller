//
//  ApiCaller.swift
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

enum NetworkRequestType : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum APIResult<T> {
    case success(T)
    case failure(Error)
}

public typealias APITaskCompletionHandler<T> = (APIResult<T>) -> Void

class ApiCaller<ResponseType:Decodable> {
    
    private class DefaultEncodable: Encodable {
        
    }
    
    func callApi(url:URL, requestType:NetworkRequestType = .GET, completion: @escaping APITaskCompletionHandler<ResponseType>) {
        self.callApi(url: url, postModel: DefaultEncodable(), completion: completion)
    }
    
    func callApi<PostModelType:Encodable>(url:URL, postModel:PostModelType, requestType:NetworkRequestType = .GET, completion: @escaping APITaskCompletionHandler<ResponseType>) {
        
        var urlRequest = URLRequest(url: url)

//        if let usertoken = NetworkDataHelper.shared.userToken {
//            urlRequest.allHTTPHeaderFields = ["Authorization":usertoken.userToken]
//        }
        
        if requestType == .POST {
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpMethod = NetworkRequestType.POST.rawValue

            if let jsonData = try? JSONEncoder().encode(postModel) {
                urlRequest.httpBody = jsonData
            }
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
            
            do {
                if let data = data, err == nil {
                    let returnObj = try JSONDecoder().decode(ResponseType.self, from: data)
                    completion(APIResult.success(returnObj))
                } else {
                    completion(APIResult.failure(err!))
                }
            
            } catch _ {
                if let err = err {
                    completion(APIResult.failure(err))
                }
            }
        }

        task.resume()
    }
}
