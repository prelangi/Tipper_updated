//
//  ViewController.swift
//  TipCalculator
//
//  Created by Prasanthi Relangi on 1/3/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmount: UITextField?
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var splitSegment: UISegmentedControl!
    @IBOutlet weak var totalBill: UILabel!
    var bill: Double = 0

    @IBOutlet weak var payTitle: UILabel!
  
    @IBOutlet weak var tipTitle: UILabel!
    @IBOutlet weak var tipImage: UIImageView!
    
    @IBOutlet weak var splitImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make the keyboard visible on app start
        billAmount!.becomeFirstResponder()
        
        //Remember bill amount across app restarts
        let defaults        = NSUserDefaults.standardUserDefaults()
        let lastBillDate    = defaults.doubleForKey("last_bill_date")
        let lastBillAmt: String? = defaults.stringForKey("last_bill_amount")
        let currentDate = NSDate().timeIntervalSince1970
        
        //Rounded label
        totalBill.layer.masksToBounds = true
        totalBill.layer.cornerRadius = 8.0
        tipAmount.layer.masksToBounds = true
        tipAmount.layer.cornerRadius = 8.0
        
        if (currentDate-lastBillDate)<600.0 {
            billAmount!.text = lastBillAmt
            tipSegment.selectedSegmentIndex = defaults.integerForKey("default_tip_index")
            
            splitSegment.selectedSegmentIndex = defaults.integerForKey("default_split_index")
            
            //Animate
            UIView.animateWithDuration(0.8, animations: {
                self.tipTitle.alpha = 1
                self.totalBill.alpha = 1
                self.tipImage.alpha = 1
                self.splitImage.alpha = 1
                self.tipSegment.alpha = 1
                self.splitSegment.alpha = 1
                self.tipAmount.alpha = 1
                self.payTitle.alpha = 1
            })
            
        
        
        }
        else {
            print("Been more than 10min")
            billAmount!.text = ""
            totalBill.text = ""
            tipAmount.text = ""
            tipSegment.selectedSegmentIndex = defaults.integerForKey("default_tip_index")
            splitSegment.selectedSegmentIndex = defaults.integerForKey("default_split_index")
            
            //Set the last bill to zero
            //updateBill()
            tipTitle.alpha = 0
            totalBill.alpha = 0
            tipImage.alpha = 0
            splitImage.alpha = 0
            tipSegment.alpha = 0
            splitSegment.alpha = 0
            tipAmount.alpha = 0
            payTitle.alpha = 0
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Save the last bill amount
        defaults.setObject(billAmount!.text, forKey:"last_bill_amount")
        defaults.setDouble(NSDate().timeIntervalSince1970,forKey: "last_bill_date")
        defaults.synchronize()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        billAmount!.becomeFirstResponder()
        
        let defaults        = NSUserDefaults.standardUserDefaults()
        let lastBillDate    = defaults.doubleForKey("last_bill_date")
        let lastBillAmt: String? = defaults.stringForKey("last_bill_amount")
        let defaultTipIndex = defaults.integerForKey("default_tip_index")
        let defaultSplitIndex = defaults.integerForKey("default_split_index")
        let currentDate = NSDate().timeIntervalSince1970
        
        if (currentDate-lastBillDate)<600.0 {
            billAmount!.text = lastBillAmt
            print("lastBillAmount: \(lastBillAmt) ")
        }
        else {
            print("Been more than 10min")
            billAmount!.text = ""
            totalBill.text = ""
            tipAmount.text = ""
            tipTitle.alpha = 0
            totalBill.alpha = 0
            tipImage.alpha = 0
            splitImage.alpha = 0
            tipSegment.alpha = 0
            splitSegment.alpha = 0
            tipAmount.alpha = 0
            payTitle.alpha = 0
            
        }
        
        tipSegment.selectedSegmentIndex = defaultTipIndex
        splitSegment.selectedSegmentIndex = defaultSplitIndex
        
        //updateBill()
    }
    
    
    func getDefaultValues() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipSegmentIndex     = defaults.integerForKey("default_tip_index")
        let splitSegmentIndex   = defaults.integerForKey("default_split_index")
        tipSegment.selectedSegmentIndex = tipSegmentIndex
        splitSegment.selectedSegmentIndex = splitSegmentIndex
        
    }

    func updateBill() {
        let tipPercentages = [0.1,0.15,0.18,0.2]
        let splits         = [1,2,3,4,5]
        let selectedTipPercentage = tipPercentages[tipSegment.selectedSegmentIndex]
        let selectedSplit = splits[splitSegment.selectedSegmentIndex]
        
        var bill:Double = 0
        if let givenBill = Double((billAmount?.text)!) {
            bill = givenBill
        }
        //let bill = Double(givenBill)!
        let tip  = selectedTipPercentage*bill
        let total  = (bill + tip)/(Double(selectedSplit))
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        
        
        //Formatting the amount to be accurate for upto two decimal points
        totalBill.text = String(format: "$%0.2f", total)
        tipAmount.text = String(format: "$%0.2f", tip)
        
        totalBill.text = formatter.stringFromNumber(total)!
        tipAmount.text = formatter.stringFromNumber(tip)!
        
        //Animate
        UIView.animateWithDuration(0.8, animations: {
        self.tipTitle.alpha = 1
        self.totalBill.alpha = 1
        self.tipImage.alpha = 1
        self.splitImage.alpha = 1
        self.tipSegment.alpha = 1
        self.splitSegment.alpha = 1
        self.tipAmount.alpha = 1
        self.payTitle.alpha = 1
        })
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //To make the keyboard disapper on pressing the return button on the keyboard
    
    func textFieldShouldReturn(textField: UITextField)->Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        updateBill()
        
    }

    @IBAction func tipValueChanged(sender: AnyObject) {
        
        updateBill()
    }
    
    @IBAction func splitValueChanged(sender: AnyObject) {
        updateBill()
    }
    
    //tapping anywhere on the screen should make the keyboard go away
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

