//
//  SignUPViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 15/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "SignUPViewController.h"
#import "Server.h"
#import "termsNCondtionsView.h"


@interface SignUPViewController ()
{
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *lastNameTextField;
    __weak IBOutlet UITextField *birthdayTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *paswordTextField;
    __weak IBOutlet UITextField *confirmPasswordTextField;
    __weak IBOutlet UITextField *phoneTextField;
    __weak IBOutlet UIView *dobView;
    __weak IBOutlet UIDatePicker *datePIckerView;
    UIVisualEffectView *blurEffectView;
    NSString *dateString;
    
    
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnTermANdCondition;

@end

@implementation SignUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
 [super viewDidAppear:animated];
  self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnBackPressed:(id)sender {
 [self.navigationController popViewControllerAnimated:YES]; 
}
- (IBAction)btnSignUPPressed:(id)sender {
   
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
   
    if (nameTextField.text.length<=0 ||lastNameTextField.text.length<=0|| birthdayTextField.text<=0 || phoneTextField.text.length<=0 || emailTextField.text.length<=0|| paswordTextField.text.length<=0|| confirmPasswordTextField.text.length<=0) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill all Fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else if ([emailTest evaluateWithObject:[emailTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] != YES  ){
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter valid Email" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else  if(![paswordTextField.text isEqualToString:confirmPasswordTextField.text])
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter both password same" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if(phoneTextField.text.length<=7){
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter correct mobile number " preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    
    else{
        
// FirstName,LastName,Phone,Email,Password,BirthDate,Region,Address1,Address2,City,State,Zipcode,SwipeId,DeviceType,DeviceId
        
        NSMutableDictionary *userData=[[NSMutableDictionary alloc] init];
        [userData setObject:nameTextField.text forKey:@"FirstName"];
        [userData setObject:lastNameTextField.text forKey:@"LastName"];

        [userData setObject:dateString forKey:@"BirthDate"];
        
        
        
        [userData setObject:phoneTextField.text forKey:@"Phone"];
        [userData setObject:emailTextField.text forKey:@"Email"];
        [userData setObject:paswordTextField.text forKey:@"Password"];
        [userData setObject:@"" forKey:@"Region"];
        [userData setObject:@"" forKey:@"Address1"];
        [userData setObject:@"" forKey:@"Address2"];
        [userData setObject:@"" forKey:@"City"];
        [userData setObject:@"" forKey:@"State"];
        [userData setObject:@"" forKey:@"Zipcode"];
        [userData setObject:@"" forKey:@"SwipeId"];
        [userData setObject:@"E" forKey:@"LoginWith"];

        
//        [userData setObject:@"101" forKey:@"userid"];
//        kSetValueForKey(USER_DATA, userData);
//        kSetValueForKey(KMGUserId, @"101");
//        http://webservices.com.kcimart.com/kcindia_app/webservices/registration
        
        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading......"];
        NSString *str_token =[NSString stringWithFormat:@"%@",kGetValueForKey(@"token")];
        if ([str_token isEqualToString:@"(null)"]) {
            str_token =@"65564y457654756756756757";
        }
        [userData setValue:@"2" forKeyPath:@"DeviceType"];
        [userData setValue:str_token forKeyPath:@"DeviceId"];
        
        NSLog(@"%@",userData);
        [[Server sharedManager]PostDataWithURL:Base_URL@"registration" WithParameter:userData Success:^(NSMutableDictionary *Dic) {
            
            NSLog(@"Dic = %@",Dic);
            if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
                [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"OK"];
                [[Server sharedManager]hideHUD];

            }
            else{
            [[Server sharedManager]hideHUD];
            if ([[Dic valueForKey:@"code"]isEqualToString:@"201"]) {
                
                kSetValueForKey(USER_DATA, Dic);
                kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
                kSetBoolValueForKey(Is_Login, YES);
                [appDelegate.window.rootViewController removeFromParentViewController];
                [appDelegate homeRootTabControler];
            }
            }
        } Error:^(NSError *error) {
            
            [[Server sharedManager]hideHUD];
        }];
    }

        
        
        
//        [appDelegate.window.rootViewController removeFromParentViewController];
//        [appDelegate homeRootTabControler];
    }
    
    
    
   
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UtilityText setViewMovedUp:YES view:self.view];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UtilityText setViewMovedUp:NO view:self.view];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    [self .view endEditing: YES];
    [UtilityText setViewMovedUp:NO view:self.view];
    
    return  YES;
}
- (IBAction)tapAction:(id)sender {
    [UtilityText setViewMovedUp:NO view:self.view];
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField==nameTextField | textField == lastNameTextField)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
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

    
    if(textField==emailTextField)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@.1234567890"];
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
        if(textField==phoneTextField )
        {
            if (textField.text.length<=15) {
                NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
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
            else{
                if ([string isEqualToString:@""]) {
                    return YES;
                }
                return NO;
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
- (IBAction)sideBarPressed:(id)sender {
 MMDrawer *drawer = (MMDrawer *)[[self parentViewController] parentViewController];
 [drawer toggleDrawerSide: MMDrawerSideLeft animated:YES completion:^(BOOL finished) { }];
 
}
- (IBAction)cancelDatePIcker:(id)sender {
    blurEffectView.hidden=YES;
//    self.view.backgroundColor = [UIColor whiteColor];
    dobView.hidden=YES;

}
- (IBAction)submitDatePicker:(id)sender {
    NSLog(@"%@ ",datePIckerView.date);
    blurEffectView.hidden=YES;
//    self.view.backgroundColor = [UIColor whiteColor];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM, yyyy"];
    NSString *prettyVersion = [dateFormat stringFromDate:datePIckerView.date];
      birthdayTextField.text=prettyVersion;
    dobView.hidden=YES;

    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    dateString = [dateFormat stringFromDate:datePIckerView.date];
    
}


- (IBAction)bdayButton:(id)sender {
    
    
    [self.view endEditing:YES];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        [self.view addSubview:blurEffectView];
        [datePIckerView setMaximumDate:[NSDate date]];
        dobView.hidden=NO;

        [self.view bringSubviewToFront:dobView];
        
        
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
    
}

- (IBAction)termNcondition:(id)sender {
    termsNCondtionsView *next=[self.storyboard instantiateViewControllerWithIdentifier:@"termsNCondtionsView"];
    [self.navigationController pushViewController:next animated:YES];
    
}



@end
