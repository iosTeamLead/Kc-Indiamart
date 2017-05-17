//
//  GiftTransactnViewController.m
//  Grocery App
//
//  Created by eweba1-pc-69 on 11/29/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "GiftTransactnViewController.h"
#import "GiftCardCustomCell.h"

@interface GiftTransactnViewController ()

@end

@implementation GiftTransactnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_giftTransactions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @"GiftCardCustomCell";
    
    GiftCardCustomCell *cell = (GiftCardCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    cell.lblTrnsactn.text =[NSString stringWithFormat:@"Transaction no. %@",
[[_giftTransactions objectAtIndex:indexPath.row] valueForKey:@"TransId"] ];
    
    cell.lblDateTym.text =[NSString stringWithFormat:@"%@",
                            [[_giftTransactions objectAtIndex:indexPath.row] valueForKey:@"Trans_Time"] ];

    cell.lblPurchase.text =[NSString stringWithFormat:@"Type: %@",
                           [[_giftTransactions objectAtIndex:indexPath.row] valueForKey:@"Trans_Type"] ];
    
    
    if ([[[_giftTransactions objectAtIndex:indexPath.row] valueForKey:@"Trans_Type"] isEqualToString:@"Purchase"]) {
        cell.lblCost.text =[NSString stringWithFormat:@"-$%@",
                            [[_giftTransactions objectAtIndex:indexPath.row] valueForKey:@"Trans_Amount"] ];
    }
    else{
        cell.lblCost.text =[NSString stringWithFormat:@"$%@",
                            [[_giftTransactions objectAtIndex:indexPath.row] valueForKey:@"Trans_Amount"] ];
        cell.lblCost.textColor = [UIColor colorWithRed:0.00 green:0.50 blue:0.00 alpha:1.0];
       
        
        
    }
    
    

//    cell.lorem.text=items [indexPath.row];
//    cell.lblLorem1.text= text [indexPath.row];
//    cell.lbltTime.text= time [indexPath.row];
    
    
    return cell;
}


- (IBAction)actnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
