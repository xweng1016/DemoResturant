//
//  UpdateViewController.swift
//  testlastfinal
//
//  Created by Xi Weng on 2022-02-20.
//

import UIKit

class UpdateViewController: UIViewController {
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var buildingTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var cuisineTF: UITextField!
    @IBOutlet weak var restaurant_idTF: UITextField!
    @IBOutlet weak var boroughTF: UITextField!
    
    @IBOutlet weak var gradeTF: UITextField!
    @IBOutlet weak var scoreTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    var isAdd = true
    lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle  = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = UIDatePicker.Mode.date
        //        datePicker.timeZone = TimeZone.current
        //        datePicker.calendar = Calendar.current
        return datePicker
    }()
    var resturant:ResturantData?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let resturant = resturant{
            self.title = "Update"
            self.isAdd = false
            nameTF.text = resturant.name
            cuisineTF.text = resturant.cuisine
            restaurant_idTF.text = resturant.restaurant_id
            boroughTF.text = resturant.borough
            if let address = resturant.address{
                buildingTF.text = address.building
                streetTF.text = address.street
                zipcodeTF.text = address.zipcode
                
                let lat = address.coord![0]
                let long = address.coord![1]
                latitudeTF.text = "\(lat)"
                longitudeTF.text = "\(long)"
                if let grade = resturant.grades?.first {
                    gradeTF.text = grade.grade
                    scoreTF.text = "\(grade.score ?? 0)"
                    dateTF.text = grade.date
                }
            }
            
        }else{
            self.title = "Add"
            self.isAdd = true
            
        }
        //键盘设置,
        //设置dateTF的输入view
        dateTF.inputView = datePicker
        
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: KScreenW, height: 40))
        let cancelItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelKeyBoard))
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let sureItem = UIBarButtonItem.init(title: "ok", style: .plain, target: self, action: #selector(sureKeyBoard))
        toolBar.setItems([cancelItem,spaceItem,sureItem], animated: true)
        // 设置键盘顶部的取消和确认按钮
        dateTF.inputAccessoryView = toolBar
    }
    
    @objc func cancelKeyBoard(){
        dateTF.resignFirstResponder()
    }
    //sure date
    @objc func sureKeyBoard(){
        let selDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let str = formatter.string(for:selDate)
        dateTF.text = str! + "T00:00:00.000Z"
        dateTF.resignFirstResponder()
        
    }
    @IBAction func didClickSave(_ sender: Any) {
        //1latitude
        guard latitudeTF.text!.isEmpty == false,
              let latitude = Double(latitudeTF.text!),
              latitude >= -90,
              latitude <= 90 else {
                  showAlertVC(message: "Latitude error")
                  return
              }
        //2longitude
        guard longitudeTF.text!.isEmpty == false,
              let longitude = Double(longitudeTF.text!),
              longitude >= -180,
              longitude <= 180  else {
                  showAlertVC(message: "Longitude error")
                  return
              }
        //3building
        guard let building = buildingTF.text,
              building.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Building error")
                  return
              }
        
        //4street
        guard let street = streetTF.text,
              street.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Street error")
                  return
              }
        //5zipcode
        guard let zipcode = zipcodeTF.text,
              zipcode.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Zipcode error")
                  return
              }
        
        //6 name
        guard let name = nameTF.text,
              name.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Name error")
                  return
              }
        //7 cuisineTF
        guard let cuisine = cuisineTF.text,
              cuisine.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Cuisine error")
                  return
              }
        //8 restaurant_idTF
        guard let restaurant_id = restaurant_idTF.text,
              restaurant_id.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Restaurant_id error")
                  return
              }
        //9 boroughTF
        guard let borough = boroughTF.text,
              borough.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Borough error")
                  return
              }
        //10 grade
        guard let gradeValue = gradeTF.text,
              gradeValue.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Grade error")
                  return
              }
        //11 scoreTF
        guard scoreTF.text!.isEmpty == false,
              let score = Double(scoreTF.text!),
              score >= 0 else {
                  showAlertVC(message: "Score error")
                  return
              }
        
        //12 dateTF
        guard let date = dateTF.text,
              date.replacingOccurrences(of: " ", with: "").isEmpty == false else {
                  showAlertVC(message: "Date error")
                  return
              }
        
        var gradesTemp:[Grade]!
        if let rest = resturant,
           var grades = rest.grades,
           let grade = grades.first{
            //Update
            grades[0] = Grade(date: date, grade: gradeValue, score: score,_id:grade._id)
            gradesTemp = grades
        }else{
            //Add
            gradesTemp = [Grade(date: date, grade: gradeValue, score: score,_id:nil)]
            
        }
        
        let address = Address(building: building, coord: [latitude,longitude], street: street, zipcode: zipcode)
        let resturantData = ResturantData(address: address, borough: borough, cuisine: cuisine, grades: gradesTemp, name: name, _id: nil, restaurant_id: restaurant_id)
        
        
        
        var request:URLRequest!
        if let rest = resturant {
            //Update
            let apiEndpoint = "https://interview-app-2022.herokuapp.com/api/restaurants/\(rest._id!)"
            request = URLRequest(url: URL(string: apiEndpoint)!)
            request.httpMethod = "PUT"
            request.httpBody = try! JSONEncoder().encode(resturantData)
        }else{
            //Add
            let apiEndpoint  = "https://interview-app-2022.herokuapp.com/api/restaurants"
            request = URLRequest(url: URL(string: apiEndpoint)!)
            request.httpMethod = "POST"
            request.httpBody = try! JSONEncoder().encode(resturantData)
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        NetAnimationView.show()
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            NetAnimationView.diss()
            if let err = error {
                print(err)
                showAlertVC(message: err.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                showAlertVC(message: "Save error")
                return
            }
            guard let jsonData = data else {
                showAlertVC(message: "Save error")
                return
            }
            let jsonDict = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
            print("json:\(convertToJsonData(data: jsonDict))")
            //1Add 判断数据符合要求
            if self.isAdd {
                if let jsonDict = jsonDict as? [String : Any],
                   let message = jsonDict["message"] as? [String : Any],
                   let _id = message["_id"] as? String,
                   _id.isEmpty == false {
                    showAlertVC(message: "Add success")
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RefreshHomeData"), object: nil)
                }else{
                    showAlertVC(message: "Add error")
                }
            }else{
                //2Update 判断数据符合要求
                if let jsonDict = jsonDict as? [String : Any],
                   let message = jsonDict["message"] as? [String : Any],
                   let acknowledged = message["acknowledged"] as? Bool,
                   acknowledged == true {
                    showAlertVC(message: "Update success")
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RefreshHomeData"), object: nil)
                }else{
                    showAlertVC(message: "Update Error")
                }
            }
            
        }
        dataTask.resume()
    }
    
    
    
}



