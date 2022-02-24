//
//  Fun.swift
//  testlastfinal
//
//  Created by Xi Weng on 2022-02-22.
//

import Foundation
import UIKit

//conver to json
func convertToJsonData(data:Any) -> String {
    if (data is NSDictionary) == false &&  (data is NSArray) == false{
        return "{\"error\":\"json error\"}"
    }
    var jsonData = Data()
    do{
        try  jsonData = JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
    }catch{
        print(error)
        return "{\"error\":\"json error\"}"
    }
    var jsonString =  String(data: jsonData, encoding: String.Encoding.utf8) ?? "{\"error\":\"json error\"}"
    jsonString = jsonString.replacingOccurrences(of: " ", with: "", options: String.CompareOptions.literal, range: jsonString.startIndex..<jsonString.endIndex)
    jsonString = jsonString.replacingOccurrences(of: "\n", with: "", options: String.CompareOptions.literal, range: jsonString.startIndex..<jsonString.endIndex)
    return jsonString
}

//show Alert viewController
func showAlertVC(message:String)  {
    DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        let action =  UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(action)
        if let rootVC = UIApplication.shared.windows.first?.rootViewController{
            
            rootVC.present(alertVC, animated: true, completion: nil)
        }
    }
    
}
