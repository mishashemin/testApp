//
//  SearhViewController.swift
//  testApp
//
//  Created by  misha shemin on 24/01/2020.
//  Copyright © 2020 mishashemin. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController, ViewModelProtocol{
    var res: Res? = nil
    var searchType : ID = .user
    let idCall = "mainCall"
    var handler: ReqestModelProtocol? = nil
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBut: UIButton!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var countLable: UILabel!
    @IBOutlet weak var countSlider: UISlider!
    @IBOutlet weak var loadDataIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        loadDataIndicator.stopAnimating()
        handler = RequestHandler()
        if searchType == .user{
            searchTF.placeholder = "Введите имя"
        }
        else{
            searchTF.placeholder = "Введите название"
        }
        errorLable.isHidden = true
        resultTable.register(UINib(nibName:"MainTableViewCell",bundle: nil), forCellReuseIdentifier: idCall)
        resultTable.isHidden = true
        super.viewDidLoad()
    }
    
    @IBAction func startQuest(_ sender: Any) {
        if !loadDataIndicator.isAnimating{
            if let str = searchTF.text{
                handler!.count = Int(countLable.text!)!
                if handler!.search(str: str, id: searchType, receiver: self){
                    resultTable.isHidden = true
                    loadDataIndicator.startAnimating()
                }
                else{
                    resultTable.isHidden = true
                    errorLable.isHidden = false
                    errorLable.text = "Накосячил с url(скорее всего)"
                }
            }
            
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        countLable.text = "\(Int(countSlider.value))"
    }
    
    
    func receive(data: Res) {
        loadDataIndicator.stopAnimating()
        res = data
        if (res?.response?.items?.count)! > 0{
            resultTable.reloadData()
            errorLable.isHidden = true
            resultTable.isHidden = false
        }
        else{
            resultTable.isHidden = true
            errorLable.text = "Пусто :("
            errorLable.isHidden = false
        }
    }
    
    func errorHandler() {
        loadDataIndicator.stopAnimating()
        errorLable.isHidden = false
        errorLable.text = "Ошибка в запросе!"
    }
    
    func cellCraft( _ cell : MainTableViewCell,_ indexPath: IndexPath)->MainTableViewCell{
        let items = res?.response?.items
        let index = indexPath.row
        switch searchType {
        case .user:
            
            cell.lbID.text = String(describing: (items![index].id)!)
            let name = items![index].first_name! + " " + items![index].last_name!
            cell.lbName.text = name
            cell.changeLable.font = cell.changeLable.font.withSize(16.0)
            cell.changeLable.text = "Имя:"
            
            var link = ""
            if items![index].photo_200 != nil{ link = items![index].photo_200! }
            else if items![index].photo_100 != nil{ link = items![index].photo_100! }
            else if items![index].photo != nil{ link = items![index].photo! }
            
            cell.img.downloadedFrom(link: link)
            cell.adress.text = "https://vk.com/" + items![index].screen_name!
            
        case .group:
            
            cell.lbID.text = String(describing: (items![index].id)!)
            cell.lbName.text = items![index].name!
            cell.changeLable.font = cell.changeLable.font.withSize(6.0)
            cell.changeLable.text = "Название:"
            
            var link = ""
            if items![indexPath.row].photo_200 != nil{ link = items![indexPath.row].photo_200! }
            else if items![indexPath.row].photo_100 != nil{ link = items![indexPath.row].photo_100! }
            else if items![indexPath.row].photo != nil{ link = items![indexPath.row].photo! }
            
            cell.img.downloadedFrom(link: link)
            cell.adress.text = "https://vk.com/" + items![indexPath.row].screen_name!
        default: break
            
        }
        return cell
    }
}

extension SearchViewController: UITabBarDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let count = res?.response?.items?.count{
            return count
        }
        else{
            return 0
        }
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = resultTable.dequeueReusableCell(withIdentifier: idCall) as! MainTableViewCell
        return cellCraft(cell,indexPath)
    }
}
