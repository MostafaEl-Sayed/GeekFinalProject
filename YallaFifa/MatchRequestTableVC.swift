//
//  MatchRequestTableViewController.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/16/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class MatchRequestTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var nearbyUsers = [User]()
        struct TableViewCellIdentifiers {
            static let psDetailsCell = "UserDetailsCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            tableView.tableFooterView = UIView()
            registerXibs()
    }
    func registerXibs() {
        var cellNib = UINib(nibName: TableViewCellIdentifiers.psDetailsCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.psDetailsCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    }
    
    @IBAction func backbtnAct(_ sender: Any) {
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController!.popViewController(animated: true)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
    }

}


extension MatchRequestTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        switch nearbyUsers.count {
        case 0:
            return 1
        default:
            return nearbyUsers.count
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch nearbyUsers.count {
        case 0:
            
            return self.tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
                for: indexPath)


        default :
            let cell = self.tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.psDetailsCell,
                for: indexPath) as! UserDetailsTableViewCell
            let psLocation = nearbyUsers[indexPath.row]
            cell.configure(newPS: psLocation)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch nearbyUsers.count {
        case 0:
            return 70
        default :
            return 200
        }
    }
}


