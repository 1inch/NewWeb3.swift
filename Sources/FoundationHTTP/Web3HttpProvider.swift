//
//  Web3HttpProvider.swift
//  Web3
//
//  Created by Koray Koska on 17.02.18.
//

import Foundation
import Dispatch
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class Web3HttpProvider: Web3Provider {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let queue: DispatchQueue

    let session: URLSession

    static let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]

    public let rpcURL: String
    private let defaultRetryInterval: TimeInterval = 2
    private let retryCount: Int

    public init(rpcURL: String, session: URLSession = URLSession(configuration: .default), retryCount: Int = 3) {
        self.rpcURL = rpcURL
        self.session = session
        self.retryCount = retryCount
        // Concurrent queue for faster concurrent requests
        self.queue = DispatchQueue(label: "Web3HttpProvider", attributes: .concurrent)
    }

    public func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>) {
        queue.async {
            
            let body: Data
            do {
                body = try self.encoder.encode(request)
            } catch {
                let err = Web3Response<Result>(error: .requestFailed(error))
                response(err)
                return
            }

            guard let url = URL(string: self.rpcURL) else {
                let err = Web3Response<Result>(error: .requestFailed(nil))
                response(err)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            for (k, v) in type(of: self).headers {
                request.addValue(v, forHTTPHeaderField: k)
            }

            self.performRequest(request, retries: self.retryCount, completion: response)
        }
    }

    private func performRequest<Result>(
        _ request: URLRequest,
        retries: Int,
        completion: @escaping Web3ResponseCompletion<Result>
    ) {
        let task = self.session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            let retriesLeft = max(0, retries - 1)

            guard let urlResponse = response as? HTTPURLResponse, let data = data, error == nil else {
                if retriesLeft > 0 {
                    self.queue.asyncAfter(deadline: .now() + self.defaultRetryInterval) { [weak self] in
                        self?.performRequest(request, retries: retriesLeft, completion: completion)
                    }
                } else {
                    completion(Web3Response<Result>(error: .serverError(error)))
                }
                return
            }

            let delay = urlResponse.retryAfter ?? self.defaultRetryInterval
            let status = urlResponse.statusCode
            guard status >= 200 && status < 300 else {
                // This is a non typical rpc error response and should be considered a server error.
                if retriesLeft > 0 {
                    self.queue.asyncAfter(deadline: .now() + delay) { [weak self] in
                        self?.performRequest(request, retries: retriesLeft, completion: completion)
                    }
                } else {
                    completion(Web3Response<Result>(error: .serverError(error)))
                }
                return
            }

            do {
                let rpcResponse = try self.decoder.decode(RPCResponse<Result>.self, from: data)
                let response = Web3Response(rpcResponse: rpcResponse)
                completion(response)
            } catch {
                if retriesLeft > 0 {
                    self.queue.asyncAfter(deadline: .now() + delay) { [weak self] in
                        self?.performRequest(request, retries: retriesLeft, completion: completion)
                    }
                } else {
                    completion(Web3Response<Result>(error: .decodingError(error)))
                }
            }
        }
        task.resume()
    }
}

private extension HTTPURLResponse {
    var retryAfter: TimeInterval? {
        let retryAfterHeaderKey = "Retry-After"
        if let retryAfter = allHeaderFields[retryAfterHeaderKey] {
            if let retryAfterSeconds = (retryAfter as? NSNumber)?.doubleValue {
                return retryAfterSeconds
            }

            if let retryAfterString = retryAfter as? String {
                if let retryAfterSeconds = Double(retryAfterString), retryAfterSeconds > 0 {
                    return retryAfterSeconds
                }

                let date = HTTPURLResponse.httpDateFormatter.date(from: retryAfterString)
                let currentTime = CFAbsoluteTimeGetCurrent()
                if let retryAbsoluteTime = date?.timeIntervalSinceReferenceDate, currentTime < retryAbsoluteTime {
                    return retryAbsoluteTime - currentTime
                }
            }
        }
        return nil
    }

    private static var httpDateFormatter: DateFormatter = {
        // https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After#Examples
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return dateFormatter
    }()
}
