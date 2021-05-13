//
//  TMDBService.swift
//  TMDB
//
//  Created by Karthik Vadlamudi on 5/7/21.
//

import Foundation
import UIKit

public class TMDBService: NSObject {
    let queue: DispatchQueue
    init(queue: DispatchQueue) {
        self.queue = queue
    }

    func createError(message: String, code: Int) -> Error {
        return NSError(domain: "dataManager", code: code, userInfo: ["message": message])
    }

    func make(session: URLSession = URLSession.shared, request: URLRequest, closure: ((_ json: [String: Any]?, _ error: Error?)->Void)?) {
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.queue.async {
                let complete: (_ json: [String: Any]?, _ error: Error?) ->() = {
                    json, error in DispatchQueue.main.async {
                        closure?(json, error)
                    
                }}
                guard let self = self, error == nil else { complete(nil, error); return }
                guard let data = data else { complete(nil, self.createError(message: "No data", code: 999)); return }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        complete(json, nil)
                    }
                } catch let error { complete(nil, error); return }
            }
        }

        task.resume()
    }

    func searchRequest(term: String, page:Int, closure: ((_ json: [String: Any]?, _ error: Error?)->Void)?) {
        guard let url = URL(string: "\(TMDBUrl.kSearchBaseURL)\(TMDBUrl.kAPI_Search)\(TMDBUrl.kAPI_key)&query=\(term)&page=\(page)") else {
            return
        }
        let request = URLRequest(url: url)
        make(request: request) { json, error in closure?(json, error) }
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
