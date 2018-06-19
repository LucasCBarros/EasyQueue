//
//  InterfaceController.swift
//  FilaFacilWatch Extension
//
//  Created by Lucas Barros on 19/06/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var lineTableView: WKInterfaceTable!
    
    let tableData = ["one", "two", "Three", "Four"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func loadTableData() {
        lineTableView.setNumberOfRows(tableData.count, withRowType: "RowController")
        
        for (index, rowModel) in tableData.enumerated() {
            if let rowController = lineTableView.rowController(at: index) as? RowController {
                rowController.rowLabel.setText(rowModel)
            }
        }
    }

}
