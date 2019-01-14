//
//  JSONable.swift
//  Revolut
//
//  Created by Natalia Nikitina on 13/01/2019.
//  Copyright © 2019 Natalia Nikitina. All rights reserved.
//

import SwiftyJSON

protocol JSONable {
	static func fromJSON(_ json: JSON) -> Self?
}
