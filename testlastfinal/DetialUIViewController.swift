//
//  DetialUIViewController.swift
//  testlastfinal
//
//  Created by Xi Weng on 2022-02-20.
//

import UIKit
import CoreLocation
import MapKit

class DetialUIViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
 
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
    var resturant:ResturantData?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let resturant = resturant else {
            return
        }
        self.title = resturant.name
        //详情不能点击
        buildingTF.isUserInteractionEnabled = false
        streetTF.isUserInteractionEnabled = false
        zipcodeTF.isUserInteractionEnabled = false
        nameTF.isUserInteractionEnabled = false
        cuisineTF.isUserInteractionEnabled = false
        restaurant_idTF.isUserInteractionEnabled = false
        boroughTF.isUserInteractionEnabled = false
        gradeTF.isUserInteractionEnabled = false
        scoreTF.isUserInteractionEnabled = false
        dateTF.isUserInteractionEnabled = false
        
        buildingTF.text = resturant.address?.building
        streetTF.text = resturant.address?.street
        zipcodeTF.text = resturant.address?.zipcode

        nameTF.text = resturant.name
        cuisineTF.text = resturant.cuisine
        restaurant_idTF.text = resturant.restaurant_id
        boroughTF.text = resturant.borough
        if let grade = resturant.grades?.first {
            gradeTF.text = grade.grade
            scoreTF.text = String(format: "%.0lf", grade.score ?? 0)
            dateTF.text = grade.date
        }
        
        if let address = resturant.address{
            let currentLat = address.coord?.first ?? 0
            let currentLong = address.coord!.last ?? 0
            var centerOfMap = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            if(-90 <= currentLat && currentLat <= 90 && -180 <= currentLong && currentLong <= 180) {
                let coordinate = CLLocationCoordinate2D.init(latitude: currentLat , longitude: currentLong)
                centerOfMap = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)
                centerMapOnLocation(with: coordinate)
            }
            let pin = MKPointAnnotation()
            pin.coordinate = centerOfMap
            pin.title = resturant.name
            self.mapView.addAnnotation(pin)
            
        }
    }
    
    private func centerMapOnLocation(with coordinate: CLLocationCoordinate2D) {
      let regionRadius: CLLocationDistance = 10000
      // 设置地图显示区域
      let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func didClickDelete(_ sender: Any) {
        let box = UIAlertController(title: "Delete Resturant", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
        // 1b. Add some buttons
        box.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.deleteData()
        }))
        box.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        // 2. Show the popup
        self.present(box, animated: true)
    }
   
    func deleteData(){
        guard let resturant = resturant,
        let id = resturant._id else {
            return
        }
        NetAnimationView.show()
        guard let url = URL(string: "https://interview-app-2022.herokuapp.com/api/restaurants/\(id)") else {
                  print("Error: cannot create URL")
                  return
              }
              // Create the request
              var request = URLRequest(url: url)
              request.httpMethod = "DELETE"
              URLSession.shared.dataTask(with: request) { data, response, error in
                  NetAnimationView.diss()
                  if let error = error {
                      print("Error: error calling DELETE")
                      print(error)
                      showAlertVC(message: "Delete error")
                      return
                  }
                  guard let _ = data else {
                      print("Error: Did not receive data")
                      showAlertVC(message: "Delete error")
                      return
                  }
                  
                  guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                      print("Error: HTTP request failed")
                      showAlertVC(message: "Delete error")
                      return
                  }
                  DispatchQueue.main.async {
                      showAlertVC(message: "Delete success")
                      NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "RefreshHomeData"), object: nil)
                  }
                 
              }.resume()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdate",
           let vc = segue.destination as? UpdateViewController{
            vc.resturant = self.resturant
        }
    }
}



