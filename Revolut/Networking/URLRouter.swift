//
//  URLRouter.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import Alamofire

protocol URLRouter: URLConvertible {
	var method: HTTPMethod { get }
	var path: String { get }
	var args: Parameters? { get }
	var headers: [String: String] { get }
}

extension URLRouter {
	var method: HTTPMethod {
		return .get
	}

	var args: Parameters? {
		return nil
	}

	var headers: [String: String] {
		return [:]
	}
}

extension URLRouter {
	func asURL() throws -> URL {
		return try ("https://revolut.duckdns.org/" + path).asURL()
	}
}
