//
//  ViewController.swift
//  simpleSqllite
//
//  Created by Vijay on 08/02/21.
//

import UIKit
import SQLite3

let fileURL = try! FileManager.default
    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    .appendingPathComponent("user.sqlite")
var db: OpaquePointer?
internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
var statement: OpaquePointer?


class ViewController: UIViewController {

   
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtMobileNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        openDataBase()
        createTable()
        selectData()
        
    }
    
    
    @IBAction func btnTouchUpSaveData(_ sender: UIButton) {
        insertData()
        selectData()
    }
    
    
    
    
    func openDataBase()  {
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return
        }
    }
    
    func createTable() {
        
        if sqlite3_exec(db, "create table if not exists user (id integer primary key autoincrement, name text , mobileno CHARACTER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        else{print("Successfuly TABLE CREATE...") }
    }
    
    func insertData() {
       
        
        if sqlite3_prepare_v2(db, "insert into user (name,mobileno) values (?,?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        // txtUserName.text is OPTIONAL taype it must be unwrapped he unwrapped using "!" sign
        if sqlite3_bind_text(statement, 1, "\(txtUserName.text!)", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 2, "\(txtMobileNumber.text!)", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }

        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }
        else
        {
            print("Successfuly Insert Data...")
        }
    }
    
    func selectData() {
        if sqlite3_prepare_v2(db, "select id, name , mobileno from user", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }

        while sqlite3_step(statement) == SQLITE_ROW {
//            let id = sqlite3_column_int64(statement, 0)
//            print("id = \(id) ", terminator: "")
//
//            if let cString = sqlite3_column_text(statement, 1) {
//
//                let name = String(cString: cString)
//                print(" name = \(name)", terminator: "")
//            } else {
//                print("name not found")
//            }
//
//            if let cString = sqlite3_column_text(statement, 2) {
//                let  mono = String(cString: cString)
//                print(" Mobile Number = \(mono)" )
//            } else {
//                print("name not found")
//            }
            
            let id = sqlite3_column_int(statement, 0)
             let name = String(cString: sqlite3_column_text(statement, 1))
            let mono = String(cString: sqlite3_column_text(statement, 2))
           
            print("id:\(id) NAME:\(name) MONO: \(mono)")
        }
        
        

        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }

        statement = nil
    }
}




