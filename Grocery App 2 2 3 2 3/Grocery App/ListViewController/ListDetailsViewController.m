//
//  ListDetailsViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "ListDetailsViewController.h"
#import "ListCell.h"
#import "DetailListViewController.h"
#import "NoteListPopUp.h"
#import "searchResultView.h"
#import "groceryProductData.h"
#import "ListViewController.h"
#import "Server.h"
#import "ZBarSDK.h"

@interface ListDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,ZBarReaderDelegate>
{
    NSMutableArray *savedList;
    NSMutableDictionary *selectedProductIdAnsQuant;
    NSString *myPdfList;
    
    NSManagedObject *device;
    ZBarReaderViewController *codeReader;
    
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListDetailsViewController{
    UIPickerView *picker;
    NSArray *pickerData;
}


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
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy_HH:mm"];
    
    myPdfList = [NSString stringWithFormat:@"MyList_On_%@",[formatter stringFromDate:[NSDate date]] ];
//    myPdfList = 
    [self getData];
    
    [self.view removeGestureRecognizer:pickerAndSaveTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"updateProducts" object:nil];
    
    
}
-(void)refreshView{
    [self getData];
}
-(void)getData{
    savedList =  [[groceryProductData sharedManager] mySavedList];
    NSLog(@"%@",[[groceryProductData sharedManager] getListName]);
    listNameString.text =[[groceryProductData sharedManager] getListName];
    
    [_tableView reloadData];
    selectedProductIdAnsQuant = [[NSMutableDictionary alloc] init];
    if(savedList.count<=0)
    {
        nodatafoundlabel.hidden=NO;
        _tableView.hidden = YES;
    }
    else{
        nodatafoundlabel.hidden=YES;
        _tableView.hidden = NO;;
        
    }
    
    pickerData = @[@"1",@"2",@"3",@"4",@"5"];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Products" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    // Do any additional setup after loading the view.
    
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return savedList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // cell.m_imageView.image = [UIImage imageNamed:@"imgHomePurchases"];
    [cell.btnQuantity setTitle:[NSString stringWithFormat:@"%d",[[[savedList objectAtIndex:indexPath.row] valueForKey:@"myQuantity"] intValue]] forState:UIControlStateNormal];
    [cell.btnQuantity addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnQuantity.tag = indexPath.row;
    //  cell.btnQuantity.layer.borderWidth = 1.0;
    //  cell.btnQuantity.layer.borderColor = [[UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1.0] CGColor];
    
    
    [cell.indicator startAnimating];
    if([[savedList objectAtIndex:indexPath.row] valueForKey:@"Item_Name"] == nil)
    {
        cell.lblName.text=[[savedList objectAtIndex:indexPath.row] valueForKey:@"Movie_Name"];
        
    }
    else{
        cell.lblName.text=[[savedList objectAtIndex:indexPath.row] valueForKey:@"Item_Name"];
        
    }
    cell.lblDetails.text=[NSString stringWithFormat:@"In Stock %d",[[[savedList objectAtIndex:indexPath.row] valueForKey:@"Quantity"] intValue]];
    //Quantity
    NSString *str  =[[NSString stringWithFormat:Image_URL@"%@",[[savedList objectAtIndex:indexPath.row] valueForKey:@"Thumb_Image_Path"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    //    NSString *newString = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    cell.m_imageView.hidden=YES;
//
    [cell.m_imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.m_imageView.image  =  image;
        cell.m_imageView.hidden=NO;
        [cell.indicator stopAnimating];
    }];
    
    

    
    
    
    
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
//    [cell.m_imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"indiaMartGreyBg"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        
//        
//        cell.m_imageView.image = image;
//        [cell.indicator stopAnimating];
//        
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        //     [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Image no Found" cancelTitle:@"ok"];
//        [cell.indicator stopAnimating];
//        
//    }];
    //    [UIImage imageNamed:@"imgRewards"];
    //    return  cell;
    cell.btnCancel.tag=indexPath.row;
    [cell.btnCancel addTarget:self action:@selector(deleteObject:) forControlEvents:UIControlEventTouchUpInside];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailListViewController *detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailListViewController"];
    
    
    NSMutableDictionary  *tempDict= (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(NULL, CFBridgingRetain([[savedList objectAtIndex:indexPath.row]  mutableCopy]), kCFPropertyListMutableContainersAndLeaves));
    
    
    
    detailVc.productDetail = tempDict;
    
    
    
    [self.navigationController pushViewController:detailVc animated:YES];
}
-(void)deleteObject:(UIButton *)deletedIndex{
    
    
    
    
    
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:@"Alert" message:@"Are you sure to delete this product"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes, please"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //What we write here????????**
                                    NSLog(@"%ld  %@",(long)deletedIndex.tag,[savedList objectAtIndex:deletedIndex.tag]);
                                    [[groceryProductData sharedManager]deleteClubsEntity:[[savedList objectAtIndex:deletedIndex.tag] valueForKey:@"ItemNum"]];
                                    [savedList removeObjectAtIndex:deletedIndex.tag];
                                    [_tableView reloadData];
                                    if (savedList.count<=0) {
                                        _tableView.hidden = YES;
                                        nodatafoundlabel.hidden = NO;
                                    }
                                    
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


- (IBAction)btnClicked:(UIButton *)sender
{
    
    if (!picker) {
        CGRect pickerFrame = CGRectMake(0, self.view.frame.size.height-170, self.view.frame.size.width, 170);
        picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        picker.backgroundColor = [UIColor whiteColor];
        picker.delegate= self;
        [selectedProductIdAnsQuant setObject:[[savedList objectAtIndex: sender.tag] valueForKey:@"productId"]forKey:@"productId"];
        [selectedProductIdAnsQuant setObject:[[savedList objectAtIndex: sender.tag] valueForKey:@"myQuantity"]forKey:@"myQuantity"];
        
        
        [self.view addGestureRecognizer:pickerAndSaveTap];
        [self.view addSubview:picker];
        
        
        
    }
    picker.tag= sender.tag;
}

- (IBAction)noteBtnClicked:(id)sender {
    NoteListPopUp *notePop = [[NoteListPopUp alloc]initWithListName:self.view.frame delegate:self];
    [self.view addSubview:notePop];
}
- (IBAction)emailBtnClicked:(id)sender {
}
-(void)saveBtnTapped :(NoteListPopUp *)view{
    [view removeFromSuperview];
    //    ListDetailsViewController *listView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailsViewController"];
    //    kSetBoolValueForKey(IsListCreated, YES);
    //    [self.navigationController pushViewController:listView animated:YES];
    
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
    ListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:pickerView.tag inSection:0]];
    [cell.btnQuantity setTitle:pickerData[row] forState:UIControlStateNormal];
    
    [selectedProductIdAnsQuant setObject:pickerData[row]forKey:@"myQuantity"];
    
    
    
}
- (IBAction)sideBtnPressed:(id)sender {
    // [self.navigationController popViewControllerAnimated:YES];
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
            [self addtoLocalData:dict];
        }
        else{
            DetailListViewController *detail= [self.storyboard instantiateViewControllerWithIdentifier:@"DetailListViewController"];
            
            NSMutableDictionary  *tempDict= (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(NULL, CFBridgingRetain([dict  mutableCopy]), kCFPropertyListMutableContainersAndLeaves));
            
            detail.isFromScanner = YES;

            
            detail.productDetail = [tempDict  mutableCopy];
            [reader presentViewController:detail animated:YES completion:nil];
//            [reader dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Product Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
    
    
    // dismiss the controller
}


-(void)addtoLocalData:(NSMutableDictionary *) dataArray{
    
    
    
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
                
                
                //                UIAlertController * alert=[UIAlertController
                //
                //                                           alertControllerWithTitle:@"Alert" message:@"Already Added To List /n Do You want to update?"preferredStyle:UIAlertControllerStyleAlert];
                //
                //               UIAlertAction* yesButton = [UIAlertAction
                //                                                            actionWithTitle:@"Yes, please"
                //                                                            style:UIAlertActionStyleDefault
                //                                                            handler:^(UIAlertAction * action)
                //                                                            {
                //                                                                //What we write here????????**
                //
                //                                                                [[groceryProductData sharedManager]deleteClubsEntity:[dataArray valueForKey:@"productId"]];
                //                                                                NSLog(@"you pressed Yes, please button");
                //                                                                [alert dismissViewControllerAnimated:YES completion:nil];
                //
                //                                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateProducts" object:nil];
                //                //                                                [productTableView reloadData];
                //
                //                                                                // call method whatever u need
                //                                                            }];
                //                UIAlertAction* noButton = [UIAlertAction
                //                                           actionWithTitle:@"No, thanks"
                //                                           style:UIAlertActionStyleDefault
                //                                           handler:^(UIAlertAction * action)
                //                                           {
                //                                               //What we write here????????**
                //                                               [alert dismissViewControllerAnimated:YES completion:nil];
                //
                //                                               NSLog(@"you pressed No, thanks button");
                //                                               // call method whatever u need
                //
                //                                           }];
                //
                //                   [alert addAction:yesButton];
                //                [alert addAction:noButton];
                //
                //                [codeReader presentViewController:alert animated:YES completion:nil];
                //
                //
                //
                
                
                
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



- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename {
    
    CGRect priorBounds = _tableView.bounds;
    CGSize fittedSize = [_tableView sizeThatFits:CGSizeMake(priorBounds.size.width, HUGE_VALF)];
    _tableView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, _tableView.bounds, nil);
    
    
    UIGraphicsBeginPDFPage();
    
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:pdfContext];
    
    UIGraphicsEndPDFContext();
    
    
    _tableView.bounds = CGRectMake(0, sampleView.frame.origin.y , _tableView.frame.size.width,sampleView.frame.size.height-44);
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    
    
    [self getPDF];
}

-(void)getPDF {
    //    displayPDFView.hidden=NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:myPdfList];
    NSLog(@"filePath: %@",filePath);
    
    NSData *data= [NSData dataWithContentsOfFile:filePath];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
   [mc setSubject:[NSString stringWithFormat:@"My List: %@",kGetValueForKey(listName)]];
    [mc setMessageBody:[NSString stringWithFormat:@"My Notes: %@",kGetValueForKey(notesText)] isHTML:NO];
    //        NSMutableData *pdfData = [self createPDFfromUIViews:myImage saveToDocumentsWithFileName:@"PDF Name"];
    // Attach an image to the email
    [mc addAttachmentData:data mimeType:@"application/pdf" fileName:myPdfList];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    //        [self createPDFfromUIViews:myImage saveToDocumentsWithFileName:@"PDF Name"];
    
    //    displayPDFView.hidden = YES;
    //    [self printscreen];
}
//- (NSMutableData *)createPDFfromUIViews:(UIView *)myImage saveToDocumentsWithFileName:(NSString *)string
//{
//    NSMutableData *pdfData = [NSMutableData data];
//
//    UIGraphicsBeginPDFContextToData(pdfData, myImage.bounds, nil);
//    UIGraphicsBeginPDFPage();
//    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//
//
//    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
//
//    [myImage.layer renderInContext:pdfContext];
//
//    // remove PDF rendering context
//    UIGraphicsEndPDFContext();
//    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//
//    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
//    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:string];
//
//    NSLog(@"%@",documentDirectoryFilename);
//    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
//
//    return pdfData;
//
//
//}




-(IBAction)email:(id)sender{
    
    if (kGetValueForKey(IsListCreated)) {
        [self createPDFfromUIView:_tableView saveToDocumentsWithFileName:myPdfList];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"List Not Created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

        
        
        
    }
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)gestureTapped:(id)sender {
    
    
    if (selectedProductIdAnsQuant.count >0) {
        [[groceryProductData sharedManager] updateQuantity:[selectedProductIdAnsQuant valueForKey:@"productId"] withQuantity:[selectedProductIdAnsQuant valueForKey:@"myQuantity"]];
    }
    [selectedProductIdAnsQuant removeAllObjects];
    
    [picker removeFromSuperview];
    picker = nil;
    [picker resignFirstResponder];
    [self.view removeGestureRecognizer:pickerAndSaveTap];
    
    
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    [self.navigationController pushViewController:resultScreen animated:YES];
    return  NO;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    [self.navigationController pushViewController:resultScreen animated:YES];
    
    
}

@end
