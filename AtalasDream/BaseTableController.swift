//
//  BaseTableViewController.swift
//  AtalasDream
//
//  Created by GuoGongbin on 6/13/17.
//  Copyright © 2017 GuoGongbin. All rights reserved.
//

import UIKit

class BaseTableController: UITableViewController {

    let bgc = UIColor(r: 239, g: 239, b: 244)
    let footerColor = UIColor(r: 226, g: 226, b: 228)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = bgc
    }
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = bgc
        
        return view
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = footerColor
        
        return view
    }


}
