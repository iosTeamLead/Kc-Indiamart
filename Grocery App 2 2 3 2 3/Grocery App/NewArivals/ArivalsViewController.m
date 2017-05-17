//
//  ArivalsViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "ArivalsViewController.h"
#import "ArivalCell.h"
#import "searchResultView.h"
#import "DetailListViewController.h"
#import "groceryProductData.h"
#import "ListViewController.h"
#import "Server.h"
#import "ZBarSDK.h"
#import "UIImageView+WebCache.h"

@interface ArivalsViewController ()<UITableViewDelegate,UITableViewDataSource,ZBarReaderDelegate>
{
    NSMutableArray *productArray;
    UIRefreshControl *refreshConctroller;
    bool isLoaderShow;
    NSManagedObject *device;
    NSMutableDictionary *userData;
    ZBarReaderViewController *codeReader;
    
    
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ArivalsViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    productArray = [[NSMutableArray alloc] init];
    userData = kGetValueForKey(USER_DATA);
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        if (_moviesData != nil)
        {
            [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Movies" attributes:@{NSForegroundColorAttributeName: color}]];        }
        else{
            [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Products" attributes:@{NSForegroundColorAttributeName: color}]];
        }
        
        
    }
    
    
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }
    isLoaderShow=YES;
    
    if (_moviesData == nil && _deptId != nil) {
        categoryName.text = [[_deptId valueForKey:@"subCatName"] capitalizedString];
        //        categoryName.text = @"Product List";
        
        
        [self getDataForDept];
        
    }
    else if (_moviesData != nil){
        categoryName.text = [[NSString stringWithFormat:@"%@ Movies",[[_moviesData objectAtIndex:0] valueForKey:@"Language"]] capitalizedString];
        productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[_moviesData mutableCopy]];
        [productTableView reloadData];
    }
    else if ([_buttonName isEqualToString:@"Organic"]){
        categoryName.text = @"Organic Products";
        
        [self getOrganicProduct];
        
    }
    
    
    else{
        categoryName.text = @"New Arrivals";
        [self getNewArrivalsProducs];
        
        [productTableView reloadData];
        
    }
    
    refreshConctroller =[[UIRefreshControl alloc]init];
    [refreshConctroller addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [productTableView addSubview:refreshConctroller];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"updateProducts" object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)refreshView{
    isLoaderShow  = false;
    if (_moviesData == nil && _deptId != nil) {
        categoryName.text = [[_deptId valueForKey:@"subCatName"] capitalizedString];
        [self getDataForDept];
        
    }
    else if (_moviesData != nil){
        categoryName.text = [[NSString stringWithFormat:@"%@ Movies",[[productArray objectAtIndex:0] valueForKey:@"Language"]] capitalizedString];
        productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[_moviesData mutableCopy]];
        [productTableView reloadData];
        [refreshConctroller endRefreshing];
        
    }
    else if ([_buttonName isEqualToString:@"Organic"]){
        [self getOrganicProduct];
        
    }
    
