//
//  ForgotPasswordVC.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 15/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "VerifyPasswordVC.h"
#import "Server.h"
@interface ForgotPasswordVC ()
{
    __weak IBOutlet UITextField *emailTextField;
    
}
@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackToLogin:(id)sender {
 [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)nextBtnPressed:(id)sender {
    
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
     if (emailTextField.text.length<=0 ){
         
         UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter valid Email" preferredStyle:UIAlertControllerStyleAlert];
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
    else {
    
        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading....."];
        NSMutableDictionary *dic =[NSMutableDictionary new];
        
        [dic setValue:emailTextField.text forKey:@"Email"];
        
        [[Server sharedManager]PostDataWithURL:Base_URL@"forgotPassword" WithParameter:dic Success:^(NSMutableDictionary *Dic) {
           
            NSLog(@"Dic = %@",Dic);
            //message":"No User Found with This Email Id ."
            
            [[Server sharedManager]hideHUD];
            if ([[Dic valueForKey:@"message"]isEqualToString:@"No User Found with This Email Id ."]) {
                
                UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert" message:[Dic valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *btn_Ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:btn_Ok];
                [self presentViewController:alert animated:YES completion:nil];
                
                return ;
            }
            
            VerifyPasswordVC * verifyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyPasswordVC"];
            [self.navigationController pushViewController:verifyVC animated:YES];
            
        } Error:^(NSError *error) {
            
            [[Server sharedManager]hideHUD];
        }];
        
    }
}

@end
