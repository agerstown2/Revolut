//
//  NetworkingManager.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Alamofire

final class NetworkingManager {
	func request(router: URLRouter, completion: @escaping (_ response: DataResponse<Data>) -> Void) {
		Alamofire.request(router,
			method: router.method,
			parameters: router.args,
			encoding: URLEncoding.default,
			headers: router.headers
		)
		.responseData(completionHandler: completion)
	}
}

extension DataResponse {
	func decode<T: Decodable>() -> ValueResult<T> {
		guard let data = data else {
			return .error(result.error ?? CustomError(description: "Undefined error"))
		}

		guard let jsonData = try? JSONDecoder().decode(T.self, from: data) else {
			return .error(CustomError(description: "Unable to parse json data"))
		}

		return .value(jsonData)
	}
}
