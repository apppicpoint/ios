//
//  Utils.swift
//  Picpoint
//
//  Created by David on 31/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//
import UIKit
import Foundation

struct Constants {
    static let url = "http://192.168.6.162/api/public/index.php/api/" //dev
    //static let url = "http://localhost:8888/api/public/index.php/api/" //local
    //static let url = "picpoint.vanadis.es/api/" // pro
    
}

class Utils {
    //Devuelve un string aleatorio entre mayusculas, minusculas y numeros.
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

extension UITableView {
    
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    enum scrollsTo {
        case top,bottom
    }
}


extension UITextField {
    open override func awakeFromNib() {
        self.resignFirstResponder()

    }
    func whiteDesign() {
        self.textColor = .white
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width*2, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func greyDesign() {
        self.textColor = .darkGray
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width*2, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension UITextView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.resignFirstResponder()

        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        // self.font = UIFont.init(name: "Montserrat-Medium", size: 14)
    }
    
}

/*
extension UILabel {
    open override func awakeFromNib() {
        super.awakeFromNib()
  
        self.font = UIFont(name: "Montserrat", size: 12)
        print("cambiandoTexto")
        if UIFont(name: "Montserrat", size: 14) != nil {
            print("hay tipo")
        } else{
            print("no hay tipo")
        }
    }
}

extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont(name: "Montserrat-Light.ttf", size: 14)
        print("cambiandoTexto")
        if UIFont(name:"Montserrat-Light.ttf", size: 14) != nil {
            print("hay tipo")
        } else{
            print("no hay tipo")
        }
    }
}
*/


var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init()
        ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
