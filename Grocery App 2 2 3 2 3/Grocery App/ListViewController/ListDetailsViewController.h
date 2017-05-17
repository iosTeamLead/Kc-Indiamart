//
//  ListDetailsViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ListDetailsViewController : UIViewController<MFMailComposeViewControllerDelegate>

{
    __weak IBOutlet UILabel *listNameString;
    __weak IBOutlet UIButton *drawerBtn;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UILabel *nodatafoundlabel;
    __weak IBOutlet UIView *sampleView;
    IBOutlet UITapGestureRecognizer *pickerAndSaveTap;

}
@property(nonatomic) BOOL isFromLeft;
@end
