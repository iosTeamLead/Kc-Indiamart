//
//  PurchaseDetailsViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 19/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseDetailsViewController : UIViewController
{
    __weak IBOutlet UITableView *invoiceDetailTableView;
    __weak IBOutlet UIButton *totalBonusPoint;
    __weak IBOutlet UIButton *totalAmountPoint;
    __weak IBOutlet UILabel *lblInvoice;
    
}
@property (nonatomic,strong)NSMutableDictionary *detailData;
@end
