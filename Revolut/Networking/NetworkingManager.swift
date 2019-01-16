//
//  NetworkingManager.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class NetworkingManager {

	static let shared = NetworkingManager()

	func request(router: URLRouter, completion: @escaping (_ response: DataResponse<Any>) -> Void) {
		Alamofire.request(
			router,
			method: router.method,
			parameters: router.args,
			encoding: URLEncoding.default,
			headers: router.headers
		)
		.responseJSON(completionHandler: completion)
	}
}

extension DataResponse {
	var jsonData: ValueResult<JSON> {
		if let value = result.value {
			return .value(JSON(value))
		} else {
			return .error(result.error ?? CustomError(description: "Undefined error"))
		}
	}
}
