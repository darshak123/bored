//
//  TermsVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 01/12/20.
//

import UIKit

class TermsVC: BaseViewController {

    @IBOutlet weak var view_header: UIView!
    
    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var txt_view: UITextView!{
        didSet{
            txt_view.setDynamicRegularFont(fontsize: 13)
        }
    }
    
    var text : String = ""
    var header_text : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(header_view: view_header)
        
        lbl_header.text = header_text
        txt_view.text = text.html2String
    }
    

    /*
    // text:  - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
