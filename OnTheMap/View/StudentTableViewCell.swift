//
//  StudentTableViewCell.swift
//  PinSample
//
//  Created by Ammar AlTahhan on 18/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    var studentLocation: StudentLocation? {
        didSet {
            guard let studentLocation = studentLocation else { return }
            nameLabel.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
            linkLabel.text = studentLocation.mediaURL
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
