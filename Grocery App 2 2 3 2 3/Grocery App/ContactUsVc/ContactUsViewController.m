//
//  ContactUsViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Server.h"
#import "UtilityText.h"

@interface ContactUsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtView;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.txtView.placeholder =@"Comment Here";
    
 self.txtView.layer.borderColor = [[UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1.0] CGColor];
 self.txtView.layer.borderWidth = 1.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sideBtnPressed:(id)sender {
    [appDelegate.window.rootViewController removeFromParentViewController];
    [appDelegate homeRootTabControler];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSubmit:(id)sender {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    

    if (_textEmail.text.length == 0 || _textView.text.length ==0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all detail" delegate:self cancelButtonTitle:@"oK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else if ([emailTest evaluateWithObject:[_textEmail.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] != YES  ){
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter valid Email" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
    else{
        
        [[Server sharedManager] showHUDInView:self.view hudMessage:@"Loading"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:_textEmail.text forKey:@"Email"];
        [data setObject:self.textView.text forKey:@"Notes"];
        
        
        [[Server sharedManager]PostDataWithURL:Base_URL@"UserRegistration/mail" WithParameter:data Success:^(NSMutableDictionary *Dic) {
            
            NSLog(@"%@",Dic);
            
            [appDelegate.window.rootViewController removeFromParentViewController];
            [appDelegate homeRootTabControler];
            [[Server sharedManager] showToastInView:appDelegate.window.rootViewController toastMessage:@"Thanks for the Feedback" withDelay:3];
            [[Server sharedManager] hideHUD];
            
        } Error:^(NSError *error) {
            NSLog(@"errpt");
        }
   ];
    
    }
    
    
    

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}


@end
