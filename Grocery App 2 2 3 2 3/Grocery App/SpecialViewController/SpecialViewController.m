//
//  SpecialViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 20/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "SpecialViewController.h"
#import "SpecialTableViewCell.h"
#import "groceryProductData.h"
#import "Server.h"

@interface SpecialViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *specialArray;
}
@end

@implementation SpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getspecialw];
}


-(void) getspecialw{
//    http://webservices.com.kcimart.com/kcindia_app/webservices/Products/getSpecial
//     specialArray = [[NSMutableArray alloc] init];
//    NSMutableArray *data=[[groceryProductData sharedManager] getSpecial];
//    specialArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[data  mutableCopy]];
//    [specailTableView reloadData];
    

    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    //        [data setObject:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"] forKey:@"CustNum"];
    [[Server sharedManager] PostDataWithURL:Base_URL@"Products/getSpecial" WithParameter:data Success:^(NSMutableDictionary *Dic) {
        NSLog(@"%@ ",Dic);
        if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"No Specials Available Currently" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            specialArray = [[NSMutableArray alloc] init];
            specialArray = [[Dic valueForKey:@"data"]  mutableCopy];
            [specailTableView reloadData];
            if(specialArray.count <=0)
            {
                nodataLabel.hidden = NO;
                specailTableView.hidden = YES;
            }
            else{
                nodataLabel.hidden = YES;
                specailTableView.hidden = NO;

            }
        }
        [[Server sharedManager]hideHUD];
        
        
    } Error:^(NSError *error) {
        
        NSLog(@"%@",[error localizedDescription]);
    }];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return specialArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 SpecialTableViewCell *cell = (SpecialTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
 
 if (cell==nil) {
  cell = [[SpecialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  
 }
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
// cell.m_imageView.image = [UIImage imageNamed:@"imgHomePurchases"];
       //  cell.btnQuantity.layer.borderWidth = 1.0;
    //  cell.btnQuantity.layer.borderColor = [[UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1.0] CGColor];
    
    [cell.imageIndicator startAnimating];
    cell.lblName.text=[[specialArray objectAtIndex:indexPath.row] valueForKey:@"Special_Description1"];
    cell.lblDescription.text=[[specialArray objectAtIndex:indexPath.row] valueForKey:@"Special_Description2"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[specialArray objectAtIndex:indexPath.row] valueForKey:@"Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
        cell.m_imageView.hidden=YES;
    
    
    [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.m_imageView.image  =  image;
        cell.m_imageView.hidden=NO;
        [cell.imageIndicator stopAnimating];
    }];
    
    
    
    
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//    [cell.m_imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        cell.m_imageView.image  =  image;
//        cell.m_imageView.hidden=NO;
//        
//        [cell.imageIndicator stopAnimating];
//        
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
//        [cell.imageIndicator stopAnimating];
//        //            cell.m_imageView.hidden=NO;
//        
//    }];
    //    [UIImage imageNamed:@"imgRewards"];
    //  cell.btnQuantity.layer.borderWidth = 1.0;
 //  cell.btnQuantity.layer.borderColor = [[UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1.0] CGColor];
 return  cell;
}
- (IBAction)btnSidePressed:(id)sender {
 [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
