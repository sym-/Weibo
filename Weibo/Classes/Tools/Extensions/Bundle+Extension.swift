//
//  Bundle+Extension.swift
//  Weibo
//
//  Created by 宋元明 on 16/11/15.
//  Copyright © 2016年 宋元明. All rights reserved.
//

import Foundation

extension Bundle{
    var namespace : String{
        return (infoDictionary?["CFBundleName"] as? String) ?? ""
    }
}
