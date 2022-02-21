//
//  ViewController.swift
//  testlastfinal
//
//  Created by Xi Weng on 2022-02-20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let group = DispatchGroup()

    var page: Int = 1
    var resturantData: [ResturantData] = []
    var isPageRefreshing:Bool = false
    var pageCount: Int = 8
    @IBOutlet weak var restCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(page: page)
        // Register cell classes
        // Do any additional setup after loading the view.
        restCollectionView.delegate = self
        restCollectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.restCollectionView.reloadData()
        }
    }
    
    
    func fetchData(page: Int){
        let apiEndpoint = "https://interview-app-2022.herokuapp.com/api/restaurants?page=\(page)&perPage=8"
        
        guard let url = URL(string:apiEndpoint) else{
            print("Could not convert string to URL object")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let err = error{
                print("Error occured while fetching data from api")
                print(err)
                return
            }
            
            if let jsonData = data{
                do{
                    let decoder = JSONDecoder()
                    let decodedItem:[ResturantData] = try decoder.decode([ResturantData].self, from: data!)
                    //print(decoder)
                    self.resturantData.append(contentsOf: decodedItem)
                    print(self.resturantData)
                }catch let error{
                    print("An error occured during JSON decoding")
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.restCollectionView.reloadData()
            }
        }.resume()
        


    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resturantData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = restCollectionView.dequeueReusableCell(withReuseIdentifier: "restCell", for: indexPath) as! RestCollecitonCell
        
        print(resturantData.count)
        print(pageCount)
        if(resturantData.count != pageCount){
            return cell
        }
        
        print(indexPath.row)
        if(indexPath.row < pageCount){
        cell.nameLabel?.text = self.resturantData[indexPath.row].name
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let detailPage = storyboard?.instantiateViewController(withIdentifier: "restDetailPage") as? DetialUIViewController else{
            print("Error")
            return
        }
        
        detailPage.selectedResturant = self.resturantData[indexPath.row]
        
        show(detailPage, sender:self)
        print(resturantData[indexPath.row]._id)
    }
    
    @IBAction func addResturant(_ sender: Any) {
            guard let detailPage = storyboard?.instantiateViewController(withIdentifier: "addResturantView") as? UIViewController else{
                print("Error")
                return
            }

            show(detailPage, sender:self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if(self.restCollectionView.contentOffset.y >= (self.restCollectionView.contentSize.height - self.restCollectionView.bounds.size.height)) {
           if !isPageRefreshing {
               isPageRefreshing = true
               print(page)
               page = page + 1
               pageCount += 8
               fetchData(page: page)
           }
           

       }
   }
}
