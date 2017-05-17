//
//  ArivalsViewController.h
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArivalsViewController : UIViewController
{
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UITableView *productTableView;
    __weak IBOutlet UILabel *categoryName;
    __weak IBOutlet UILabel *nodatafoundLabel;
    
}
@property(nonatomic ,assign)BOOL isFromLeft;
@property(nonatomic ,strong) NSString *buttonName;
@property(nonatomic ,strong) NSMutableDictionary *deptId;
@property(nonatomic ,strong) NSMutableArray *moviesData;

@end
