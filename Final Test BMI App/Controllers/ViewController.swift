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
    
    @IBOutlet weak var imperial: UISwitch!
    
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
    @IBAction func unitChanged(_ sender: UISwitch) {
        if !sender.isOn {
            heightUnit = "m"
            weightUnit = "Kg"
            heightLabel.text = "\(String(format: "%.2f",heightSlider.value))\(heightUnit)"
            weightLabel.text = "\(String(format: "%.0f",weightSlider.value))\(weightUnit)"
            heightSlider.minimumValue = 0
            heightSlider.maximumValue = 3
            weightSlider.minimumValue = 0
            weightSlider.maximumValue = 200
        }
        else{
            heightUnit = "in"
            weightUnit = "lb"
            heightLabel.text = "\(String(format: "%.2f",heightSlider.value))\(heightUnit)"
            weightLabel.text = "\(String(format: "%.0f",weightSlider.value))\(weightUnit)"
            heightSlider.minimumValue = 0
            heightSlider.maximumValue = 118.11
            weightSlider.minimumValue = 0
            weightSlider.maximumValue = 440.925
        }
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
            calculatorLogic.generateEntry(height, weight, name, age, gender,imperial.isOn)
            
            }

        self.performSegue(withIdentifier: K.segueName, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResults"
        {
            _ = segue.destination as! TrackingViewController
        }

    }
}

