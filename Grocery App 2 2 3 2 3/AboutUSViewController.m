//
//  AboutUSViewController.m
//  Grocery App
//
//  Created by eweba1-pc-80 on 10/5/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "AboutUSViewController.h"

#import "privacy Policy.h"
#import "termsNCondtionsView.h"

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (screenWidth==320 && screenHeight == 480) {                      //4s
        _kcIndiaMartLabe.font=[UIFont systemFontOfSize:10.0f];
    }
    else if (screenWidth==320 && screenHeight == 568) {                 //5s
        _kcIndiaMartLabe.font=[UIFont systemFontOfSize:11.0f];
    }
    else if (screenWidth==375 && screenHeight == 667) {                    //6
        _kcIndiaMartLabe.font=[UIFont systemFontOfSize:13.0f];
    }
    else if (screenWidth==414 && screenHeight == 736) {                    //6+
        _kcIndiaMartLabe.font=[UIFont systemFontOfSize:15.0f];
    }
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)termsNConditions:(id)sender {
    termsNCondtionsView *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"termsNCondtionsView"];
    [self.navigationController pushViewController:obj animated:YES];
    

}
- (IBAction)privacyPolicy:(id)sender {
    privacy_Policy *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"privacy_Policy"];
    [self.navigationController pushViewController:obj animated:YES];
    
}
- (IBAction)back:(id)sender {
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
