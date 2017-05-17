//
//  MyAccountViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "MyAccountViewController.h"
#import "Server.h"
#import "ChangePasswordViewController.h"
static BOOL notLoaded;
static NSMutableArray *stateCityArray;
@interface MyAccountViewController ()
{
    NSMutableDictionary *userData;
    UIVisualEffectView *blurEffectView;
    NSMutableArray *showAbleArray;
    bool isState,hasCity;
    NSString *bdayString;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    
    userData = kGetValueForKey(USER_DATA);
    
    
    if (userData !=nil) {
        nameTextField.text= [userData valueForKey:@"First_Name"];
                            
                            
           LastName.text =[userData valueForKey:@"Last_Name"];
        
        
        
        
        
        emailTextField.text=[userData valueForKey:@"Email"];
        mobileTextField.text=[userData valueForKey:@"Phone"];
        NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"YYYY-MM-dd"];
        NSDate *dobDate=[dateformat dateFromString:[userData valueForKey:@"Birth_Date"]];
        [dateformat setDateFormat:@"dd MMMM, yyyy"];
        bdayTextField.text=[dateformat stringFromDate:dobDate];
        
        //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //    [dateFormat setDateFormat:@"dd MMMM, yyyy"];
        //    NSDate *prettyVersion = [dateFormat dateFromString:[userData valueForKey:@"Birth_Date"]];
//        [datePIckerView setDate:dobDate];
        bdayString = [dateformat stringFromDate:dobDate];
        
        isState = YES;
        hasCity = YES;
        if ([userData valueForKey:@"Address1"]!=nil) {
            addressTextField.text=[userData valueForKey:@"Address1"];
        }
        if ([userData valueForKey:@"Zipcode"]!=nil) {
            zipTextFields.text=[userData valueForKey:@"Zipcode"];
        }
        if ([userData valueForKey:@"City"]!=nil) {
            cityTextField.text=[userData valueForKey:@"City"];
        }
        if ([userData valueForKey:@"State"]!=nil) {
            stateTextField.text=[userData valueForKey:@"State"];
        }

    }
    else{
        
        NSLog(@"%@",_userdataFromprev);
        nameTextField.text=[_userdataFromprev valueForKey:@"first_name"];
        LastName.text = [_userdataFromprev valueForKey:@"last_name"];
        emailTextField.text=[_userdataFromprev valueForKey:@"email"];
        mobileTextField.text=@""    ;
//        NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
//        [dateformat setDateFormat:@"YYYY-MM-dd"];
//        NSDate *dobDate=[dateformat dateFromString:[userData valueForKey:@"Birth_Date"]];
//        [dateformat setDateFormat:@"dd MMMM, yyyy"];
//        bdayTextField.text=[dateformat stringFromDate:dobDate];
        
        //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //    [dateFormat setDateFormat:@"dd MMMM, yyyy"];
        //    NSDate *prettyVersion = [dateFormat dateFromString:[userData valueForKey:@"Birth_Date"]];
        [datePIckerView setMaximumDate:[NSDate date]];
//        bdayString = [dateformat stringFromDate:dobDate];
        
        isState = YES;
        hasCity = YES;
        if ([userData valueForKey:@"Address1"]!=nil) {
            addressTextField.text=[userData valueForKey:@"Address1"];
        }
        if ([userData valueForKey:@"Zipcode"]!=nil) {
            zipTextFields.text=[userData valueForKey:@"Zipcode"];
        }
        if ([userData valueForKey:@"City"]!=nil) {
            cityTextField.text=[userData valueForKey:@"City"];
        }
        if ([userData valueForKey:@"State"]!=nil) {
            stateTextField.text=[userData valueForKey:@"State"];
        }
        

    }
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }

    [self getStateCity];
    
    
    
    
    
    
    
}
-(void) getStateCity{
    
    //    http://webservices.com.kcimart.com/kcindia_app/webservices/CountriesStateCity/getStates
    
    
    if (!notLoaded)
    {
        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
        NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
        [data setObject:@"231" forKey:@"CountryId"];
        [[Server sharedManager] PostDataWithURL:Base_URL@"CountriesStateCity/getStates" WithParameter:data Success:^(NSMutableDictionary *Dic) {
            NSLog(@"%@ ",Dic);
            if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
                [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
            }
            else{
                stateCityArray = [[NSMutableArray alloc] init];
                
                stateCityArray = [[Dic valueForKey:@"Data"] mutableCopy];
                
                showAbleArray = [[Dic valueForKey:@"Data"] mutableCopy];
                [pickerView  reloadAllComponents];
                notLoaded = YES;
            }
            [[Server sharedManager]hideHUD];
            
            
        } Error:^(NSError *error) {
            
            NSLog(@"%@",[error localizedDescription]);
        }];
        
    }
    else{
        
        //        stateCityArray = [[Dic valueForKey:@"Data"] mutableCopy];
        //
        //        notLoaded = NO;
        showAbleArray = [stateCityArray mutableCopy];
        [pickerView  reloadAllComponents];
    }
    
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [showAbleArray count];
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [[showAbleArray objectAtIndex:row]  valueForKey:@"name"];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField !=mobileTextField) {
        [UtilityText setViewMovedUp:YES view:self.view];

    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField !=mobileTextField) {
        [UtilityText setViewMovedUp:NO view:self.view];
        
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//      [self .view endEditing: YES];
    if (textField !=mobileTextField) {
        [UtilityText setViewMovedUp:NO view:self.view];
        
        
    }
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)tapAction:(id)sender {
    [UtilityText setViewMovedUp:NO view:self.view];
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField==nameTextField)
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
    if(textField==mobileTextField||textField==zipTextFields)
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



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + changePaswordButton.frame.size.height + 10);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)sideBarPressed:(id)sender {
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)changePasswordAction:(id)sender {
  
    
    ChangePasswordViewController *avnv = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:avnv animated:YES];

    
}

