//
//  NetworkManager.swift
//  Showerss
//
//  Created by M sai deepthi on 11/08/24.
//

import Foundation

struct NetworkManager {
    let url: String
    typealias Completion = (Result<Data,Error>) -> Void
    init(url: String) {
        self.url = url
    }
    func DownloadDataFromURL(completion: @escaping Completion) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.inValidURL))
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.noData))
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    enum NetworkError: Error {
        case noData
        case inValidURL
    }
}
