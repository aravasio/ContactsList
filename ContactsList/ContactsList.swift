//
//  ContactsListController.swift
//  ContactsList
//
//  Created by Alejandro on 6/26/15.
//  Copyright (c) 2015 Alejandro. All rights reserved.
//

import Foundation
import UIKit

class ContactsList : UITableViewController {
    var contacts: JSON = []
    var contactDetails: JSON = []
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.retrieveContactsList()
    }
    
    func retrieveContactsList() {
        let url = NSURL(string: "https://solstice.applauncher.com/external/contacts.json")
        let request = NSURLRequest(URL: url!)
        
        let completionBlock: (NSURLResponse!, NSData!, NSError!) -> Void = {response, data, error in
            self.contacts = JSON( data: data )
            self.tableView.reloadData()
        }
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completionBlock)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath ) as! ContactCell
        cell.titleLabel.text = self.contacts[indexPath.item]["name"].string
        cell.subtitleLabel?.text = self.contacts[indexPath.item]["phone"]["home"].string
        
        cell.cellImage?.setImageWithUrl( NSURL( string: self.contacts[indexPath.item]["smallImageURL"].string! )!)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        retrieveAndDisplayDetails( indexPath.item )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = sender as! Int
        
        if( segue.identifier == "DetailSegue") {
            let controller = segue.destinationViewController as! DetailsController
            controller.data = self.contacts[index]
            controller.detailsData = self.contactDetails
        }
    }
    
    func retrieveAndDisplayDetails( index: Int ) {
        
        let url = NSURL(string: self.contacts[index]["detailsURL"].string! )
        let request = NSURLRequest(URL: url!)
        
        let completion: (NSURLResponse!, NSData!, NSError!) -> Void = {response, data, error in
            self.contactDetails = JSON( data: data )
            self.performSegueWithIdentifier("DetailSegue", sender: index)
            
        }
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: completion )
    }
}
