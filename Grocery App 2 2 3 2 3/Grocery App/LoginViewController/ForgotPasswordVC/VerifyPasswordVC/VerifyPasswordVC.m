//
//  VerifyPasswordVC.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 15/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "VerifyPasswordVC.h"
#import "Server.h"
@interface VerifyPasswordVC ()
{
    __weak IBOutlet UITextField *otpTExtField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UITextField *confirmPasswordTextField;
    
}
@end

@implementation VerifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
- (IBAction)btnBackToLogin:(id)sender {
 [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)savePassword:(id)sender {
    if (otpTExtField.text.length<=0 || passwordTextField.text.length<=0 ||  confirmPasswordTextField.text.length<=0) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill all Fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else  if(![passwordTextField.text isEqualToString:confirmPasswordTextField.text])
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"New password and confirm password doesn't match" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else if (otpTExtField.text.length != 6)  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"user id and or password not matched" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

    else{
        
        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading......"];
        NSDictionary *diction =kGetValueForKey(USER_DATA);
        NSMutableDictionary *dic =[NSMutableDictionary new];
        
        
        [dic setValue:confirmPasswordTextField.text forKey:@"NewPassword"];
        [dic setValue:[diction valueForKey:@"Password"] forKey:@"OldPassword"];
        [dic setValue:[diction valueForKey:@"CustNum"] forKey:@"UserId"];
        
        
        [[Server sharedManager]PostDataWithURL:Base_URL@"changePassword" WithParameter:dic Success:^(NSMutableDictionary *Dic) {
            
            NSLog(@"Dic = %@",Dic);
            
            [[Server sharedManager]hideHUD];
            if ([[Dic valueForKey:@"message"]isEqualToString:@"user id and or password not matched"]) {
                
                UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert" message:[Dic valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *btn_Ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:btn_Ok];
                [self presentViewController:alert animated:YES completion:nil];
                
                return ;
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];

            
        } Error:^(NSError *error) {
           
            [[Server sharedManager]hideHUD];
        }];

    }

}

@end
