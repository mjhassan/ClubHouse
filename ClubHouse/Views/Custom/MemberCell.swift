//
//  MemberCell.swift
//  ClubHouse
//
//  Created by Jahid Hassan on 11/27/19.
//  Copyright © 2019 Jahid Hassan. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    static let identifier: String = "Cell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var favoriteView: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var member: Member? {
        didSet {
            guard let _member = member else { return }
            
            nameLabel.text = _member.fullName
            ageLabel.text = ", \(_member.age)"
            phoneLabel.text = _member.phone
            emailLabel.text = _member.email
            reloadData(for: _member.id)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.hitTest(firstTouch.location(in: self), with: event)
            
            if hitView == phoneLabel {
                phoneLabel.text?.makeCall()
            } else if hitView == emailLabel {
                emailLabel.text?.sendMail()
            }
        }
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        guard let id = member?.id else { return }
        
        let value = Store.shared.isFavorite(id)
        Store.shared.setFavorite(id, favorite: !value)
        reloadData(for: id)
    }
    
    private func reloadData(for id: String) {
        let favorite = Store.shared.isFavorite(id)
        let favoriteImgStr = favorite ? "heart.fill":"heart"
        favoriteView.setImage(UIImage(named: favoriteImgStr), for: .normal)
    }
}
