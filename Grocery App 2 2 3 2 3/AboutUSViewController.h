//
//  AboutUSViewController.h
//  Grocery App
//
//  Created by eweba1-pc-80 on 10/5/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUSViewController : UIViewController
{
    __weak IBOutlet UIButton *backButton;
    
}
@property (weak, nonatomic) IBOutlet UILabel *kcIndiaMartLabe;
@property(nonatomic)BOOL isFromLeft;

@end
