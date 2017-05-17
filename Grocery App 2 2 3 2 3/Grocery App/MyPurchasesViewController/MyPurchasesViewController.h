//
//  MyPurchasesViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPurchasesViewController : UIViewController
{
    __weak IBOutlet UITableView *myPurchaseTableView;
    __weak IBOutlet UILabel *noDataLabel;
    
}
@end
