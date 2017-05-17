//
//  MyAccountViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController
{
    
    
    IBOutlet UITextField *LastName;
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *mobileTextField;
    __weak IBOutlet UITextField *bdayTextField;
    __weak IBOutlet UITextField *addressTextField;
    __weak IBOutlet UITextField *zipTextFields;
    __weak IBOutlet UITextField *cityTextField;
    __weak IBOutlet UITextField *stateTextField;
    __weak IBOutlet UIButton *submitButton;
    __weak IBOutlet UIPickerView *pickerView;
    __weak IBOutlet UIButton *selectState;
    __weak IBOutlet UIButton *selectCity;
    __weak IBOutlet UIButton *backButton;
    IBOutlet UIButton *changePaswordButton;
   
    __weak IBOutlet UIView *stateCityPickerView;
    __weak IBOutlet UIView *dobView;
    __weak IBOutlet UIDatePicker *datePIckerView;
 }
- (IBAction)changePasswordAction:(id)sender;
- (IBAction)submitAction:(id)sender;
@property(nonatomic) BOOL isFromLeft;
@property(strong,nonatomic) NSMutableDictionary *userdataFromprev;
@end
