//
//  ViewController.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 20/12/15.
//  Copyright © 2015 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFieldISBN: UITextField!
    
  
    @IBOutlet weak var labelNombre: UILabel!
    
    
    @IBOutlet weak var labelAutor: UILabel!
    
    
    @IBOutlet weak var labelFecha: UILabel!
    
    @IBOutlet weak var bookSearchLoadingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtFieldISBN.delegate = self
        self.bookSearchLoadingIndicator.hidden = true
        self.labelNombre.hidden = true
        self.labelAutor.hidden = true
        self.labelFecha.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldDoneEditing(sender: UITextField) {
        
        sender.resignFirstResponder()
        
        self.labelNombre.hidden = true
        self.labelAutor.hidden = true
        self.labelFecha.hidden = true
        
        self.bookSearchLoadingIndicator.hidden = false
        self.bookSearchLoadingIndicator.startAnimating()
        
        var bookInfo = ("","","")
        
        if self.txtFieldISBN.text! != ""{
        
            bookInfo = self.getBookInfo(self.txtFieldISBN.text!)
        
            let bookName = bookInfo.0
            let bookAuthor = bookInfo.1
            let bookDate = bookInfo.2
            
            if bookName != "" && bookAuthor != "" && bookDate != ""{
         
                self.labelNombre.text! = bookName
                self.labelAutor.text! = bookAuthor
                self.labelFecha.text! = bookDate
                
                self.labelNombre.hidden = false
                self.labelAutor.hidden = false
                self.labelFecha.hidden = false
            
            }else{
                
                self.showSingleAlert("ERROR", message: "Se presento un problema estableciendo comunicación con openlibrary.org")
            }
            
            
        }else{
            
            self.showSingleAlert("Info...", message: "Por favor ingrese el ISBN del libro que desea buscar.")
        }
        
        self.bookSearchLoadingIndicator.stopAnimating()
        self.bookSearchLoadingIndicator.hidden = true

    }

    @IBAction func backgroundTap(sender: UIControl) {
        
        txtFieldISBN.resignFirstResponder()
    }
    
    func getBookInfo(isbn : String)->(bookName : String, bookAuthor : String, bookYear : String){
    
        let stringUrl = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=\(isbn)"
        let url = NSURL(string: stringUrl)
        let datos : NSData? = NSData(contentsOfURL: url!)
        var responseData : NSString?
        var response = ("","","")
        
        if datos != nil {
            
            responseData = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            print("Respuesta obtenida desde openlibrary.org: \n\t \(responseData!)")
            
            do{
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                
                let responseObject = jsonResponse as! NSDictionary
                let infoBook = responseObject["\(isbn)"]! as! NSDictionary
                //print (infoBook)
                let nombre = infoBook["title"]! as! NSString as String
                let autor = infoBook["by_statement"]! as! NSString as String
                let fecha =  infoBook["publish_date"]! as! NSString as String
                
                response =  (nombre, autor, fecha)
            
            }catch _{
            
                print("Error Serializando JSON")
                //alert
                self.showSingleAlert("ERROR", message: "Se presento un problema estableciendo comunicación con openlibrary.org")

            }
    
        }
        

        return response
    }
    
    func showSingleAlert(title:String, message:String){
    
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
    
    }

}

