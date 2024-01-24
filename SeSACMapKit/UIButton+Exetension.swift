//
//  UIButton+Exetension.swift
//  SeSACMapKit
//
//  Created by ungQ on 1/24/24.
//

import UIKit

extension UIButton.Configuration {
	
	static func currentLocationStyle() -> UIButton.Configuration {
		
		var config = UIButton.Configuration.filled()
		config.image = UIImage(systemName: "location.circle.fill")
		config.cornerStyle = .capsule

		
		return config
	}
	
}
