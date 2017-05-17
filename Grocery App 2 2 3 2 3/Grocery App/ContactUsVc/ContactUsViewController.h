//
//  ContactUsViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textEmail;
@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)btnSubmit:(id)sender;

@end
