//
//  ChangePasswordViewController.h
//  Grocery App
//
//  Created by eweba1-pc-69 on 12/3/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (weak, nonatomic) IBOutlet UIButton *outletSave;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnSave:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *testOldPwd;

@property (weak, nonatomic) IBOutlet UITextField *textNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *textConfirmPwd;
@end
