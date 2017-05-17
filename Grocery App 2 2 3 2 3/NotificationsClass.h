//
//  NotificationsClass.h
//  Grocery App
//
//  Created by eweba1-pc-69 on 12/2/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsClass : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)actnBack:(id)sender;
@property(nonatomic) BOOL isFromLeft;

@property (strong, nonatomic) IBOutlet UITableView *notificationTabl;



@end
