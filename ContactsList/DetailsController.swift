//
//  DetailsController.swift
//  ContactsList
//
//  Created by Alejandro on 6/28/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

import Foundation
import UIKit

class DetailsController : UIViewController{
    var data: JSON = []
    var detailsData: JSON = []
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var phoneType: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var favourite: UIImageView!
    @IBOutlet weak var profile: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
    }
    
    func setDetails()
    {
        //prepare second address field data
        var address2text: String = detailsData["address"]["city"].string!
        address2text += ", "
        address2text += detailsData["address"]["state"].string!
        
        //prepare birthday data
        var bday = NSDate( timeIntervalSince1970: detailsData["birthday"].doubleValue )
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        //prepare favourite-image according to it being true or false
        var fav_image_name = ( detailsData["favorite"].boolValue ) ? "fav.png" : "nofav.png"
        println( fav_image_name )
        
        //set all fields to their respective values
        name.text = data["name"].string
        company.text = data["company"].string
        phoneNumber.text = data["phone"]["home"].string
        phoneType.text = "Home"
        address1.text = detailsData["address"]["street"].string
        address2.text = address2text
        birthday.text = dateFormatter.stringFromDate( bday )
        email.text = detailsData["email"].string
        profile.setImageWithUrl(NSURL( string: detailsData["largeImageURL"].string! )!)
        favourite.image = UIImage(named: fav_image_name)
    }
}