- (IBAction)submitAction:(id)sender {
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    
    if ( hasCity) {
        if (nameTextField.text.length<=0 || LastName.text.length <=0 || bdayTextField.text<=0 || bdayString.length <=0 || mobileTextField.text.length<=0 || emailTextField.text.length<=0|| addressTextField.text.length<=0|| zipTextFields.text.length<=0|| cityTextField.text.length<=0|| stateTextField.text.length<=0) {
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
        else if(mobileTextField.text.length<=7){
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter correct mobile number " preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        else{
            //      FirstName,LastName,Phone,Email,Password,BirthDate,Region,Address1,Address2,City,State,Zipcode,SwipeId,DeviceType,DeviceId
            //        CustNum,FirstName,LastName,BirthDate,Region,Address1,Address2,City,State,Zipcode,DeviceType,DeviceId
            
            
            if (userData ==nil) {
                NSMutableDictionary *userData1=[[NSMutableDictionary alloc] init];
                [userData1 setObject:nameTextField.text forKey:@"FirstName"];
                [userData1 setObject:[LastName.text valueForKey:@"last_name"] forKey:@"LastName"];
                [userData1 setObject:bdayString forKey:@"BirthDate"];
                [userData1 setObject:mobileTextField.text forKey:@"Phone"];
                [userData1 setObject:emailTextField.text forKey:@"Email"];
                [userData1 setObject:@"" forKey:@"Password"];
                [userData1 setObject:@"" forKey:@"Region"];
                [userData1 setObject:addressTextField.text forKey:@"Address1"];
                [userData1 setObject:addressTextField.text forKey:@"Address2"];
                
                
                [userData1 setObject:zipTextFields.text forKey:@"Zipcode"];
                [userData1 setObject:cityTextField.text forKey:@"City"];
                [userData1 setObject:stateTextField.text forKey:@"State"];
                [userData1 setObject:@"F" forKey:@"LoginWith"];

                //        [userData1 setObject:@"" forKey:@"SwipeId"];
                NSString *str_token =[NSString stringWithFormat:@"%@",kGetValueForKey(@"token")];
                if ([str_token isEqualToString:@"(null)"]) {
                    str_token =@"65564y457654756756756757";
                }
                [userData1 setValue:@"2" forKeyPath:@"DeviceType"];
                [userData1 setValue:str_token forKeyPath:@"DeviceId"];

           
                
                //        [userData setObject:@"101" forKey:@"userid"];
                //        kSetValueForKey(USER_DATA, userData);
                //        kSetValueForKey(KMGUserId, @"101");
                //        http://webservices.com.kcimart.com/kcindia_app/webservices/registration
                
                [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading......"];
                              NSLog(@"%@",userData1);
                [[Server sharedManager]PostDataWithURL:Base_URL@"registration" WithParameter:userData1 Success:^(NSMutableDictionary *Dic) {
                    
                    NSLog(@"Dic = %@",Dic);
                    
                    [[Server sharedManager]hideHUD];
                    if ([[Dic valueForKey:@"code"]isEqualToString:@"201"]) {
                        
                        kSetValueForKey(USER_DATA, Dic);
                        kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
                        kSetBoolValueForKey(Is_Login, YES);
                        [appDelegate.window.rootViewController removeFromParentViewController];
                        [appDelegate homeRootTabControler];
                        
                    }
                } Error:^(NSError *error) {
                    
                    [[Server sharedManager]hideHUD];
                }];
            }
    
            else{
            [UtilityText setViewMovedUp:NO view:self.view];
            
            NSMutableDictionary *userData1=[[NSMutableDictionary alloc] init];
            [userData1 setObject:nameTextField.text forKey:@"FirstName"];
            [userData1 setObject:LastName.text forKey:@"LastName"];
            [userData1 setObject:bdayString forKey:@"BirthDate"];
            [userData1 setObject:mobileTextField.text forKey:@"Phone"];
            [userData1 setObject:emailTextField.text forKey:@"Email"];
            [userData1 setObject:[userData valueForKey:@"Password"] forKey:@"Password"];
            [userData1 setObject:@"" forKey:@"Region"];
            
            
            [userData1 setObject:[userData valueForKey:@"CustNum"] forKey:@"CustNum"];
            [userData1 setObject:addressTextField.text forKey:@"Address1"];
            [userData1 setObject:addressTextField.text forKey:@"Address2"];
            
            [userData1 setObject:zipTextFields.text forKey:@"Zipcode"];
            [userData1 setObject:cityTextField.text forKey:@"City"];
            [userData1 setObject:stateTextField.text forKey:@"State"];
            
            //        [userData1 setObject:@"" forKey:@"SwipeId"];
            NSString *str_token =[NSString stringWithFormat:@"%@",kGetValueForKey(@"token")];
            if ([str_token isEqualToString:@"(null)"]) {
                str_token =@"65564y457654756756756757";
            }
            [userData1 setValue:@"2" forKeyPath:@"DeviceType"];
            [userData1 setValue:str_token forKeyPath:@"DeviceId"];
            
            //        kSetValueForKey(USER_DATA, userData1);
            //    kSetValueForKey(KMGUserId,[userData1 valueForKey:@"CustNum"]);
            
            
            [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
            
            [[Server sharedManager] PostDataWithURL:Base_URL@"userProfileUpdate" WithParameter:userData1 Success:^(NSMutableDictionary *Dic) {
                NSLog(@"%@ ",Dic);
                if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
                    [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
                }
                else{
                    [[Server sharedManager] hideHUD];
                    
                    kSetValueForKey(USER_DATA, Dic);
                    kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
//                    [UtilityText showAlertWithAlert:self Alert:@"Success" message:@"Profile Updated Successfully." cancelTitle:@"OK"];
                    
                    [appDelegate.window.rootViewController removeFromParentViewController];
                    [appDelegate homeRootTabControler];
                    [[Server sharedManager] showToastInView:appDelegate.window.rootViewController toastMessage:@"Profile Updated Successfully" withDelay:3];
                    
                    
                }
                [[Server sharedManager]hideHUD];
                
                
            } Error:^(NSError *error) {
                
                NSLog(@"%@",[error localizedDescription]);
            }];
            }
            
        }
    }
    else if (!hasCity){
        if (nameTextField.text.length<=0 || bdayTextField.text<=0 || LastName.text.length <=0 || bdayString.length <=0 || mobileTextField.text.length<=0 || emailTextField.text.length<=0|| addressTextField.text.length<=0|| zipTextFields.text.length<=0|| stateTextField.text.length<=0) {
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
        else if(mobileTextField.text.length<=7){
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter correct mobile number " preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else{
            //      FirstName,LastName,Phone,Email,Password,BirthDate,Region,Address1,Address2,City,State,Zipcode,SwipeId,DeviceType,DeviceId
            //        CustNum,FirstName,LastName,BirthDate,Region,Address1,Address2,City,State,Zipcode,DeviceType,DeviceId
          
            
            if (userData ==nil) {
                NSMutableDictionary *userData1=[[NSMutableDictionary alloc] init];
                [userData1 setObject:nameTextField.text forKey:@"FirstName"];
            [userData1 setObject:LastName.text forKey:@"LastName"];
                
//            forKey:@"LastName"];
                [userData1 setObject:bdayString forKey:@"BirthDate"];
                [userData1 setObject:mobileTextField.text forKey:@"Phone"];
                [userData1 setObject:emailTextField.text forKey:@"Email"];
                [userData1 setObject:@"" forKey:@"Password"];
                [userData1 setObject:@"" forKey:@"Region"];
                [userData1 setObject:addressTextField.text forKey:@"Address1"];
                [userData1 setObject:addressTextField.text forKey:@"Address2"];
                [userData1 setObject:zipTextFields.text forKey:@"Zipcode"];
                [userData1 setObject:cityTextField.text forKey:@"City"];
                [userData1 setObject:stateTextField.text forKey:@"State"];
                [userData1 setObject:@"F" forKey:@"LoginWith"];
                
                //        [userData1 setObject:@"" forKey:@"SwipeId"];
                NSString *str_token =[NSString stringWithFormat:@"%@",kGetValueForKey(@"token")];
                if ([str_token isEqualToString:@"(null)"]) {
                    str_token =@"65564y457654756756756757";
                }
                [userData1 setValue:@"2" forKeyPath:@"DeviceType"];
                [userData1 setValue:str_token forKeyPath:@"DeviceId"];
                
                
                
                //        [userData setObject:@"101" forKey:@"userid"];
                //        kSetValueForKey(USER_DATA, userData);
                //        kSetValueForKey(KMGUserId, @"101");
                //        http://webservices.com.kcimart.com/kcindia_app/webservices/registration
                
                [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading......"];
                NSLog(@"%@",userData1);
                [[Server sharedManager]PostDataWithURL:Base_URL@"registration" WithParameter:userData1 Success:^(NSMutableDictionary *Dic) {
                    
                    NSLog(@"Dic = %@",Dic);
                    
                    [[Server sharedManager]hideHUD];
                    if ([[Dic valueForKey:@"code"]isEqualToString:@"201"]) {
                        
                        kSetValueForKey(USER_DATA, Dic);
                        kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
                        kSetBoolValueForKey(Is_Login, YES);
                        [appDelegate.window.rootViewController removeFromParentViewController];
                        [appDelegate homeRootTabControler];
                        
                    }
                } Error:^(NSError *error) {
                    
                    [[Server sharedManager]hideHUD];
                }];

            }
            else{
            
            [UtilityText setViewMovedUp:NO view:self.view];
            
            NSMutableDictionary *userData1=[[NSMutableDictionary alloc] init];
            [userData1 setObject:nameTextField.text forKey:@"FirstName"];
            [userData1 setObject:LastName.text forKey:@"LastName"];
            [userData1 setObject:bdayString forKey:@"BirthDate"];
            [userData1 setObject:mobileTextField.text forKey:@"Phone"];
            [userData1 setObject:emailTextField.text forKey:@"Email"];
            [userData1 setObject:[userData valueForKey:@"Password"] forKey:@"Password"];
            [userData1 setObject:@"" forKey:@"Region"];
            
            
            [userData1 setObject:[userData valueForKey:@"CustNum"] forKey:@"CustNum"];
            [userData1 setObject:addressTextField.text forKey:@"Address1"];
            [userData1 setObject:addressTextField.text forKey:@"Address2"];
            
            [userData1 setObject:zipTextFields.text forKey:@"Zipcode"];
            [userData1 setObject:cityTextField.text forKey:@"City"];
            [userData1 setObject:stateTextField.text forKey:@"State"];
            
            //        [userData1 setObject:@"" forKey:@"SwipeId"];
            NSString *str_token =[NSString stringWithFormat:@"%@",kGetValueForKey(@"token")];
            if ([str_token isEqualToString:@"(null)"]) {
                str_token =@"65564y457654756756756757";
            }
            [userData1 setValue:@"2" forKeyPath:@"DeviceType"];
            [userData1 setValue:str_token forKeyPath:@"DeviceId"];
            
            //        kSetValueForKey(USER_DATA, userData1);
            //    kSetValueForKey(KMGUserId,[userData1 valueForKey:@"CustNum"]);
            
            
            [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
            
            [[Server sharedManager] PostDataWithURL:Base_URL@"userProfileUpdate" WithParameter:userData1 Success:^(NSMutableDictionary *Dic) {
                NSLog(@"%@ ",Dic);
                if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
                    [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
                }
                else{
                    [[Server sharedManager] hideHUD];
                    
                    kSetValueForKey(USER_DATA, Dic);
                    kSetValueForKey(KMGUserId,[Dic valueForKey:@"CustNum"]);
                   [UtilityText showAlertWithAlert:self Alert:@"Success" message:@"Profile Updated Successfully." cancelTitle:@"OK"];
                    
                    

                    
                }
                [[Server sharedManager]hideHUD];
                
                
            } Error:^(NSError *error) {
                
                NSLog(@"%@",[error localizedDescription]);
            }];
        }
        }
    }
    
    //
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
    bdayTextField.text=prettyVersion;
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    bdayString = [dateFormat stringFromDate:datePIckerView.date];
    
    dobView.hidden=YES;
    
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

- (IBAction)selectState:(id)sender {
    [self.view endEditing:YES];
    //    [self setViewMovedUp:NO];
    //    isAddressPicker=YES;
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        //        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        stateCityPickerView.hidden=NO;
        showAbleArray = [stateCityArray mutableCopy];
        cityTextField.text=@"";
        
        
        [pickerView reloadAllComponents];
        isState = YES;
        
        [self.view addSubview:blurEffectView];
        [self.view bringSubviewToFront:stateCityPickerView];
        
        
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
    
    
    
    
}
- (IBAction)selectCity:(id)sender {
    
    [self.view endEditing:YES];
    showAbleArray = [[[stateCityArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"city"]mutableCopy];
    if ( showAbleArray.count <=0) {
        [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Thre is no city" cancelTitle:@"OK"];
    }
    else{
        
        
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            //        self.view.backgroundColor = [UIColor clearColor];
            
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.frame = self.view.bounds;
            blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            isState = NO;
            [pickerView reloadAllComponents];
            
            [self.view addSubview:blurEffectView];
            stateCityPickerView.hidden=NO;
            
            [self.view bringSubviewToFront:stateCityPickerView];
            
            
        }
        else {
            self.view.backgroundColor = [UIColor blackColor];
        }
    }
    
    
}

- (IBAction)submitCategory:(id)sender {
    stateCityPickerView.hidden=YES;
    
    if (isState) {
        stateTextField.text=[[showAbleArray objectAtIndex:[pickerView selectedRowInComponent:0] ] valueForKey:@"name"];
        //        showAbleArray = [stateCityArray mutableCopy];
        if ([[[stateCityArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"city"] count]<=0) {
            hasCity = NO;
        }
        else{
            hasCity = YES;
        }
        
        
    }
    else{
        //        showAbleArray = [[[stateCityArray objectAtIndex:[pickerView selectedRowInComponent:0]] valueForKey:@"city"]mutableCopy];
        cityTextField.text=[[showAbleArray objectAtIndex:[pickerView selectedRowInComponent:0] ] valueForKey:@"name"];
        
    }
    
    
    //        stateTextField.text=[dropDownArray2 objectAtIndex:[_CategoryPickerView selectedRowInComponent:0]];
    //    self.ddText2.textColor=[UIColor colorWithRed:58/255.0f green:59/255.0f blue:59/255.0f alpha:1];
    //
    //    _categoryPicker.hidden=YES;
    blurEffectView.hidden=YES;
    //    self.view.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
    
}

- (IBAction)cancelCategory:(id)sender {
    stateCityPickerView.hidden=YES;
    blurEffectView.hidden=YES;
    //    self.view.backgroundColor = [UIColor colorWithRed:213/255.0f green:213/255.0f blue:213/255.0f alpha:1];
    
}






@end
