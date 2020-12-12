//
//  TrackingViewController.swift
//  Final Test BMI App
//
//  Created by Abdelrahman  Tealab on 2020-12-11.
//

import UIKit
import Firebase

class TrackingViewController: UIViewController {
    let db = Firestore.firestore()
    var calculatorLogic = CalculatorLogic()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var plusButton: UIButton!
    
    var bmis:[Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.size.width
        plusButton.clipsToBounds = true
        listTableView.dataSource=self
        listTableView.delegate=self
        //registering my custom cell name
        listTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadBmis()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func plusPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadBmis(){
        //this is where i load todos from the DB
        //i used addSnapshotListener because it refreshed the function everytime there's an update in the DB
        //when there's an update i call reloadData function in the main thread to avoid crashing
        db.collection(K.collectionName)
            .addSnapshotListener{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.bmis = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let entryDate = data["date"] as? String, let entryName = data["name"] as? String,let entryAge = data["age"] as? Int,let entryGender = data["gender"] as? String,let entryWeight = data["weight"] as? Float,let entryHeight = data["height"] as? Float,let entryBmi = data["bmi"] as? Float{
                            let newEntry = Entry(date: entryDate,name: entryName, age: entryAge, gender: entryGender, weight: entryWeight, height: entryHeight, bmi: entryBmi)
                            self.bmis.append(newEntry)
                            DispatchQueue.main.async {
                                self.listTableView.reloadData()
                            }
                        }
                    }
                }
        }
    }

}

//MARK: - extensions
extension TrackingViewController:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returning the number of items in the list to display it as the number of rows
        return bmis.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //setting my cell as ListCell as this is my custom cell
        let cell = listTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! BmiCell
        //setting the title and dates of the custom cell as well as assigning numbers to the buttons tags so i can access their data easily later
        cell.dateLabel?.text = bmis[indexPath.row].date
        cell.dateLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.nameLabel?.text = bmis[indexPath.row].name
        cell.nameLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.ageLabel?.text = String(bmis[indexPath.row].age)
        cell.ageLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.genderLabel?.text = bmis[indexPath.row].gender
        cell.genderLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.weightLabel?.text = String(format: "%.1f",bmis[indexPath.row].weight)
        cell.weightLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.heightLabel?.text = String(format: "%.1f",bmis[indexPath.row].height)
        cell.heightLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.bmiLabel?.text = String(format: "%.1f",bmis[indexPath.row].bmi)
        cell.bmiLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.messageLabel?.text = calculatorLogic.getMessage(bmis[indexPath.row])
        cell.messageLabel?.textColor = calculatorLogic.getTextColor(bmis[indexPath.row])
        cell.contentView.backgroundColor = calculatorLogic.getColor(bmis[indexPath.row])
        return cell
    }
    
}

    //MARK: - Table delegate
extension TrackingViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text as Any)
    }
}
