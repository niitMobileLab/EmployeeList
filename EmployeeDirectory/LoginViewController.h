//
//  LoginViewController.h
//  ProductCatalogue
//
//  Created by Naveen on 4/19/16.
//  Copyright © 2016 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProtocol.h"

@interface LoginViewController : UIViewController< UITextFieldDelegate, MyProtocol>
{
    IBOutlet UITextField *userNameField;
    IBOutlet UITextField *pwdField;
    
}
-(IBAction)signInPressed:(id)sender;
-(void)showNextScreen;
-(void)validateCredentials:(NSString*)userName password:(NSString*)pwd;
-(void)showAlert:(NSString*)msg;

@end
