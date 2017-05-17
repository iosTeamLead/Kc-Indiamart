//
//  DetailListViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 20/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "DetailListViewController.h"
#import "UtilityText.h"
#import "collectionCell.h"
#import "ListDetailsViewController.h"
#import "ListViewController.h"
#import "groceryProductData.h"
#import "Server.h"
#import "AppDelegate.h"
@interface DetailListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>{
    UIPickerView *picker;
    NSMutableArray *pickerData;
    UIVisualEffectView *blurEffectView;
    
}
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *quantityBtn;

@end

@implementation DetailListViewController


@synthesize device;
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
    
    
    
    pickerData = [[NSMutableArray alloc] init];
    
    if ([_productDetail valueForKey:@"Item_Name"]==nil) {
        productName.text=[_productDetail valueForKey:@"Movie_Name"];
        
        
        if ([[_productDetail valueForKey:@"Quantity"] intValue]<=0) {
            stockNumberLabel.textColor = [UIColor colorWithRed:200/255.0f green:0/255.0f blue:0/255.0f alpha:1];
            stockNumberLabel.text = @"Checked Out";
        }
        else{
            locationLabel.hidden= NO;
            
            stockNumberLabel.textColor = [UIColor colorWithRed:0/255.0f green:157/255.0f blue:0/255.0f alpha:1];
            stockNumberLabel.text = @"Available";
        }
        
        
        
        
        //adjust the label the the new height.
        discriptionView.frame=CGRectMake(discriptionView.frame.origin.x, discriptionView.frame.origin.y, discriptionView.frame.size.width,0);
        
        
        priceOnlyView.frame=CGRectMake(priceOnlyView.frame.origin.x, priceOnlyView.frame.origin.y, priceOnlyView.frame.size.width,0);
        costOblyView.frame=CGRectMake(costOblyView.frame.origin.x, priceOnlyView.frame.origin.y+ priceOnlyView.frame.size.height, costOblyView.frame.size.width,0);
        compositionViewOnly.frame=CGRectMake(compositionViewOnly.frame.origin.x, costOblyView.frame.origin.y+ costOblyView.frame.size.height, compositionViewOnly.frame.size.width, 0);
        
        
        
        locationCompositionView.frame=CGRectMake(locationCompositionView.frame.origin.x, compositionViewOnly.frame.origin.y+ compositionViewOnly.frame.size.height, locationCompositionView.frame.size.width, 0);
        
        quantAndaddToView.frame=CGRectMake(quantAndaddToView.frame.origin.x, locationCompositionView.frame.origin.y+ locationCompositionView.frame.size.height, quantAndaddToView.frame.size.width, quantAndaddToView.frame.size.height);
        
        _quantityBtn.frame=CGRectMake(_quantityBtn.frame.origin.x,_collectionView.frame.origin.y+_collectionView.frame.size.height+quantAndaddToView.frame.origin.y+8, _quantityBtn.frame.size.width, _quantityBtn.frame.size.height);
        
        
        //        descriptionLabel.backgroundColor = [UIColor redColor];
        
        
        if([_productDetail valueForKey:@"myQuantity"]!=nil  )
        {
            
            
            addtoListButton.frame=CGRectMake(addtoListButton.frame.origin.x, _collectionView.frame.size.height+ quantAndaddToView.frame.origin.y+ quantAndaddToView.frame.size.height+8, addtoListButton.frame.size.width, addtoListButton.frame.size.height);
            removeButton.frame=CGRectMake(removeButton.frame.origin.x, addtoListButton.frame.origin.y+ addtoListButton.frame.size.height+8, removeButton.frame.size.width, removeButton.frame.size.height);
            discriptionView.frame=CGRectMake(discriptionView.frame.origin.x, removeButton.frame.origin.y+removeButton.frame.size.height+8, discriptionView.frame.size.width,0);
            
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,scrollView.frame.size.height+discriptionView.frame.size.height+removeButton.frame.size.height);
            discriptionView.hidden = YES;
            
        }
        else{
            
            addtoListButton.frame=CGRectMake(addtoListButton.frame.origin.x, _collectionView.frame.size.height+ quantAndaddToView.frame.origin.y+ quantAndaddToView.frame.size.height+8, addtoListButton.frame.size.width, addtoListButton.frame.size.height);
            removeButton.frame=CGRectMake(removeButton.frame.origin.x, addtoListButton.frame.origin.y+ addtoListButton.frame.size.height+8, removeButton.frame.size.width, 0);
            discriptionView.hidden = YES;
            
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,scrollView.frame.size.height+discriptionView.frame.size.height);
            
            
            
        }
        
        
        
        
        scrollView.scrollEnabled=YES;
        //
        //        if([_productDetail valueForKey:@"myQuantity"]!=nil  )
        //        {
        //            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,costOblyView.frame.size.height+priceOnlyView.frame.size.height+10+addtoListButton.frame.size.height+removeButton.frame.size.height);
        //
        //
        //            addtoListButton.frame=CGRectMake(addtoListButton.frame.origin.x,simpleView.frame.origin.y+ simpleView.frame.size.height-2*addtoListButton.frame.size.height-10, addtoListButton.frame.size.width, addtoListButton.frame.size.height);
        //
        //            removeButton.frame=CGRectMake(removeButton.frame.origin.x, addtoListButton.frame.origin.y+ addtoListButton.frame.size.height+8, removeButton.frame.size.width, removeButton.frame.size.height);
        //
        //        }
        //        else{
        //            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,costOblyView.frame.size.height+priceOnlyView.frame.size.height+10+addtoListButton.frame.size.height);
        //
        //
        //            addtoListButton.frame=CGRectMake(addtoListButton.frame.origin.x,simpleView.frame.origin.y+ simpleView.frame.size.height-1*addtoListButton.frame.size.height-10, addtoListButton.frame.size.width, addtoListButton.frame.size.height);
        //
        //            removeButton.frame=CGRectMake(removeButton.frame.origin.x, addtoListButton.frame.origin.y+ addtoListButton.frame.size.height+8, removeButton.frame.size.width, 0);
        //
        //        }
        
        
        costLabel.text = [NSString stringWithFormat:@"$%.2f",[[_productDetail valueForKey:@"Cost"] floatValue]];
        priceLabel.text = [NSString stringWithFormat:@"$%.2f",[[_productDetail valueForKey:@"Price"] floatValue]];
        
        
        
        
        
    }
    else{
        discriptionView.hidden = NO;
        
        productName.text=[_productDetail valueForKey:@"Item_Name"];
        stockNumberLabel.text=[NSString stringWithFormat:@"%d",[[_productDetail valueForKey:@"Quantity"] intValue]];
        locationLabel.text =[_productDetail valueForKey:@"Location"];
        
        CGSize maximumLabelSize = CGSizeMake(296,9999);
        
        CGSize expectedLabelSize = [[_productDetail valueForKey:@"Description1"] sizeWithFont:descriptionLabel.font
                                                                            constrainedToSize:maximumLabelSize
                                                                                lineBreakMode:descriptionLabel.lineBreakMode];
        
        //adjust the label the the new height.
        //        CGRect newFrame = descriptionLabel.frame;
        //        newFrame.size.height = expectedLabelSize.height;
        //        descriptionLabel.frame = newFrame;
        
        
        CGRect newFrame1 = discriptionView.frame;
        newFrame1.size.height = expectedLabelSize.height;
        discriptionView.frame = newFrame1;
        discriptionView.backgroundColor = [UIColor whiteColor];
        
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.minimumFontSize = 10;
        descriptionLabel.adjustsFontSizeToFitWidth = YES;
        descriptionLabel.text = [_productDetail valueForKey:@"Description1"];
        
        
        
        if ([[kGetValueForKey(USER_DATA) valueForKey:@"Role"] isEqualToString:@"A"]) {
            priceOnlyView.frame=CGRectMake(priceOnlyView.frame.origin.x, priceOnlyView.frame.origin.y, priceOnlyView.frame.size.width, priceOnlyView.frame.size.height);
            costOblyView.frame=CGRectMake(costOblyView.frame.origin.x, priceOnlyView.frame.origin.y+ priceOnlyView.frame.size.height, costOblyView.frame.size.width, costOblyView.frame.size.height);
            
            compositionViewOnly.frame=CGRectMake(compositionViewOnly.frame.origin.x, costOblyView.frame.origin.y+ costOblyView.frame.size.height, compositionViewOnly.frame.size.width,0);
            
            locationCompositionView.frame=CGRectMake(locationCompositionView.frame.origin.x, compositionViewOnly.frame.origin.y+ compositionViewOnly.frame.size.height, locationCompositionView.frame.size.width, locationCompositionView.frame.size.height);
            
            quantAndaddToView.frame=CGRectMake(quantAndaddToView.frame.origin.x, locationCompositionView.frame.origin.y+ locationCompositionView.frame.size.height, quantAndaddToView.frame.size.width, quantAndaddToView.frame.size.height);
            
            
        }
        else if ([[kGetValueForKey(USER_DATA) valueForKey:@"Role"] isEqualToString:@"E"]) {
            priceOnlyView.frame=CGRectMake(priceOnlyView.frame.origin.x, priceOnlyView.frame.origin.y, priceOnlyView.frame.size.width, priceOnlyView.frame.size.height);
            costOblyView.frame=CGRectMake(costOblyView.frame.origin.x, priceOnlyView.frame.origin.y+priceOnlyView.frame.size.height, costOblyView.frame.size.width,0);
            compositionViewOnly.frame=CGRectMake(compositionViewOnly.frame.origin.x, costOblyView.frame.origin.y+ costOblyView.frame.size.height, compositionViewOnly.frame.size.width,0);
            
            
            
            locationCompositionView.frame=CGRectMake(locationCompositionView.frame.origin.x, compositionViewOnly.frame.origin.y+ compositionViewOnly.frame.size.height, locationCompositionView.frame.size.width, locationCompositionView.frame.size.height);
            
            quantAndaddToView.frame=CGRectMake(quantAndaddToView.frame.origin.x, locationCompositionView.frame.origin.y+ locationCompositionView.frame.size.height, quantAndaddToView.frame.size.width, quantAndaddToView.frame.size.height);
            
            
            
        }
        else{
            priceOnlyView.frame=CGRectMake(priceOnlyView.frame.origin.x, priceOnlyView.frame.origin.y, priceOnlyView.frame.size.width,0);
            
            costOblyView.frame=CGRectMake(costOblyView.frame.origin.x, priceOnlyView.frame.origin.y+priceOnlyView.frame.size.height, costOblyView.frame.size.width,0);
            
            compositionViewOnly.frame=CGRectMake(compositionViewOnly.frame.origin.x, costOblyView.frame.origin.y+ costOblyView.frame.size.height, compositionViewOnly.frame.size.width,0);
            
            locationCompositionView.frame=CGRectMake(locationCompositionView.frame.origin.x, compositionViewOnly.frame.origin.y+ compositionViewOnly.frame.size.height, locationCompositionView.frame.size.width, locationCompositionView.frame.size.height);
            
            quantAndaddToView.frame=CGRectMake(quantAndaddToView.frame.origin.x, locationCompositionView.frame.origin.y+ locationCompositionView.frame.size.height, quantAndaddToView.frame.size.width, quantAndaddToView.frame.size.height);
            
            
            
            //            simpleView.backgroundColor = [UIColor yellowColor];
        }
        _quantityBtn.frame=CGRectMake(_quantityBtn.frame.origin.x,_collectionView.frame.origin.y+_collectionView.frame.size.height+quantAndaddToView.frame.origin.y+5, _quantityBtn.frame.size.width, _quantityBtn.frame.size.height);
        
        //
        
        scrollView.scrollEnabled=YES;
        
        if([_productDetail valueForKey:@"myQuantity"]!=nil  )
        {
            
            
            addtoListButton.frame=CGRectMake(addtoListButton.frame.origin.x, _collectionView.frame.size.height+ quantAndaddToView.frame.origin.y+ quantAndaddToView.frame.size.height+8, addtoListButton.frame.size.width, addtoListButton.frame.size.height);
            removeButton.frame=CGRectMake(removeButton.frame.origin.x, addtoListButton.frame.origin.y+ addtoListButton.frame.size.height+8, removeButton.frame.size.width, removeButton.frame.size.height);
            discriptionView.frame=CGRectMake(discriptionView.frame.origin.x, removeButton.frame.origin.y+removeButton.frame.size.height+8, discriptionView.frame.size.width, discriptionView.frame.size.height);
            
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,scrollView.frame.size.height+discriptionView.frame.size.height+removeButton.frame.size.height+priceLabel.frame.size.height+costLabel.frame.size.height+20);
            
        }
        else{
            
            addtoListButton.frame=CGRectMake(addtoListButton.frame.origin.x, _collectionView.frame.size.height+ quantAndaddToView.frame.origin.y+ quantAndaddToView.frame.size.height+8, addtoListButton.frame.size.width, addtoListButton.frame.size.height);
            removeButton.frame=CGRectMake(removeButton.frame.origin.x, addtoListButton.frame.origin.y+ addtoListButton.frame.size.height+8, removeButton.frame.size.width, 0);
            discriptionView.frame=CGRectMake(discriptionView.frame.origin.x, removeButton.frame.origin.y+ removeButton.frame.size.height+8, discriptionView.frame.size.width, discriptionView.frame.size.height);
            
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,scrollView.frame.size.height+discriptionView.frame.size.height+priceLabel.frame.size.height+costLabel.frame.size.height+20);
            
            
            
        }
        
        
        
        
        
        
        costLabel.text = [NSString stringWithFormat:@"$%.2f",[[_productDetail valueForKey:@"Cost"] floatValue]];
        priceLabel.text = [NSString stringWithFormat:@"$%.2f",[[_productDetail valueForKey:@"Price"] floatValue]];
        
        
    }
    
    if([_productDetail valueForKey:@"myQuantity"]!=nil  )
    {
        [_quantityBtn setTitle:[_productDetail valueForKey:@"myQuantity"] forState:UIControlStateNormal];
        addtoListButton.selected = YES;
        [removeButton setEnabled:YES];
        
        
    }
    else{
        [_quantityBtn setTitle:@"1" forState:UIControlStateNormal];
        addtoListButton.selected = NO;
        [removeButton setEnabled:NO];
        
        
        
    }
    
    if ([[_productDetail valueForKey:@"Quantity"] intValue]<10 ) {
        for (int i=1; i<=10; i++) {
            [pickerData addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    else{
        for (int i=1; i<=[[_productDetail valueForKey:@"Quantity"] intValue]; i++) {
            [pickerData addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    compositionLabel.text = @"";
    NSString *str  =[NSString stringWithFormat:Image_URL@"%@",[[_productDetail  valueForKey:@"Image_Path"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    //    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [fullImageIndicator startAnimating];
    
    fullImage.hidden=YES;
    [fullImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        fullImage.image  =  image;
        fullImage.hidden=NO;
        [fullImageIndicator stopAnimating];
    }];
    
    
    
    
    
    
    
    //    [fullImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
    //
    //        fullImage.image = image;
    //        [fullImageIndicator stopAnimating];
    //
    //
    //    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    //
    //        //[UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
    //        //        [cell.collectIndicator stopAnimating];
    //        [fullImageIndicator stopAnimating];
    //
    //    }];
    //    scrollView.delaysContentTouches = NO;
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    //    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProductList"];
    //    device = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
    [self.view bringSubviewToFront:removeButton];
}





#pragma mark collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    collectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    
    //    UIImageView *imgView = (UIImageView*)[cell viewWithTag:101];
    //    UIActivityIndicatorView *indiCator =(UIActivityIndicatorView*)[cell viewWithTag:102];
    
    [cell.collectIndicator startAnimating];
    
    //    imgView.image = [UIImage imageNamed:@"imgFb"];
    NSString *str  =[NSString stringWithFormat:Image_URL@"%@",[[_productDetail  valueForKey:@"Image_Path"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    
    //    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    //    [fullImageIndicator startAnimating];
    
    cell.collectImage.hidden=YES;
   
    [cell.collectImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.collectImage.image  =  image;
        cell.collectImage.hidden=NO;
        [cell.collectIndicator stopAnimating];
    }];
    
//    
//    [cell.collectImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        cell.collectImage.image  =  image;
//        cell.collectImage.hidden=NO;
//        [cell.collectIndicator stopAnimating];
//    }];
    
    
    
    //    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    //
    //    [cell.collectImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
    //
    //        cell.collectImage.image = image;
    //        [cell.collectIndicator stopAnimating];
    //
    //    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    //        [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
    //        [cell.collectIndicator stopAnimating];
    //    }];
    //
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    
    return 100;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return CGSizeMake(150, 150);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    
    CGSize size = CGSizeMake(screenWidth, 230);
    return size;
    
}
#pragma mark -UIpicker delegates

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return pickerData.count;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return pickerData[row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    [_quantityBtn setTitle:pickerData[row] forState:UIControlStateNormal];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [UIView animateWithDuration:0.3
                     animations:^{}
                     completion:^(BOOL finished){
                         CGFloat pageWidth = self.collectionView.frame.size.width;
                         _pageControll.currentPage = _collectionView.contentOffset.x / pageWidth;}];
    
}
- (IBAction)sideBtnPressed:(id)sender {
    
    if (_isFromScanner) {
        [self dismissViewControllerAnimated:YES completion:nil];
        _isFromScanner = NO;
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}
- (IBAction)quantityBtnSelect:(id)sender {
    if (!picker) {
        CGRect pickerFrame = CGRectMake(0, self.view.frame.size.height-170, self.view.frame.size.width, 170);
        picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        picker.backgroundColor = [UIColor whiteColor];
        picker.delegate= self;
        [self.view addSubview:picker];
    }
}
- (IBAction)gestureTapped:(id)sender {
    [picker removeFromSuperview];
    picker = nil;
    [picker resignFirstResponder];
}




- (IBAction)addToListAction:(id)sender {
    
    if (kGetValueForKey(listName) == nil) {
        //        ListDetailsViewController *move=[self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailsViewController"];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ListViewController *storyViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ListViewController"];
        storyViewController.isFromLeft=YES;
        [self.navigationController pushViewController:storyViewController animated:YES]; //  present it
        
    }
    else{
        
        NSManagedObjectContext *context = [self managedObjectContext];
        if (self.device) {
            // Update existing device
            //        _productDetail
            //        [self.device setValue:[[groceryProductData sharedManager] getListName] forKey:@"listName"];
            
            NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:[_productDetail mutableCopy]];
            [self.device setValue:arrayData forKey:@"productDetails"];
            [self.device setValue:_quantityBtn.titleLabel.text forKey:@"quantity"];
            
            
            
            
            
        } else {
            if([_productDetail valueForKey:@"myQuantity"]!=nil  )
            {
                
                [[groceryProductData sharedManager] updateQuantity:[_productDetail valueForKey:@"ItemNum"] withQuantity:_quantityBtn.titleLabel.text];
                [[Server sharedManager] showToastInView:appDelegate.window.self.rootViewController toastMessage:@"Product Updated in list successfully" withDelay:3];
                
                
            }
            else{
                [[groceryProductData sharedManager] saveMyProduct:[_productDetail mutableCopy] quantity:_quantityBtn.titleLabel.text mylistName:kGetValueForKey(listName) notes:kGetValueForKey(notesText)];
                
                [[Server sharedManager] showToastInView:appDelegate.window.self.rootViewController toastMessage:@"Product added in list successfully" withDelay:3];
                
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
        [_productDetail setValue:_quantityBtn.titleLabel.text forKey:@"myQuantity"];
        
        removeButton.frame=CGRectMake(removeButton.frame.origin.x, addtoListButton.frame.origin.y+ addtoListButton.frame.size.height+8, removeButton.frame.size.width, addtoListButton.frame.size.height);
        
        [self viewDidLoad];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)closeFullImageAction:(id)sender {
    blurEffectView.hidden =YES;
    fullImageView.hidden=YES;
    
}

- (IBAction)removeItemAction:(id)sender {
    
    
    
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"Alert" message:@"Are you sure to delete this product"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes, please"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //What we write here????????**
                                    //                                    NSLog(@"%ld  %@",(long)deletedIndex.tag,[savedList objectAtIndex:deletedIndex.tag]);
                                    [[groceryProductData sharedManager] deleteClubsEntity:[_productDetail valueForKey:@"ItemNum"]];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)imageShowFUllScreenTap:(id)sender {
    [self.view endEditing:YES];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        //        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        [self.view addSubview:blurEffectView];
        fullImageView.hidden=NO;
        
        
        [self.view bringSubviewToFront:fullImageView];
        
        
    }
    else {
        self.view.backgroundColor = [UIColor blackColor];
    }
    
}
- (IBAction)closeFullImageView:(id)sender {
}




@end
