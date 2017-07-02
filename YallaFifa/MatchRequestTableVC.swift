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
//    let onlineUser1 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.25506634),"lng":(29.97618978)],typeOfUser: "online")
//    let onlineUser2 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.23506634),"lng":(29.97618978)],typeOfUser: "online")
//    let onlineUser3 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.28506634),"lng":(29.97618978)],typeOfUser: "online")
//    let onlineUser4 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.29506634),"lng":(29.97618978)],typeOfUser: "online"
//    )
//    
//    let phyUser1 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.25506634),"lng":(29.9461897)],typeOfUser: "physically")
//    let phyUser2 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.27506634),"lng":(29.93618978)],typeOfUser: "physically")
//    let phyUser3 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.28506634),"lng":(29.96418978)],typeOfUser: "physically")
//    let phyUser4 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.29506634),"lng":(29.96818978)],typeOfUser: "physically")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get data from firebase and set on nearbyUsers array
            tableView.tableFooterView = UIView()
        
            var cellNib = UINib(nibName: TableViewCellIdentifiers.psDetailsCell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.psDetailsCell)
        
            cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        //nearbyUsers = [onlineUser1,onlineUser2,onlineUser3,onlineUser4,phyUser1,phyUser2,phyUser3,phyUser4]

    }

    @IBAction func backbtnAct(_ sender: Any) {
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController!.popViewController(animated: true)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
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

extension MatchRequestTableViewController: UITableViewDelegate {

//   func tableView(_ tableView: UITableView,
//                  didSelectRowAt indexPath: IndexPath) {

//        if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact {
//            tableView.deselectRow(at: indexPath, animated: true)
//            performSegue(withIdentifier: "ShowDetail", sender: indexPath)
//
//        } else {
//            if case .results(let list) = search.state {
//                splitViewDetail?.searchResult = list[indexPath.row]
//            }
//            if splitViewController!.displayMode != .allVisible {
//                hideMasterPane()
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView,
//                   willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        switch search.state {
//        case .notSearchedYet, .loading, .noResults:
//            return nil
//        case .results:
//            return indexPath
//        }
//    }
//}
}
