//
//  MyRewardsViewController.m
//  Grocery App
//
//  Created by eweba1-pc-69 on 11/30/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "MyRewardsViewController.h"
#import "RewardsCustomCell.h"


@interface MyRewardsViewController ()

@end

@implementation MyRewardsViewController

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
    return _rewardsTransaction.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @"RewardsCustomCell";
    
    RewardsCustomCell *cell = (RewardsCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    cell.lblInvoiceNo.text = [NSString stringWithFormat:@"Invoice no. %@",
                              [[_rewardsTransaction objectAtIndex:indexPath.row] valueForKey:@"InvoiceNum"]];
    cell.lblTymDate.text = [NSString stringWithFormat:@"%@", [[_rewardsTransaction objectAtIndex:indexPath.row] valueForKey:@"Trans_Date"]];
    
    cell.lblPurchase.text = [NSString stringWithFormat:@"Type: %@", [[_rewardsTransaction objectAtIndex:indexPath.row] valueForKey:@"Trans_Type"]];
    
    cell.lblPrice.text = [NSString stringWithFormat:@"%@", [[_rewardsTransaction objectAtIndex:indexPath.row] valueForKey:@"Bonus_Points"]];
    
    

    return cell;
}

- (IBAction)actnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