    else{
        categoryName.text = @"New Arrivals";
        [self getNewArrivalsProducs];
        [productTableView reloadData];
        
        
    }
    
    
    //      [productTableView setSeparatorInset:UIEdgeInsetsZero];
    
}
-(void)viewDidLayoutSubviews
{
    if ([productTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [productTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([productTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [productTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)getOrganicProduct
{
    //    http://webservices.com.kcimart.com/kcindia_app/webservices/Products/getOrganicProduct
    
    NSMutableArray *data=[[groceryProductData sharedManager] getOrganicProducts];
    productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[data  mutableCopy]];
    [productTableView reloadData];
    [refreshConctroller endRefreshing];
    
    if ( productArray.count <=0) {
        nodatafoundLabel.hidden =NO;
        productTableView.hidden = YES;
    }
    else{
        nodatafoundLabel.hidden =YES;
        productTableView.hidden = NO;
    }
    
    //    if(isLoaderShow)
    //    {
    //        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    //    }
    //    else{
    //        [[Server sharedManager] hideHUD];
    //    }
    //
    //
    //    //    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    //    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    //    //    [data setObject:[_deptId valueForKey:@"subCatId"] forKey:@"DepId"];
    //    [[Server sharedManager] PostDataWithURL:Base_URL@"Products/getOrganicProduct" WithParameter:data Success:^(NSMutableDictionary *Dic) {
    //        NSLog(@"%@ ",Dic);
    //        if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
    //            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
    //        }
    //        else{
    //
    //            NSLog(@"%lu ",[[Dic valueForKey:@"data"] count]);
    //            productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[[Dic valueForKey:@"data"] mutableCopy]];
    //
    //            //                  productArray = [Dic valueForKey:@"data"];
    //            [productTableView reloadData];
    //
    //        }
    //        [[Server sharedManager]hideHUD];
    //        [refreshConctroller endRefreshing];
    //
    //
    //    } Error:^(NSError *error) {
    //
    //        NSLog(@"%@",[error localizedDescription]);
    //    }];
    
    
}

-(void)getNewArrivalsProducs{
    
    //    http://webservices.com.kcimart.com/kcindia_app/webservices/Products/getNewArrival
    
    NSMutableArray *data=[[groceryProductData sharedManager] getNewArrials];
    productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[data  mutableCopy]];
    [productTableView reloadData];
    [refreshConctroller endRefreshing];
    if ( productArray.count <=0) {
        nodatafoundLabel.hidden =NO;
        productTableView.hidden = YES;
    }
    else{
        nodatafoundLabel.hidden =YES;
        productTableView.hidden = NO;
    }
    
    //    if(isLoaderShow)
    //    {
    //        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    //    }
    //    else{
    //        [[Server sharedManager] hideHUD];
    //    }
    //
    //
    //    //    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    //    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    ////    [data setObject:[_deptId valueForKey:@"subCatId"] forKey:@"DepId"];
    //    [[Server sharedManager] PostDataWithURL:Base_URL@"Products/getNewArrival" WithParameter:data Success:^(NSMutableDictionary *Dic) {
    //        NSLog(@"%@ ",Dic);
    //        if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
    //            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
    //        }
    //        else{
    //
    //
    //            productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[[Dic valueForKey:@"data"] mutableCopy]];
    //
    //            //                  productArray = [Dic valueForKey:@"data"];
    //            [productTableView reloadData];
    //
    //        }
    //        [[Server sharedManager]hideHUD];
    //        [refreshConctroller endRefreshing];
    //
    //
    //    } Error:^(NSError *error) {
    //
    //        NSLog(@"%@",[error localizedDescription]);
    //    }];
    //
    
}



-(void)getDataForDept{
    
    NSMutableArray *data=[[groceryProductData sharedManager] getProductBydeptId:[_deptId valueForKey:@"subCatId"]];
    productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[data  mutableCopy]];
    [productTableView reloadData];
    [refreshConctroller endRefreshing];
    
    if ( productArray.count <=0) {
        nodatafoundLabel.hidden =NO;
        productTableView.hidden = YES;
    }
    else{
        nodatafoundLabel.hidden =YES;
        productTableView.hidden = NO;
    }
    
    
    //    if(isLoaderShow)
    //    {
    //        [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    //    }
    //    else{
    //        [[Server sharedManager] hideHUD];
    //    }
    //
    //
    ////    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    //    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    //    [data setObject:[_deptId valueForKey:@"subCatId"] forKey:@"DepId"];
    //    [[Server sharedManager] PostDataWithURL:Base_URL@"getProduct" WithParameter:data Success:^(NSMutableDictionary *Dic) {
    //        NSLog(@"%@ ",Dic);
    //        if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
    //            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
    //        }
    //        else{
    //
    //
    //            productArray = [[groceryProductData sharedManager]checkForsavedOrNotWithProducts:[[Dic valueForKey:@"data"] mutableCopy]];
    //
    ////                  productArray = [Dic valueForKey:@"data"];
    //            [productTableView reloadData];
    //
    //        }
    //               [[Server sharedManager]hideHUD];
    //        [refreshConctroller endRefreshing];
    //
    //
    //    } Error:^(NSError *error) {
    //
    //        NSLog(@"%@",[error localizedDescription]);
    //    }];
    //
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_moviesData == nil && _deptId != nil ) {
        return productArray.count;
        
    }
    else if (_moviesData != nil){
        return productArray.count;
    }
    else if ([_buttonName isEqualToString:@"Organic"]){
        return productArray.count;
        
    }
    
    else{
        return productArray.count;
    }
    
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArivalCell *cell;
    cell.separatorInset = UIEdgeInsetsZero;
    if (_moviesData != nil)
    {
        cell = (ArivalCell *)[tableView dequeueReusableCellWithIdentifier:@"movieCell"];
        if (cell==nil) {
            cell = [[ArivalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"movieCell"];
            
        }
        
        
        
    }
    else{
        cell = (ArivalCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[ArivalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
    }
    
    
    if (_moviesData == nil && _deptId != nil) {
        
        [cell.imageIndicator startAnimating];
        cell.lblName.text=[[productArray objectAtIndex:indexPath.row] valueForKey:@"Item_Name"];
        
        if ([[userData valueForKey:@"Role"] isEqualToString:@"A"]) {
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d Cost: $%.2f Price: $%.2f",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Cost"] floatValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Price"] floatValue] ];
            
        }
        else if ([[userData valueForKey:@"Role"] isEqualToString:@"E"]) {
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d Price: $%.2f",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Price"] floatValue] ];
            
        }
        else{
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]];
        }
        //
        cell.locationLabel.text=[NSString stringWithFormat:@"Location: %@",[[productArray objectAtIndex:indexPath.row] valueForKey:@"Location"]];
        
        if ([[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]!=nil) {
            cell.addedButton.selected =YES;
            //            cell.lblAddToList.text = [NSString stringWithFormat:@"%@ Added",[[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]];
            cell.lblAddToList.text =   @"Added to List";
        }
        else{
            cell.addedButton.selected =NO;
            cell.lblAddToList.text = [NSString stringWithFormat:@"Add to list"];
        }
        cell.addedButton.tag = indexPath.row;
        [cell.addedButton addTarget:self action:@selector(addtoLocalData:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[productArray objectAtIndex:indexPath.row] valueForKey:@"Thumb_Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        //    NSString *newString = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.m_imageView.hidden=YES;
        
        
        
        
        cell.m_imageView.hidden=YES;
        [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.m_imageView.image  =  image;
            cell.m_imageView.hidden=NO;
            [cell.imageIndicator stopAnimating];
        }];
        
        
        
        
        
        
        //        [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            cell.m_imageView.image  =  image;
        //            cell.m_imageView.hidden=NO;
        //            [cell.imageIndicator stopAnimating];
        //        }];
        //
        
        //        cell.m_imageView.hidden=YES;
        
        //        cell.m_imageView.cli
        //        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //        [cell.m_imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        //            cell.m_imageView.image  =  image;
        //            cell.m_imageView.hidden=NO;
        //
        //            [cell.imageIndicator stopAnimating];
        //
        //        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //            //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
        ////            [cell.imageIndicator stopAnimating];
        ////            cell.m_imageView.hidden=NO;
        //
        //        }];
        //    [UIImage imageNamed:@"imgRewards"];
        return  cell;
        
        
    }
    else if (_moviesData != nil){
        
        [cell.imageIndicator startAnimating];
        cell.lblName.text=[[productArray objectAtIndex:indexPath.row] valueForKey:@"Movie_Name"];
        //        cell.lblDetails.text=@""
        //        cell.lblDetails.text=[NSString stringWithFormat:@"In Stock %d",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue] ];
        
        if ([[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]<=0) {
            cell.lblDetails.textColor = [UIColor colorWithRed:200/255.0f green:0/255.0f blue:0/255.0f alpha:1];
            
            cell.lblDetails.text = @"Checked Out";
        }
        else{
            cell.lblDetails.textColor = [UIColor colorWithRed:0/255.0f green:157/255.0f blue:0/255.0f alpha:1];
            
            cell.lblDetails.text = @"Available";
        }
        
        
        
        if ([[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]!=nil) {
            cell.addedButton.selected =YES;
            //            cell.lblAddToList.text = [NSString stringWithFormat:@"%@ Added",[[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]];
            cell.lblAddToList.text =   @"Added to List";
        }
        else{
            cell.addedButton.selected =NO;
            cell.lblAddToList.text = [NSString stringWithFormat:@"Add to list"];
        }
        cell.addedButton.tag = indexPath.row;
        [cell.addedButton addTarget:self action:@selector(addtoLocalData:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[productArray objectAtIndex:indexPath.row] valueForKey:@"Thumb_Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        //    NSString *newString = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        cell.m_imageView.hidden=YES;
        cell.locationLabel.hidden = YES;
        //        [cell.m_imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        //            cell.m_imageView.image = image;
        //            cell.m_imageView.hidden=NO;
        //
        //            [cell.imageIndicator stopAnimating];
        //
        //        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //            //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
        //            [cell.imageIndicator stopAnimating];
        //
        //        }];
        
        cell.m_imageView.hidden=YES;
        [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.m_imageView.image  =  image;
            cell.m_imageView.hidden=NO;
            [cell.imageIndicator stopAnimating];
        }];
        
        
        
        
        
        //    [UIImage imageNamed:@"imgRewards"];
        return  cell;
        
        
    }
    else if ([_buttonName isEqualToString:@"Organic"]){
        
        [cell.imageIndicator startAnimating];
        cell.lblName.text=[[productArray objectAtIndex:indexPath.row] valueForKey:@"Item_Name"];
        if ([[userData valueForKey:@"Role"] isEqualToString:@"A"]) {
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d Cost: $%.2f Price: $%.2f",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Cost"] floatValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Price"] floatValue] ];
            
        }
        else if ([[userData valueForKey:@"Role"] isEqualToString:@"E"]) {
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d Price: $%.2f",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Price"] floatValue] ];
            
        }
        else{
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]];
        }
        //
        cell.locationLabel.text=[NSString stringWithFormat:@"Location: %@",[[productArray objectAtIndex:indexPath.row] valueForKey:@"Location"]];
        
        if ([[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]!=nil) {
            cell.addedButton.selected =YES;
            //            cell.lblAddToList.text = [NSString stringWithFormat:@"%@ Added",[[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]];
            cell.lblAddToList.text =   @"Added to List";
        }
        else{
            cell.addedButton.selected =NO;
            cell.lblAddToList.text = [NSString stringWithFormat:@"Add to list"];
        }
        cell.addedButton.tag = indexPath.row;
        [cell.addedButton addTarget:self action:@selector(addtoLocalData:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[productArray objectAtIndex:indexPath.row] valueForKey:@"Thumb_Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        
        
        
        
        cell.m_imageView.hidden=YES;
        [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.m_imageView.image  =  image;
            cell.m_imageView.hidden=NO;
            [cell.imageIndicator stopAnimating];
        }];
        
        
        
        
        
        
        
        //    NSString *newString = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        cell.m_imageView.hidden=YES;
        //        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //        [cell.m_imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        //            cell.m_imageView.hidden=NO;
        //
        //            cell.m_imageView.image  =  image;
        //            [cell.imageIndicator stopAnimating];
        //
        //        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //            //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
        //            [cell.imageIndicator stopAnimating];
        //
        //        }];
        //    [UIImage imageNamed:@"imgRewards"];
        return  cell;
        
    }
    else
    {
        
        [cell.imageIndicator startAnimating];
        cell.lblName.text=[[productArray objectAtIndex:indexPath.row] valueForKey:@"Item_Name"];
        if ([[userData valueForKey:@"Role"] isEqualToString:@"A"]) {
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d Cost: $%.2f Price: $%.2f",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Cost"] floatValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Price"] floatValue] ];
            
        }
        else if ([[userData valueForKey:@"Role"] isEqualToString:@"E"]) {
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d Price: $%.2f",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue],[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Price"] floatValue] ];
            
        }
        else{
            cell.lblDetails.text=[NSString stringWithFormat:@"Available in Stock %d",[[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]];
        }
        cell.locationLabel.text=[NSString stringWithFormat:@"Location: %@",[[productArray objectAtIndex:indexPath.row] valueForKey:@"Location"]];
        if ([[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]!=nil) {
            cell.addedButton.selected =YES;
            //            cell.lblAddToList.text = [NSString stringWithFormat:@"%@ Added",[[productArray objectAtIndex:indexPath.row] valueForKey:@"myQuantity"]];
            cell.lblAddToList.text =   @"Added to List";
        }
        else{
            cell.addedButton.selected =NO;
            cell.lblAddToList.text = [NSString stringWithFormat:@"Add to list"];
        }
        cell.addedButton.tag = indexPath.row;
        [cell.addedButton addTarget:self action:@selector(addtoLocalData:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[productArray objectAtIndex:indexPath.row] valueForKey:@"Thumb_Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        //    NSString *newString = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        
        cell.m_imageView.hidden=YES;
        [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.m_imageView.image  =  image;
            cell.m_imageView.hidden=NO;
            [cell.imageIndicator stopAnimating];
        }];
        
        
        
        
        
        //        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        //
        //        cell.m_imageView.hidden=YES;
        //
        //        [cell.m_imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        //            cell.m_imageView.image  =  image;
        //            [cell.imageIndicator stopAnimating];
        //            cell.m_imageView.hidden=NO;
        //
        //        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        //            //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
        //            [cell.imageIndicator stopAnimating];
        //
        //        }];
        //    [UIImage imageNamed:@"imgRewards"];
        return  cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    DetailListViewController *detailVc = [[DetailListViewController alloc] initWithNibName:@"DetailListViewController" bundle:nil];
    
    NSMutableDictionary  *tempDict= (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(NULL, CFBridgingRetain([productArray objectAtIndex:indexPath.row]), kCFPropertyListMutableContainersAndLeaves));
    
    
    
    
    DetailListViewController *detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailListViewController"];
    
    if (_moviesData == nil && _deptId != nil) {
        //        if ([[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]== 0 ) {
        //            [UtilityText showAlertWithAlert:self Alert:@"ALERT" message:@"Their is no stock for this product" cancelTitle:@"Ok"];
        //        }
        //        else{
        detailVc.productDetail = tempDict;
        [self.navigationController pushViewController:detailVc animated:YES];
        
        //        }
        
        
        
    }
    else if (_moviesData != nil){
        
        //
        //        if ([[[_moviesData objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]== 0 ) {
        //            [UtilityText showAlertWithAlert:self Alert:@"ALERT" message:@"Their is no stock for this product" cancelTitle:@"Ok"];
        //        }
        //        else{
        detailVc.productDetail = tempDict;
        [self.navigationController pushViewController:detailVc animated:YES];
        
        
        //        }
        
    }
    else if ([_buttonName isEqualToString:@"Organic"]){
        //        if ([[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]== 0 ) {
        //            [UtilityText showAlertWithAlert:self Alert:@"ALERT" message:@"Their is no stock for this product" cancelTitle:@"Ok"];
        //        }
        //        else{
        detailVc.productDetail = tempDict;
        [self.navigationController pushViewController:detailVc animated:YES];
        
        //        }
    }
    
    else {
        
        //        if ([[[productArray objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]== 0 ) {
        //            [UtilityText showAlertWithAlert:self Alert:@"ALERT" message:@"Their is no stock for this product" cancelTitle:@"Ok"];
        //        }
        //        else{
        detailVc.productDetail = tempDict;
        [self.navigationController pushViewController:detailVc animated:YES];
        
        //        }
        
        
        
        
    }
    
    
    
    
}

-(void)addtoLocalData:(UIButton*)sender{
    
    
    
    if (kGetValueForKey(listName) == nil) {
        
        
        
        
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:@"Alert" message:@"You don't have any list created. Please create a list first."preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes, please"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //What we write here????????**
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                        ListViewController *move=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                                        move.isFromLeft=YES;
                                        [self.navigationController pushViewController:move animated:YES]; //  present it
                                        
                                        
                                        NSLog(@"you pressed Yes, please button");
                                        // call method whatever u need
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No, thanks"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //What we write here????????**
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                       NSLog(@"you pressed No, thanks button");
                                       // call method whatever u need
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
        
        
        
    }
    else{
        
        NSManagedObjectContext *context = [self managedObjectContext];
        if (device) {
            // Update existing device
            //        _productDetail
            //        [self.device setValue:[[groceryProductData sharedManager] getListName] forKey:@"listName"];
            
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:[[productArray objectAtIndex:sender.tag] mutableCopy]];
            [device setValue:arrayData forKey:@"productDetails"];
            [device setValue:@"1" forKey:@"quantity"];
            
            
            
            
            
        } else {
            if([[productArray objectAtIndex:sender.tag] valueForKey:@"myQuantity"]!=nil  )
            {
                
                
                
                UIAlertController * alert=[UIAlertController
                                           
                                           alertControllerWithTitle:@"Alert" message:@"Are you sure to delete this product"preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"Yes, please"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //What we write here????????**
                                                
                                                [[groceryProductData sharedManager]deleteClubsEntity:[[productArray objectAtIndex:sender.tag] valueForKey:@"productId"]];
                                                NSLog(@"you pressed Yes, please button");
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                                
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
                                                [productTableView reloadData];
                                                
                                                // call method whatever u need
                                            }];
                UIAlertAction* noButton = [UIAlertAction
                                           actionWithTitle:@"No, thanks"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               //What we write here????????**
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                               NSLog(@"you pressed No, thanks button");
                                               // call method whatever u need
                                               
                                           }];
                
                [alert addAction:yesButton];
                [alert addAction:noButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
                
                
                
            }
            else{
                [[groceryProductData sharedManager] saveMyProduct:[[productArray objectAtIndex:sender.tag] mutableCopy] quantity:@"1" mylistName:kGetValueForKey(listName) notes:kGetValueForKey(notesText)];
            }
        }
        
        
        
        //    kSetBoolValueForKey(IsListCreated, YES);
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else{
            [[groceryProductData sharedManager] fetchSavedListAndProductId];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
        //        [self.navigationController popViewControllerAnimated:YES];
        [productTableView reloadData];
        
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}
- (IBAction)sideBarTapped:(id)sender {
    if (!_isFromLeft) {
        MMDrawer *drawer = (MMDrawer *)[[self parentViewController] parentViewController];
        [drawer toggleDrawerSide: MMDrawerSideLeft animated:YES completion:^(BOOL finished) { }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    if (_moviesData != nil)
    {
        resultScreen.isMovie=YES;
    }
    else{
        resultScreen.isMovie = NO;
    }
    
    resultScreen.moviesArray = [productArray mutableCopy];
    resultScreen.searchText = searchBar.text;
    [self.navigationController pushViewController:resultScreen animated:YES];
    return  NO;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    resultScreen.isMovie= YES;
    resultScreen.moviesArray = [productArray mutableCopy];
    [self.navigationController pushViewController:resultScreen animated:YES];
    
    
}

- (IBAction)barCodePressed:(id)sender {
    NSLog(@"Scanning..");
    NSString *str = @"Scanning..";
    
    codeReader = [ZBarReaderViewController new];
    codeReader.readerDelegate=self;
    codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = codeReader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    
    self.view.hidden=YES;
    [self presentViewController:codeReader animated:YES completion:^{
        [self.view setHidden:NO];
    }];
    
}
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //  get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    
    
    
    // showing the result on textview
    NSString *str = symbol.data;
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    NSMutableDictionary *dict = [[groceryProductData sharedManager] fetchPerticularProduct:str];
    if (dict !=nil) {
        
        
        //              [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        BOOL isOn=  [[NSUserDefaults standardUserDefaults]boolForKey:@"isSwitchOn"];
        
        
        
        
        if (isOn) {
            [self addtoLocalData1:dict];
        }
        else{
            DetailListViewController *detail= [self.storyboard instantiateViewControllerWithIdentifier:@"DetailListViewController"];
            detail.productDetail = [dict  mutableCopy];
            detail.isFromScanner = YES;
            [reader presentViewController:detail animated:YES completion:nil];

        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
    
    
    // dismiss the controller
}


-(void)addtoLocalData1:(NSMutableDictionary *) dataArray{
    
    
    
    if (kGetValueForKey(listName) == nil) {
        
        
        
        
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:@"Alert" message:@"You don't have any list created. Please create a list first."preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes, please"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //What we write here????????**
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        [codeReader dismissViewControllerAnimated:YES completion:nil];
                                        ListViewController *move=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                                        move.isFromLeft=YES;
                                        [self.navigationController pushViewController:move animated:YES]; //  present it
                                        
                                        
                                        NSLog(@"you pressed Yes, please button");
                                        // call method whatever u need
                                    }];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No, thanks"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //What we write here????????**
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                       NSLog(@"you pressed No, thanks button");
                                       // call method whatever u need
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [codeReader presentViewController:alert animated:YES completion:nil];
        
        
        
        
        
        
        
    }
    else{
        
        NSManagedObjectContext *context = [self managedObjectContext];
        if (device) {
            // Update existing device
            //        _productDetail
            //        [self.device setValue:[[groceryProductData sharedManager] getListName] forKey:@"listName"];
            
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:[dataArray mutableCopy]];
            [device setValue:arrayData forKey:@"productDetails"];
            [device setValue:@"1" forKey:@"quantity"];
            
            
            
            
            
        } else {
            if([dataArray valueForKey:@"myQuantity"]!=nil  )
            {
                
                
                int quant= [[dataArray valueForKey:@"myQuantity"] intValue];
                NSString *newQuat=[NSString stringWithFormat:@"%d",++quant];
                
                
                [[groceryProductData sharedManager] updateQuantity:[dataArray valueForKey:@"ItemNum"] withQuantity:newQuat];
                
                
                [UtilityText showAlertWithAlert:codeReader Alert:@"Message" message:@"Product updated" cancelTitle:@"ok"];
                
                
            }
            else{
                [[groceryProductData sharedManager] saveMyProduct:[dataArray mutableCopy] quantity:@"1" mylistName:kGetValueForKey(listName) notes:kGetValueForKey(notesText)];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Product Added Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
        
        
        
        //    kSetBoolValueForKey(IsListCreated, YES);
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else{
            [[groceryProductData sharedManager] fetchSavedListAndProductId];
            
            //
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
        //        [self.navigationController popViewControllerAnimated:YES];
        //        [productTableView reloadData];
        
    }
}


@end
