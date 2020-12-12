//
//  ViewController.swift
//  Final Test BMI App
//
//  Created by Abdelrahman  Tealab on 2020-12-10.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    
    @IBOutlet weak var metricSwitch: UISwitch!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    
    var heightUnit = "m"
    var weightUnit = "Kg"

    var calculatorLogic = CalculatorLogic()
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func skipPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segueName, sender: self)
    }
    @IBAction func heightChanged(_ sender: UISlider) {
        heightLabel.text = "\(String(format: "%.2f",sender.value))\(heightUnit)"
    }
    
    @IBAction func weightChanged(_ sender: UISlider) {
        weightLabel.text = "\(String(format: "%.0f",sender.value))\(weightUnit)"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        if nameField.text!.isEmpty || ageField.text!.isEmpty || genderField.text!.isEmpty{
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in all information !", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            // i assign the fields to variables then format the date
            // in a nice readable format
            let name = nameField.text!
            let age = Int(ageField.text!)!
            let gender = genderField.text!
            let weight = weightSlider.value
            let height = heightSlider.value
            calculatorLogic.generateEntry(height, weight, name, age, gender)
            
            }

        self.performSegue(withIdentifier: K.segueName, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResults"
        {
            let destinationVc = segue.destination as! TrackingViewController
        }

    }
}

