//
//  LoginViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 15/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate>
{
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *passwordTextField;
    
}
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backAction:(id)sender;
@property(nonatomic) BOOL isFromLeft;

@end
