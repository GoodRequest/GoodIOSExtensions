//
//  DocumentViewController.swift
//  Sample
//
//  Created by Dominik Pethö on 6/15/21.
//
#if !os(macOS)

import UIKit
import GoodExtensions

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: UIDocument?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 10) {
            self.documentNameLabel.gr.rotate(.by180negative)
        }
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}

#endif
