//MVC Sample?


//Protocol Class

import Foundation

protocol PaymentDelegate: class {
    func userHasCard(paymentInfo: Payment, status: NSString)
    func gotCardData(paymentInfo: Payment, status: [AnyObject])
    func cardAdded(paymentInfo: Payment, status: NSString)
    func cardValidated(paymentInfo: Payment)
    
}



//
//  ViewController.swift
//  TestingPlayground
//

import UIKit
import Stripe

class paymentViewController: UIViewController, PaymentDelegate{
    
    var info: Payment!
    
    func userHasCard(paymentInfo: Payment, status: NSString){
        print("User has Card: \(status)")
        
    }
    
    func gotCardData(paymentInfo: Payment, status: [AnyObject]){
        print("Card Data Received: \(status)")
    }
    
    func cardAdded(paymentInfo: Payment, status: NSString){
        print("Card Successfully Added: \(status)")
        print("Cards: ")
        print(info.getCards())
    }
    
    func cardValidated(paymentInfo: Payment){
        print("Card Successfully Validated: ")
    }
    
    func done(){
        print(navigationController?.viewControllers)
        let vwc = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController")
        self.presentViewController(vwc, animated: true, completion: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        info = Payment()
        info.delegate = self
    }
    
    override func viewDidAppear(animated: Bool){
        info.checkCard()
    }
}







//
//  Payment Model
//

import Foundation
import Stripe

class Payment {
    
    weak var delegate: PaymentDelegate?
    
    struct card{
        var token: STPToken!
        
        init(t: STPToken!){
            token = t
        }
    }
    
    private struct wallet{
        static var primaryCard: STPToken!
        static var cards: [STPToken] = [STPCard]()
    }
    
    private var primaryCard: STPToken
        {
        set {
            wallet.cards.append(newValue)
            wallet.primaryCard = (newValue)
        }
        get { return wallet.primaryCard }
        
    }
    
    private var cards: [STPToken]
        {
        set {
            wallet.cards = newValue
            wallet.primaryCard = newValue[0]
        }
        get { return wallet.cards}
        
    }
    
    init(){
    }
    
    func checkCard(){
        API().checkCard(){  status in
            self.delegate?.userHasCard(self, status: status)
        }
    }
    
    func getCard(){
        API().getCard(){  status in
            self.delegate?.gotCardData(self, status: status)
        }
    }
    
    func validateCard(card: STPCard) -> Bool{
        return STPCardValidator.validationStateForCard(card) == .Valid
    }
    
}



