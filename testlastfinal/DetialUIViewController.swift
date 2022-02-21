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
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var boroughLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var selectedResturant:ResturantData? = nil
    let geocoder = CLGeocoder();

    override func viewDidLoad() {
        super.viewDidLoad()
        detailNameLabel.text = selectedResturant?.name
        buildingLabel.text = selectedResturant?.address?.building
        streetLabel.text = selectedResturant?.address?.street
        zipcodeLabel.text = selectedResturant?.address?.zipcode
        boroughLabel.text = selectedResturant?.borough
        gradeLabel.text = "\(selectedResturant?.grade)"
        print("-------------------")
        print(selectedResturant)
        print(selectedResturant?._id)
        let zoomLevel = MKCoordinateSpan(latitudeDelta:50, longitudeDelta:50)
        let centerOfMap = CLLocationCoordinate2D(
            //latitude: selectedResturant!.address!.coord![0],
        //longitude: selectedResturant!.address!.coord![1]) //Canada
            latitude: 27.2046, longitude: 77.4977)
        let visibleRegion = MKCoordinateRegion(center: centerOfMap, span: zoomLevel)
        self.mapView.setRegion(visibleRegion, animated: true)
//        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func deleteResturant(_ sender: Any) {
        let box = UIAlertController(title: "Delete Resturant", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
        
        // 1b. Add some buttons
        
        box.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.deleteData()
        }
                                   ))
        box.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        // 2. Show the popup
        self.present(box, animated: true)

    }
    
    @IBAction func updateProfile(_ sender: Any) {
        guard let detailPage = storyboard?.instantiateViewController(withIdentifier: "updateViewPage") as? UIViewController else{
            print("Error")
            return
        }
        

        show(detailPage, sender:self)
    }
    
    
    func deleteData(){

        guard let url = URL(string: "https://interview-app-2022.herokuapp.com/api/restaurants/\(selectedResturant!._id!)") else {
                  print("Error: cannot create URL")
                  return
              }
              // Create the request
              var request = URLRequest(url: url)
              request.httpMethod = "DELETE"
              URLSession.shared.dataTask(with: request) { data, response, error in
                  guard error == nil else {
                      print("Error: error calling DELETE")
                      print(error!)
                      return
                  }
                  guard let data = data else {
                      print("Error: Did not receive data")
                      return
                  }
                  guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                      print("Error: HTTP request failed")
                      return
                  }
                  do {
                      guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                          print("Error: Cannot convert data to JSON")
                          return
                      }
                  } catch {
                      print("Error: Trying to convert JSON data to string")
                      return
                  }
              }.resume()

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
