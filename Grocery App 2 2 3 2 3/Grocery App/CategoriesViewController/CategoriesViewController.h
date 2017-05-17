//
//  CategoriesViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CategoriesViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UIButton *backButton;
    
}
@property(nonatomic)BOOL isFromLeft;
@end
