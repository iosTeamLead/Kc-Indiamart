//
//  ListViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController
{
    __weak IBOutlet UIButton *drawerBtn;
    __weak IBOutlet UIButton *backButton;
    
}
@property(nonatomic) BOOL isFromLeft;
@property (strong) NSManagedObject *device;
@end
