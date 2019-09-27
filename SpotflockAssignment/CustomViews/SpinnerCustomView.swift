//
//  SpinnerCustomView.swift
//  SpotflockAssignment
//
//  Created by Priyanka Bandaru on 01/02/19.
//

import UIKit

class SpinnerCustomView: UIView {

    @IBOutlet var bgView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        
    }
    
    
    func setup() {
        if subviews.count == 0 {
            //means view got loaded from GlobalView.xib or other external nib, cause there aren't any subviews
            let viewFromNib = Bundle.main.loadNibNamed("SpinnerCustomView", owner: self, options: nil)?.first as? SpinnerCustomView
            bgView = viewFromNib?.bgView
            titleLabel = viewFromNib?.titleLabel
            activityIndicator = viewFromNib?.activityIndicator
            
            viewFromNib?.frame = bounds
            viewFromNib?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(viewFromNib!)
            UISetup()
        }
    }
    
    func UISetup(){
        activityIndicator.startAnimating()
        
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 8.0
    }

}
