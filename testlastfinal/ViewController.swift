//
//  ViewController.swift
//  testlastfinal
//
//  Created by Xi Weng on 2022-02-20.
//

import UIKit
let KScreenW = UIScreen.main.bounds.width
let KScreenH = UIScreen.main.bounds.height
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    let group = DispatchGroup()

    var page: Int = 1
    var resturantData: [ResturantData] = []
    var isPageRefreshing:Bool = true
    var pageCount: Int = 8
    @IBOutlet weak var restCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(page: page)
        restCollectionView.delegate = self
        restCollectionView.dataSource = self
        // add padding
        restCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //watch for send notification when update, delete, add
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHomeDataNotification), name: NSNotification.Name.init(rawValue: "RefreshHomeData"), object: nil)
    }
    // refresh the data if so
    @objc func refreshHomeDataNotification(){
        DispatchQueue.main.async {
            self.resturantData.removeAll()
            self.restCollectionView.reloadData()
            self.page = 1
            self.fetchData(page: self.page)
        }
        
    }
    
    deinit {

        NotificationCenter.default.removeObserver(self)
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
                if self.page != 1{
                    self.page -= 1
                }
                
                self.isPageRefreshing = false
                return
            }
            
            if let jsonData = data{
                let jsonDict = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                print("json:\(convertToJsonData(data: jsonDict))")
                do{
                    let decoder = JSONDecoder()
                    let decodedItem:[ResturantData] = try decoder.decode([ResturantData].self, from: jsonData)
                    //print(decoder)
                    self.resturantData.append(contentsOf: decodedItem)
                    print("Current Contents: \(self.resturantData.count)")
                }catch let error{
                    print("An error occured during JSON decoding")
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.restCollectionView.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.isPageRefreshing = false
            }
        }.resume()

    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resturantData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = restCollectionView.dequeueReusableCell(withReuseIdentifier: "restCell", for: indexPath) as! RestCollecitonCell
        let name = self.resturantData[indexPath.row].name ?? ""
        let cuisine = self.resturantData[indexPath.row].cuisine ?? ""
        let borough = self.resturantData[indexPath.row].borough ?? ""
        let building = self.resturantData[indexPath.row].address?.street ?? ""
        
        cell.nameLabel?.text = "name:\(name) \ncuisine:\(cuisine) \nborough:\(borough) \nbuilding:\(building)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (KScreenW-10)/2.0 - 3
        let yourHeight = yourWidth/2.0

        return CGSize(width: yourWidth, height: yourHeight)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // left and right spacing
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // line spacing
        return 5
    }
    //segue 线执行时会调用
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails",
           let vc = segue.destination as? DetialUIViewController,
           let selectedItems = self.restCollectionView.indexPathsForSelectedItems,
           let indexPath = selectedItems.first{
            ////获取目标控制器,并传递数据
            vc.resturant = self.resturantData[indexPath.row]
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if(self.restCollectionView.contentOffset.y > (self.restCollectionView.contentSize.height - self.restCollectionView.bounds.size.height)) {
           
           if !self.isPageRefreshing {
               self.isPageRefreshing = true
               print("self.page:\(self.page)")
               self.page = self.page + 1
               self.pageCount += 8
               self.fetchData(page: self.page)
           }
       }
   }
    
   
}
