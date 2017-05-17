//
//  ChangePasswordViewController.m
//  Grocery App
//
//  Created by eweba1-pc-69 on 12/3/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Server.h"

@interface ChangePasswordViewController ()


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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








- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField !=_testOldPwd) {
        [UtilityText setViewMovedUp:YES view:self.view];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField !=_testOldPwd) {
        [UtilityText setViewMovedUp:NO view:self.view];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
        [self .view endEditing: YES];
    [UtilityText setViewMovedUp:NO view:self.view];
    
    return  YES;
}



- (IBAction)actnGesture:(id)sender {
    
    [UtilityText setViewMovedUp:NO view:self.view];
    [self.view endEditing:YES];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender {
    
    [UtilityText setViewMovedUp:NO view:self.view];
    [self.view endEditing:YES];
    if (_testOldPwd.text.length <= 0 || _textNewPwd.text.length <= 0 || _textConfirmPwd.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all detail" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
        [alert show];
    
}
    else if (![_textNewPwd.text isEqualToString:_textConfirmPwd.text]){
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"New Password and Confirmed Password doesn't Match" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        
        
    }
    
    
    else {
     
        NSLog(@"%@",kGetValueForKey(USER_DATA));
        
    // http://kcimartc.wwwls19.a2hosted.com/kcindia_app/webservices/changePassword
        
        
        NSMutableDictionary *password = [[NSMutableDictionary alloc]init];
    
    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading......"];
        
        if (kGetValueForKey(USER_DATA)) {
            [password setObject:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"] forKey:@"UserId"];
            [password setObject:_testOldPwd.text  forKey:@"OldPassword"];
            [password setObject:_textNewPwd.text forKey:@"NewPassword"];
            
        }
        
        [[Server sharedManager]PostDataWithURL:Base_URL@"changePassword" WithParameter:password Success:^(NSMutableDictionary *Dic) {
        
            NSLog(@"dic%@",Dic);
            if ( [[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Old  Password  doesn't match" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                
                
                kRemoveObjectForKey(KMGUserId);
                kRemoveObjectForKey(Is_Login);
                kRemoveObjectForKey(USER_DATA);
                
                [appDelegate.window.rootViewController removeFromParentViewController];
                
                [appDelegate homeRootTabControler];
                
                NSLog(@"you pressed Yes, please button");
                
                
                
                [appDelegate.window.rootViewController removeFromParentViewController];
                [appDelegate homeRootTabControler];
                [[Server sharedManager] showToastInView:appDelegate.window.rootViewController toastMessage:@"Password Change SuccessFully" withDelay:3];
            }
            
            
            
            [[Server sharedManager]hideHUD];
            
            
         

        }Error:^(NSError *error) {
            
            
            

            
            NSLog(@"error%@" ,[error localizedDescription]);
        }];
         }
}

@end


