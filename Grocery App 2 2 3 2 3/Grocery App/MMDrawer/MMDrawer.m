//
//  MMDrawer.m
//  Grocery App
//
//  Created by eweba1-pc-55 on 9/13/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "MMDrawer.h"


@interface MMDrawer()

@end
@implementation MMDrawer

-(void)viewDidLoad{
    [super viewDidLoad];
    self.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavController"];
    
    self.leftDrawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SideBarViewController"];
    self.maximumLeftDrawerWidth = self.view.frame.size.width* 0.75;
    self.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
}

@end

