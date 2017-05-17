//
//  CoupansViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 20/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "CoupansViewController.h"
#import "CoupansCell.h"
#import "Server.h"
#import "groceryProductData.h"
#import "LoginViewController.h"
#import "AllCouponsViewController.h"
@interface CoupansViewController ()
{
    NSMutableArray *coupanArray,*myCoupanArray,*showableArray;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBar;

@end

@implementation CoupansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 _segmentBar.layer.cornerRadius = 5.0f;
//    coupanArray = [[NSMutableArray alloc] init];
    [self getCoupans];
    NSLog(@"%@",kGetValueForKey(USER_DATA));
    
    // Do any additional setup after loading the view.
}

-(void)getCoupans{
    
//    http://webservices.com.kcimart.com/kcindia_app/webservices/UserRegistration/getCoupons
    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    if (kGetValueForKey(USER_DATA)) {
        [data setObject:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"] forKey:@"CustNum"];

    }
    
    
    [[Server sharedManager] PostDataWithURL:Base_URL@"UserRegistration/getCoupons" WithParameter:data Success:^(NSMutableDictionary *Dic) {
        NSLog(@"%@ ",Dic);
        if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Alert" message:@"No Coupons Available Currently" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];

            
//            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
        }
        else{
            coupanArray = [[NSMutableArray alloc] init];
            myCoupanArray = [[NSMutableArray alloc] init];


            for (int i=0; i<[[Dic valueForKey:@"data"] count]; i++) {
                if ([[[[Dic valueForKey:@"data"] objectAtIndex:i] valueForKey:@"CustNum"] isEqualToString:[kGetValueForKey(USER_DATA) valueForKey:@"CustNum"]]) {
                    [myCoupanArray addObject:[[Dic valueForKey:@"data"] objectAtIndex:i]];
                    [coupanArray addObject:[[Dic valueForKey:@"data"] objectAtIndex:i]];

                }
                else{
                    [coupanArray addObject:[[Dic valueForKey:@"data"] objectAtIndex:i]];

                }
            }
//            coupanArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[[Dic valueForKey:@"data"] mutableCopy]];
            
            //                  productArray = [Dic valueForKey:@"data"];
           
            
            showableArray = [coupanArray mutableCopy];
            [coupanTableView reloadData];
            
            if (showableArray.count<=0) {
                noDataLAbel.hidden=NO;
                coupanTableView.hidden = YES;
            }else{
                noDataLAbel.hidden=YES;
                coupanTableView.hidden = NO;
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

    
    
    
    return [showableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 CoupansCell *cell = (CoupansCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
 
 if (cell==nil) {
  cell = [[CoupansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  
 }
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    cell.lblName.text = [[showableArray objectAtIndex:indexPath.row] valueForKey:@"Description1"];
    
    cell.lblDescription.text = [[showableArray objectAtIndex:indexPath.row] valueForKey:@"Description2"];

    cell.lblExpairDate.text = [[showableArray objectAtIndex:indexPath.row] valueForKey:@"Exp_Date"];
    
    
    
    
    cell.m_imageView.hidden=YES;
    [cell.imageIndicator startAnimating];
    NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[showableArray objectAtIndex:indexPath.row] valueForKey:@"Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
   
    
//    
//    NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[self.selectedData valueForKey:@"Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    
    
    [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.m_imageView.image  =  image;
        cell.m_imageView.hidden=NO;
        [cell.imageIndicator stopAnimating];
    }];
    
    
    
    

    
    
    
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
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        AllCouponsViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AllCouponsViewController"];
        obj.selectedData = [[showableArray objectAtIndex:indexPath.row] mutableCopy];
        [self.navigationController pushViewController:obj animated:YES];
       
        
        
       
        
        
       
  
}
- (IBAction)segmentChange:(id)sender {
   
    NSLog(@"%ld",(long)_segmentBar.selectedSegmentIndex);
    if(_segmentBar.selectedSegmentIndex==0)
    {
        showableArray = [coupanArray mutableCopy];
    }
    else{
            if (kGetValueForKey(Is_Login)==nil) {
        
        
                LoginViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                view.isFromLeft = YES;
                [self.navigationController pushViewController:view animated:YES];
            }
            else{
               
        
        showableArray = [myCoupanArray mutableCopy];
            }
    }
    
   
    
    
    
    
    
    if (showableArray.count<=0) {
        noDataLAbel.hidden=NO;
        coupanTableView.hidden = YES;
    }else{
        
        
        
        noDataLAbel.hidden=YES;
        coupanTableView.hidden = NO;
    }

    
    
    
    [coupanTableView reloadData];
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
