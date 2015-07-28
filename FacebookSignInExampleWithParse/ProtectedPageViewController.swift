//
//  ProtectedPageViewController.swift
//  FacebookSignInExampleWithParse
//
//  Created by Sergey Kargopolov on 2015-07-27.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit
import Parse

class ProtectedPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var requestParameters = ["fields": "id, email, first_name, last_name"]
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
    
            if(error != nil)
            {
                println("\(error.localizedDescription)")
               return
            }
            
            if(result != nil)
            {
            
                let userId:String = result["id"] as! String
                let userFirstName:String? = result["first_name"] as? String
                let userLastName:String? = result["last_name"] as? String
                let userEmail:String? = result["email"] as? String
                
                
                println("\(userEmail)")
                
                let myUser:PFUser = PFUser.currentUser()!
                
                // Save first name
                if(userFirstName != nil)
                {
                    myUser.setObject(userFirstName!, forKey: "first_name")
                    
                }
                
                //Save last name
                if(userLastName != nil)
                {
                    myUser.setObject(userLastName!, forKey: "last_name")
                }
                
                // Save email address
                if(userEmail != nil)
                {
                    myUser.setObject(userEmail!, forKey: "email")
                }
                
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                // Get Facebook profile picture
                var userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                let profilePictureUrl = NSURL(string: userProfile)
                
                let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                
                if(profilePictureData != nil)
                {
                    let profileFileObject = PFFile(data:profilePictureData!)
                    myUser.setObject(profileFileObject, forKey: "profile_picture")
                }
                
                
                myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                  
                    if(success)
                    {
                        println("User details are now updated")
                    }
                    
                })
                
                
                
                }
                
               
                
                
                
                
                
            }
            
            
            
            
        }
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonTapped(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            
            let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            let loginPageNav = UINavigationController(rootViewController: loginPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = loginPageNav
            
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
