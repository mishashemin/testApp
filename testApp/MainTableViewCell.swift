//
//  MainTableViewCell.swift
//  testApp
//
//  Created by  misha shemin on 24/01/2020.
//  Copyright © 2020 mishashemin. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var changeLable: UILabel!
    @IBOutlet weak var lbNameWight: NSLayoutConstraint!
    @IBOutlet weak var lbIDWidht: NSLayoutConstraint!
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func craftParm(type: Type, name: String, id: Int, imgLink: String, screenName: String)
    {
        switch type {
        case .user:
            lbID.text = String(id)
            lbName.text = name
            changeLable.text = "Имя:"
            lbNameWight.constant = 45
            lbIDWidht.constant = 45
            img.downloadedFrom(link: imgLink)
            adress.text = "https://vk.com/" + screenName
            
        case .group:
            lbID.text = String(id)
            lbName.text = name
            changeLable.text = "Название:"
            lbNameWight.constant = 90
            lbIDWidht.constant = 90
            img.downloadedFrom(link: imgLink)
            adress.text = "https://vk.com/" + screenName
        }
    }
}
