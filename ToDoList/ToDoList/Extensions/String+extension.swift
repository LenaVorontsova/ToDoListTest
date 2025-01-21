//
//  String+extension.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
    func getStringByKey() -> String {
        let key = self
        let path = Bundle.current.path(forResource: "ru", ofType: "lproj")
        ?? Bundle.current.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return  (bundle?.localizedString(forKey: key, value: nil, table: nil))!
    }
}

extension Bundle {
    public static var current: Bundle {
        return Bundle(for: BundleChecker.self)
    }
}

class BundleChecker { }
