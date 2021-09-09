//
//  ViewController.swift
//  Sample
//
//  Created by Dominik Pethö on 12/15/20.
//

#if !os(macOS)

import UIKit
import GoodExtensions
import GoodStructs
import GoodCombineExtensions
import Combine
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewc: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let result = GRResult<Int, Int>.success(1)
        
        let pole: Collection<Int>? = [1]
        MKMultiPoint.init().gr.points
        
        "".gr.removeWhiteSpacesAndNewlines
        
        debugPrint(" dominik Pétho ")
        // Do any additional setup after loading the view.
    }


}

#endif
