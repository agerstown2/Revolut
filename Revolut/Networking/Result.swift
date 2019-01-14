//
//  Result.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

enum Result {
	case success
	case error(Error)
}

enum ValueResult<A> {
	case value(A)
	case error(Error)
}
