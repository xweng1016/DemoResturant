//
//  AddViewController.swift
//  testlastfinal
//
//  Created by Xi Weng on 2022-02-20.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var boroughAdd: UITextField!
    @IBOutlet weak var cusinieAdd: UITextField!
    @IBOutlet weak var nameAdd: UITextField!
    @IBOutlet weak var buildingAdd: UITextField!
    @IBOutlet weak var longitudeAdd: UITextField!
    @IBOutlet weak var latitudeAdd: UITextField!
    @IBOutlet weak var streetAdd: UITextField!
    @IBOutlet weak var zipCodeAdd: UITextField!
    @IBOutlet weak var dateAdd: UITextField!
    @IBOutlet weak var scoreAdd: UITextField!
    @IBOutlet weak var gradeAdd: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveAddedResturant(_ sender: Any) {
        
        guard let url = URL(string: "https://interview-app-2022.herokuapp.com/api/restaurants") else {
               print("Error: cannot create URL")
               return
           }
        
        struct UploadResturantData: Codable{
            var address: Address?
            var borough: String?
            var cuisine: String?
            var grade: [Grades]?
            var name: String?
            var _id: String?
            
        }

        struct Address: Codable {
            var building: String?
            var coord: [Double]?
            var street: String?
            var zipcode: String?
        }

        struct Grades: Codable{
            var date: Date?
            var grade: String?
            var score: Double?
        }

           
//        let _grades = Grades(date: Date.now, grade: gradeAdd.text, score: Double(scoreAdd.text ?? "0"))
//        let _address = Address(building: buildingAdd.text, coord: []), street: streetAdd.text, zipcode: zipCodeAdd.text)
//
//        let _uploadResturantData = UploadResturantData(address: _address, borough: boroughAdd.text, cuisine: cusinieAdd.text, grade: _grades, name: nameAdd.text, _id: UUID().uuidString)
//           // Add data to the model
//
//           // Convert model to JSON data
//           guard let jsonData = try? JSONEncoder().encode(_uploadResturantData) else {
//               print("Error: Trying to convert model to JSON data")
//               return
//           }
           // Create the url request
//           var request = URLRequest(url: url)
//           request.httpMethod = "POST"
//           request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
//           request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
//           request.httpBody = jsonData
//           URLSession.shared.dataTask(with: request) { data, response, error in
//               guard error == nil else {
//                   print("Error: error calling POST")
//                   print(error!)
//                   return
//               }
//               guard let data = data else {
//                   print("Error: Did not receive data")
//                   return
//               }
//               guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                   print("Error: HTTP request failed")
//                   return
//               }
//               do {
//                   guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                       print("Error: Cannot convert data to JSON object")
//                       return
//                   }
//                   guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
//                       print("Error: Cannot convert JSON object to Pretty JSON data")
//                       return
//                   }
//                   guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
//                       print("Error: Couldn't print JSON in String")
//                       return
//                   }
//
//                   print(prettyPrintedJson)
//               } catch {
//                   print("Error: Trying to convert JSON data to string")
//                   return
//               }
//           }.resume()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
