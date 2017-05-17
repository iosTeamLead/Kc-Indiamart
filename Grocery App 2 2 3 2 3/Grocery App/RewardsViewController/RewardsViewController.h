//
//  RewardsViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 20/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardsViewController : UIViewController
{
    __weak IBOutlet UITextField *memberNumberTextField;
    __weak IBOutlet UITextField *memberLastName;
    
}
- (IBAction)submitAction:(id)sender;
@end
