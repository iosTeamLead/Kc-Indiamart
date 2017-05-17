//
//  RewardsViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 20/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "RewardsViewController.h"
#import "LoginViewController.h"
#import "RewardDetailView.h"
#import "Server.h"
#import "UtilityText.h"


@interface RewardsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RewardsViewController

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
- (IBAction)btnLeftPressed:(id)sender {
 [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnLoginPressed:(id)sender {
    
    LoginViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    view.isFromLeft = YES;
    [self.navigationController pushViewController:view animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    if (memberNumberTextField.text.length<=0 || memberLastName.text.length<=0) {
        [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Please Filled All Fields" cancelTitle:@"OK"];
    }
    else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:memberNumberTextField.text forKey:@"CustNum"];
        [dict setObject:memberLastName.text forKey:@"LastName"];
        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];

        
        [[Server sharedManager]PostDataWithURL:Base_URL@"UserRegistration/getCustomersRewards" WithParameter:dict Success:^(NSMutableDictionary *Dic) {
            
            NSLog(@"Dic = %@",Dic);
            
            [[Server sharedManager]hideHUD];
            if ([[Dic valueForKey:@"code"]isEqualToString:@"201"]) {
                RewardDetailView *next=[self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailView"];
                next.rewardDictionary = [Dic mutableCopy];
                [self.navigationController pushViewController:next animated:YES];
                
            }
            else{
                [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"ok"];
            }
        } Error:^(NSError *error) {
            
            [[Server sharedManager]hideHUD];
        }];


        
        
    }
    
    
}
@end
