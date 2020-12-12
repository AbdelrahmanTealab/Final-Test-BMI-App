//
//  CalculatorLogic.swift
//  Final Test BMI App
//
//  Created by Abdelrahman  Tealab on 2020-12-10.
//  Student ID: 301164103

import Foundation
import UIKit
import Firebase

//the database struct is to store the entry to the database
struct Database {
    let db = Firestore.firestore()

    func storeEntry(_ entry:Entry) {
//storing the data into firestore
        db.collection(K.collectionName).addDocument(data: ["name":entry.name,"age":entry.age,"gender":entry.gender,"weight":entry.weight,"height":entry.height,"bmi":entry.bmi,"date":entry.date,"imperial":entry.imperial]){(error) in
            if let e = error{
                print("error saving data: \(e)")
            }
            else{
                print("data saved successfully")
            }
        }
        //storing the last known information into a separate document and collection to read it later
        db.collection(K.lastCollectionName).document("lastbmi").setData(["name":entry.name,"age":entry.age,"gender":entry.gender,"height":entry.height,"imperial":entry.imperial]){(error) in
            if let e = error{
                print("error saving data: \(e)")
            }
            else{
                print("data saved successfully")
            }
        }
        
    }
}
struct CalculatorLogic{
    var entry:Entry?
    var database = Database()

    //creating a new entry object
    mutating func generateEntry(_ height:Float,_ weight:Float,_ name:String,_ age:Int,_ gender:String,_ imperial:Bool){
        
        var bmiValue = weight/pow(height, 2)
        
        if imperial {
            bmiValue = (weight*703)/pow(height, 2)
        }
        //formating the date in a simple format
        let formatter = DateFormatter()
        var date = ""
        formatter.dateFormat = K.dateFormat
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        date = formatter.string(from: Date())
        
        entry = Entry(date: date,name: name, age: age, gender: gender, weight: weight, height: height,bmi: bmiValue, imperial: imperial)
        database.storeEntry(entry!)
    }
    //getting the text color based on the entry's bmi value to avoid dark background with dark text
    func getTextColor(_ entry:Entry)->UIColor{
        if entry.bmi < 16  || entry.bmi >= 40{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    else{
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    }
    //getting the background color based on the entry's bmi value to indicate severity
    func getColor(_ entry:Entry)->UIColor{
        if entry.bmi < 16 {
            return #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        }
        else if entry.bmi < 17{
            return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        }
        else if entry.bmi < 18.5{
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        else if entry.bmi < 25{
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        else if entry.bmi < 30{
            return #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
        else if entry.bmi < 35{
            return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        else if entry.bmi < 40{
            return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
        else{
            return #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        }
    }
    //getting the appropriate message for the bmi value
    func getMessage(_ entry:Entry)->String{
        if entry.bmi < 16 {
            return "Severe Thinness"
        }
        else if entry.bmi < 17{
            return "Moderate Thinness"
        }
        else if entry.bmi < 18.5{
            return "Mild Thinness"
        }
        else if entry.bmi < 25{
            return "Normal"
        }
        else if entry.bmi < 30{
            return "Overweight"
        }
        else if entry.bmi < 35{
            return "Obese Class 1"
        }
        else if entry.bmi < 40{
            return "Obese Class 2"
        }
        else{
            return "Obese Class 3 "
        }
    }
}

//entry object which will be used to populate the table
struct Entry {
    let date:String
    let name:String
    let age:Int
    let gender:String
    let weight:Float
    let height:Float
    let bmi:Float
    let imperial:Bool

    internal init(date: String, name: String, age: Int, gender: String, weight: Float, height: Float, bmi: Float, imperial:Bool) {
        self.date = date
        self.name = name
        self.age = age
        self.gender = gender
        self.weight = weight
        self.height = height
        self.bmi = bmi
        self.imperial = imperial
    }
}
