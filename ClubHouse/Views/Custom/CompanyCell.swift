//
//  CompanyCell.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/26/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit
import Haneke

class CompanyCell: UITableViewCell {
    static let identifier: String = "Cell"
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var favoriteView: UIButton!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var company: Company? {
        didSet {
            guard let _company = company else { return }
            
            companyLabel.text = _company.name
            descriptionLabel.text = _company.description
            websiteLabel.text = _company.website?.absoluteString ?? ""
            
            if let url = _company.logo {
                imgView.hnk_setImageFromURL(url)
            } else {
                imgView.image = nil
            }
            
            reloadData(for: _company.id)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self, action:#selector(toggleFollowing(_:)))
        followView.addGestureRecognizer(gesture)
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        guard let id = company?.id else { return }
        
        let value = Store.shared.isFavorite(id)
        Store.shared.setFavorite(id, favorite: !value)
        
        reloadData(for: id)
    }
    
    @objc func toggleFollowing(_ gesture: UITapGestureRecognizer) {
        guard let id = company?.id else { return }
        
        let value = Store.shared.isFollowing(id)
        Store.shared.setFollowing(id, following: !value)
        
        reloadData(for: id)
    }
    
    private func reloadData(for id: String) {
        let favorite = Store.shared.isFavorite(id)
        let favoriteImgStr = favorite ? "heart.fill":"heart"
        favoriteView.setImage(UIImage(named: favoriteImgStr), for: .normal)
        
        let following = Store.shared.isFollowing(id)
        followView.backgroundColor = following ? .lightGray:.systemBlue
        followLabel.text = following ? "Following":"Follow"
    }
}
