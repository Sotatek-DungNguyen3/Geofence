//
//  BaseView.swift
//  Geofence
//
//  Created by Nguyen Tan Dung on 10/06/2021.
//

import UIKit

class BaseView: UIView {

    let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
    
    //MARK: view used for init from nib
    private var contentView: UIView!
    
    
    //-------------------------------------------------------------------------------------------------------
    //MARK: - Init -
    //-------------------------------------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: self.SCREEN_WIDTH, height: self.SCREEN_HEIGHT))
        xibSetup()
    }
    
    deinit {
        print("\(Date()): ✅ \(String(describing: self)) deinit!")
    }
    
    //-------------------------------------------------------------------------------------------------------
    //MARK: - Show on super view -
    //-------------------------------------------------------------------------------------------------------
    func addToWindow() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    //-------------------------------------------------------------------------------------------------------
    //MARK: - Setup Xib -
    //-------------------------------------------------------------------------------------------------------
    
    private func xibSetup() {
        contentView = loadViewFromNib()
        
        addSubview(contentView)

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        // Set contraints to full view
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }
    
    internal func getNibName() -> String {
        return ""
    }
    
    private func loadViewFromNib() -> UIView {
        var name = getNibName()
        if name.isEmpty {
            name = String(describing: type(of: self))
        }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

}
