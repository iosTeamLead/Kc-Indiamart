//
//  LoginViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 15/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPasswordVC.h"
#import "AppDelegate.h"
#import "SignUPViewController.h"
#import "UtilityText.h"
#import "Server.h"
#import "MyAccountViewController.h"

@interface LoginViewController (){
    
 
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation LoginViewController
@synthesize backButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [[GIDSignIn sharedInstance] signOut];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Table View Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UtilityText setViewMovedUp:YES view:self.view];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UtilityText setViewMovedUp:NO view:self.view];

    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==emailTextField)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890@."];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    if(textField.text.length<=0)
    {
        
        NSCharacterSet *myCharSet = [[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self .view endEditing: YES];
    [UtilityText setViewMovedUp:NO view:self.view];

    
    return  YES;
}
- (IBAction)tapAction:(id)sender {
    [UtilityText setViewMovedUp:NO view:self.view];
    
    
}


#pragma mark -Button Actions
- (IBAction)loginBtnPressed:(id)sender {
    [UtilityText setViewMovedUp:NO view:self.view];

    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
   
    
    
    if (emailTextField.text.length<=0 || passwordTextField.text.length<=0) {
        
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill all Fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else if ([emailTest evaluateWithObject:[emailTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] != YES  ){
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"you have enter wrong email or password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }

    else{
        
        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading......"];
        
        
      //  [[Server sharedManager] showToastInView:appDelegate.window.self.rootViewController toastMessage:@"Login SuccessFully" withDelay:3];
        
        NSString *str_token =[NSString stringWithFormat:@"%@",kGetValueForKey(@"token")];
        if ([str_token isEqualToString:@"(null)"]) {
            str_token =@"65564y457654756756756757";
        }
        NSMutableDictionary *dic =[NSMutableDictionary new];
        [dic setValue:emailTextField.text forKeyPath:@"Email"];
        [dic setValue:passwordTextField.text forKeyPath:@"Password"];
        [dic setValue:@"2" forKeyPath:@"DeviceType"];
        [dic setValue:str_token forKeyPath:@"DeviceId"];
        
        [[Server sharedManager]PostDataWithURL:Base_URL@"usersLogin" WithParameter:dic Success:^(NSMutableDictionary *Dic) {
           
            NSLog(@"Dic = %@",Dic);
            
            [[Server sharedManager]hideHUD];
            if ([[Dic valueForKey:@"message"]isEqualToString:@"Login Successfully."]) {
        
            kSetValueForKey(USER_DATA, Dic);
            kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
                kSetBoolValueForKey(Is_Login, YES);   

            [appDelegate.window.rootViewController removeFromParentViewController];
            [appDelegate homeRootTabControler];
            [[Server sharedManager] showToastInView:appDelegate.window.rootViewController toastMessage:@"Login SuccessFully" withDelay:3];
                
                
                
                
//                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"you have enter wrong email or password" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                

                
            }
        } Error:^(NSError *error) {
            
            [[Server sharedManager]hideHUD];
        }];
    }

 
 }
- (IBAction)forgotBtnPressed:(id)sender {
 ForgotPasswordVC *forgotVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
 [self.navigationController pushViewController:forgotVc animated:YES];
}
- (IBAction)createAccountPressed:(id)sender {
 SignUPViewController *signUpVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUPViewController"];
 [self.navigationController pushViewController:signUpVc animated:YES];
}

- (IBAction)facebookBtnPressed:(id)sender {
    
    kSetValueForKey(@"key", @"2");
    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading..."];
    
    [self facebookAction];
}

- (void)facebookAction
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    [loginManager logInWithReadPermissions:@[@"public_profile",@"email",@"user_location"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         
         if ([result.grantedPermissions containsObject:@"user_photos"])
         {
             NSLog(@"%@",result.token);
         }
         
         if ([FBSDKAccessToken currentAccessToken])
         {
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,picture.width(100).height(100),first_name,last_name,gender,hometown,locale,location "}]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (result)
                  {
                      [[Server sharedManager] showHUDInView:self.view hudMessage:@"LoadingData"];
                      NSLog(@"result : %@",[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]);
                      NSMutableDictionary *dic =[NSMutableDictionary new];
                      [dic setValue:[result valueForKey:@"email"] forKeyPath:@"Email"];
                  
                      
                      [[Server sharedManager]PostDataWithURL:Base_URL@"UserRegistration/isEmailEx" WithParameter:dic Success:^(NSMutableDictionary *Dic) {
                          
                          NSLog(@"Dic = %@",Dic);
                          if ( [[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
                              MyAccountViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
                              obj.userdataFromprev = [result  mutableCopy];
                              obj.isFromLeft = YES;
                              [self.navigationController pushViewController:obj animated:YES];
                              
                          }
                          else{
                              if ([[Dic valueForKey:@"message"]isEqualToString:@"Login Successfully."]) {
                                  
                                  kSetValueForKey(USER_DATA, Dic);
                                  kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
                                  kSetBoolValueForKey(Is_Login, YES);
                                  
                                  [appDelegate.window.rootViewController removeFromParentViewController];
                                  [appDelegate homeRootTabControler];
                                  //                [self.navigationController popViewControllerAnimated:YES];
                                  
                              }
                          }
                          
                          
                          [[Server sharedManager]hideHUD];
                          
                      } Error:^(NSError *error) {
                          
                          [[Server sharedManager]hideHUD];
                      }];

                      
                      
                      
                      
                  }
                  else{
                      NSLog(@"error : %@",[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]);

                  }
                  
                  
                  
                  
              }];
             [[Server sharedManager]hideHUD];
             
             
         }
         else if (![FBSDKAccessToken currentAccessToken]){
             [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Error while loading data" cancelTitle:@"OK"];

             [[Server sharedManager]hideHUD];
         }
     }];
}
- (IBAction)googlePlusBtnPressed:(id)sender {
    kSetValueForKey(@"key", @"1");
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {

    
    
    
    if(user == nil)
    {
        [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Error while loading data" cancelTitle:@"OK"];
    }
    else{
        NSURL *str_Url;
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        
        if (user.profile.hasImage) {
            str_Url =[user.profile imageURLWithDimension:300];
            NSLog(@"%@",str_Url);
        }
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setObject:email forKey:@"email"];
        [result setObject:givenName forKey:@"first_name"];
        [result setObject:familyName forKey:@"last_name"];
        [result setObject:fullName forKey:@"name"];
        [result setObject:idToken forKey:@"id"];
        
        
        
        
        
        
        [[Server sharedManager] showHUDInView:self.view hudMessage:@"LoadingData"];
        NSLog(@"result : %@",[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]);
        NSMutableDictionary *dic =[NSMutableDictionary new];
        [dic setValue:[result valueForKey:@"email"] forKeyPath:@"Email"];
        
        
        [[Server sharedManager]PostDataWithURL:Base_URL@"UserRegistration/isEmailEx" WithParameter:dic Success:^(NSMutableDictionary *Dic) {
            
            NSLog(@"Dic = %@",Dic);
            if ( [[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
                MyAccountViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
                obj.userdataFromprev = [result  mutableCopy];
                obj.isFromLeft = YES;
                [self.navigationController pushViewController:obj animated:YES];
                
            }
            else{
                if ([[Dic valueForKey:@"message"]isEqualToString:@"Login Successfully."]) {
                    
                    kSetValueForKey(USER_DATA, Dic);
                    kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
                    kSetBoolValueForKey(Is_Login, YES);
                    
                    [appDelegate.window.rootViewController removeFromParentViewController];
                    [appDelegate homeRootTabControler];
                    //                [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
            
            
            [[Server sharedManager]hideHUD];
            
        } Error:^(NSError *error) {
            
            [[Server sharedManager]hideHUD];
        }];
        

    }
    // Perform any operations on signed in user here.
  
    
    
    
    
   // [self SignupWithSocial:fullName Email:email Url:str_Url LoginWith:@"G"];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
    
    
    
    
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[GIDSignIn sharedInstance] signOut];
    
}




- (IBAction)backAction:(id)sender {
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];
       

    }
    else{
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}





@end
