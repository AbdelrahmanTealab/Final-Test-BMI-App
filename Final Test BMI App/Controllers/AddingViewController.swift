//
//  AddingViewController.swift
//  Final Test BMI App
//
//  Created by Abdelrahman  Tealab on 2020-12-11.
//  Student ID: 301164103

import UIKit
import Firebase

class AddingViewController: UIViewController {
//outlets and variables
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var weightLabel: UILabel!
    let db = Firestore.firestore()
    var calculatorLogic = CalculatorLogic()
    var heightUnit = "m"
    var weightUnit = "kg"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadDate()
        }
    
    func loadDate(){
        //async function to load the data on the main thread without crashing
        //when the fields are loaded the user will not be able to change them because they are fixed and will only change the WEIGHT
        db.collection(K.lastCollectionName)
            .addSnapshotListener{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else{
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let entryName = data["name"] as? String,let entryAge = data["age"] as? Int,let entryGender = data["gender"] as? String,let entryHeight = data["height"] as? Float,let entryImperial = data["imperial"] as? Bool{

                            DispatchQueue.main.async {
                                self.nameField.placeholder = entryName
                                self.ageField.placeholder = String(entryAge)
                                self.genderField.placeholder = entryGender
                                //incase the entry is in imperial, the sliders will change accordingly and set a new max and min values also the labels will change
                                if(entryImperial){
                                    self.heightUnit = "in"
                                    self.weightUnit = "lb"
                                    self.weightLabel.text = "\(String(format: "%.0f",self.weightSlider.value))\(self.weightUnit)"
                                    self.heightLabel.text = "\(String(format: "%.0f",self.heightSlider.value))\(self.heightUnit)"
                                    self.heightSlider.minimumValue = 0
                                    self.heightSlider.maximumValue = 118.11
                                    self.weightSlider.minimumValue = 0
                                    self.weightSlider.maximumValue = 440.925
                                }
                                else{
                                    self.heightUnit = "m"
                                    self.weightUnit = "kg"
                                    self.weightLabel.text = "\(String(format: "%.0f",self.weightSlider.value))\(self.weightUnit)"
                                    self.heightLabel.text = "\(String(format: "%.0f",self.heightSlider.value))\(self.heightUnit)"
                                    self.heightSlider.minimumValue = 0
                                    self.heightSlider.maximumValue = 3
                                    self.weightSlider.minimumValue = 0
                                    self.weightSlider.maximumValue = 200
                                }
                                self.heightSlider.value = entryHeight
                                self.heightLabel.text = "\(String(format: "%.2f",self.heightSlider.value))\(self.heightUnit)"                           }
                        }
                    }
                }
            }
    }
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func weightChanged(_ sender: UISlider) {
        weightLabel.text = "\(String(format: "%.0f",sender.value))\(weightUnit)"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let name = nameField.placeholder!
        let age = Int(ageField.placeholder!)!
        let gender = genderField.placeholder!
        let weight = weightSlider.value
        let height = heightSlider.value
        calculatorLogic.generateEntry(height, weight, name, age, gender, false)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

