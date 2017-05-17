//
//  CategoriesViewController.m
//  Grocery App
//
//  Created by Eweb-A1-iOS on 16/09/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "CategoriesViewController.h"
#import "ArivalsViewController.h"
#import "searchResultView.h"
#import "HomePageViewController.h"
#import "ListViewController.h"
#import "Server.h"
#import "ZBarSDK.h"

@interface CategoriesViewController ()<UITableViewDelegate,UITableViewDataSource,ZBarReaderDelegate>{
 NSMutableArray  *arrCategories,*allCategories;
  NSArray *arrSubCategories,*allCategory;
 NSMutableArray *subCategories;
 NSInteger selectedCell;
    NSData *imageData;
    NSString *filename;
    NSManagedObject *device;
    ZBarReaderViewController *codeReader;

    
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CategoriesViewController


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
  
    filename = @"MypdfFile";
    [self createRandomData];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [super viewDidLoad];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Products" attributes:@{NSForegroundColorAttributeName: color}]];
    }
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }

//       NSMutableDictionary *allData=[[NSMutableDictionary alloc] init];
//    for (int i=0; i<[allCategories count]; i++) {
//        [allData setObject:arrSubCategories forKey:[allCategories objectAtIndex:i]];
//        }
//    
//    arrCategories = [[NSMutableArray alloc] initWithArray:allCategories];
// subCategories = [[NSMutableArray alloc]init];
 selectedCell = -1;
    // Do any additional setup after loading the view.
}

-(void)createRandomData{
    
    
    NSMutableArray *allNames= [[NSMutableArray alloc] initWithObjects:@"Health Drinks",@"Juice Mixes",@"Drinks",@"Mango Pulp",@"Tea",@"Coffee",
                               @"Soups",@"Noodles",@"Infant Food",@"Sauces",@"Fresh Snacks",@"Pickles",@"Instant Mixes",@"Ready To Eat",@"Snacks",
                               @"Gourmet Kitchen",@"Gourmet Powders",@"Gourmet Papad",@"Gourmet Cookies",@"Gourmet Oats",@"Gourmet Spices",@"Gourmet Pickles",@"Gourmet Sweets",@"Gourmet Snacks",
                               @"Shampoo",@"Cosmetics",@"Hair Oil",@"Soaps",@"Medicines",@"Henna - Dye",
                               @"North Snacks",@"Bread",@"Sweets",@"South Snacks",@"Dairy Products",@"Icecreams",@"Entrees - Dinners",@"Vegetables",@"Non-Vegetarian",
                               @"Colors - Essences",@"Appliances", @"Calling Cards",@"Pooja Items",@"Custard - Sugar",@"Gifts",
                               @"Jams - Jello",@"Biscuits",@"Fresh Sweets",@"Desserts - Sweets",@"Cookies - Rusks",@"Candy",
                               @"Soya-Vadi", @"Sabudana",@"Besan",@"Rice",@"Dals/Lentils",@"Nuts - Dry Fruits",@"Mamra - Poha",@"Atta",@"Flours",
                               @"Fresh Vegetables",@"Meat",@"Produce", @"Vermicelli",@"Tamarind",@"Ghee",@"Papad",@"Coconut",@"Jaggery",@"Mukhwas",
                               @"Cooking Oils",@"Spice Mixes",@"Canned Vegetables",@"Chutneys - Pastes", @"Loose Spices",@"Saffron",
                               nil];
    
    NSMutableArray *allId = [[NSMutableArray alloc] initWithObjects:@"9",@"64",@"59",@"32",@"30",@"10",
                             @"8",@"5",@"42",@"4",@"34",@"29",@"28",@"26",@"21",
                             @"77",@"73",@"72",@"71",@"70",@"69",@"67",@"65",@"49",
                             @"76",@"51",@"48",@"47",@"44",@"43",
                             @"7",@"63",@"62",@"6",@"57",@"54",@"53",@"52",@"16",
                             @"68",@"61", @"60",@"46",@"17",@"15",
                             @"74",@"66",@"58",@"24",@"23",@"11",
                             @"37", @"36",@"35",@"3",@"27",@"25",@"19",@"18",@"14",
                             @"75",@"56",@"55", @"50",@"45",@"39",@"22",@"20",@"2",@"12",
                             @"41",@"38",@"33",@"31", @"13",@"1",
                             nil];
   
    NSMutableArray *allSubcategory = [[NSMutableArray alloc] init];
    for (int i=0; i<[allNames count]; i++) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:[allNames objectAtIndex:i] forKey:@"subCatName"];
        [dict setObject:[allId objectAtIndex:i] forKey:@"subCatId"];
        [allSubcategory addObject:dict];
    }
  
    allSubcategory = [self sortByALphabets:[allSubcategory mutableCopy]];
    
    allCategory = [[NSMutableArray alloc] initWithObjects:@"Beverages" ,@"Instant Food",@"Gourmet Food",@"Beauty & Health",@"Frozen Foods",@"e-Miscellaneous",@"Confectionaries",@"Staples",@"Groceries",@"Cooking Essentials",nil];
    
    
    allCategory = [[allCategory mutableCopy] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableArray *Beverages=[[[[NSMutableArray alloc] initWithObjects:@"9",@"64",@"59",@"32",@"30",@"10", nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    NSMutableArray *Instant_Food=[[[[NSMutableArray alloc] initWithObjects:@"8",@"5",@"42",@"4",@"34",@"29",@"28",@"26",@"21",
nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    NSMutableArray *Gourmet_Food=[[[[NSMutableArray alloc] initWithObjects:@"77",@"73",@"72",@"71",@"70",@"69",@"67",@"65",@"49",
                        nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    NSMutableArray *Beauty_and_Health=[[[[NSMutableArray alloc] initWithObjects: @"76",@"51",@"48",@"47",@"44",@"43", nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    NSMutableArray *Frozen_Foods=[[[[NSMutableArray alloc] initWithObjects:@"7",@"63",@"62",@"6",@"57",@"54",@"53",@"52",@"16", nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    NSMutableArray *e_Miscellaneous=[[[[NSMutableArray alloc] initWithObjects:@"68",@"61", @"60",@"46",@"17",@"15", nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    
    NSMutableArray *Confectionaries=[[[[NSMutableArray alloc] initWithObjects:@"74",@"66",@"58",@"24",@"23",@"11", nil]sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    
    NSMutableArray *Staples=[[[[NSMutableArray alloc] initWithObjects:@"37", @"36",@"35",@"3",@"27",@"25",@"19",@"18",@"14", nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    NSMutableArray *Groceries=[[[[NSMutableArray alloc] initWithObjects:@"75",@"56",@"55", @"50",@"45",@"39",@"22",@"20",@"2",@"12", nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
    
    NSMutableArray *Cooking_Essentials=[[[[NSMutableArray alloc] initWithObjects:@"41",@"38",@"33",@"31", @"13",@"1", nil] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES]]] mutableCopy];
   
     NSMutableArray *allKeys=[[NSMutableArray alloc] initWithObjects:Beauty_and_Health,Beverages,Confectionaries,Cooking_Essentials,e_Miscellaneous,Frozen_Foods,Gourmet_Food,Groceries,Instant_Food,Staples, nil];

    NSMutableDictionary *dictWithId=[[NSMutableDictionary alloc] initWithObjects:allKeys forKeys:allCategory];


    
    
  
    

    
    for (int i=0; i<[allCategory count]; i++) {
        
//        NSLog(@"%lu %@",(unsigned long)[[dictWithId valueForKey:[allCategory objectAtIndex:i]] count],[allCategory objectAtIndex:i]);
        NSMutableArray *arrayMustBeSort;
//        =[[NSMutableArray alloc] init];
        
        
        NSMutableArray *dataArray= [dictWithId valueForKey:[allCategory objectAtIndex:i]];
        for (int j=0; j<[dataArray count]; j++) {
            arrayMustBeSort =[[NSMutableArray alloc] init];

            
            NSLog(@"%@",[dictWithId valueForKey:[allCategory objectAtIndex:i]]);
           
            NSMutableArray *dataArray2= [dictWithId valueForKey:[allCategory objectAtIndex:i]];
          

            for (int k=0; k<[dataArray2 count]; k++) {
                    NSLog(@"%@",[[dictWithId valueForKey:[allCategory objectAtIndex:i]] objectAtIndex:k]);
               
                for (int l=0; l<[allSubcategory count]; l++) {
                    if ([[[allSubcategory objectAtIndex:l] valueForKey:@"subCatId"] isEqualToString:[[dictWithId valueForKey:[allCategory objectAtIndex:i]] objectAtIndex:k]]) {
                        NSLog(@"%@",[[allSubcategory objectAtIndex:l] valueForKey:@"subCatId"]);
                       
                      
                        [arrayMustBeSort addObject:[allSubcategory objectAtIndex:l]];
                        
                        
                        
                        
                        
                    }
                }
                
                
                
                
            }
            
            
        }
        arrayMustBeSort =   [self sortByALphabets:[arrayMustBeSort mutableCopy]];
        
        [dictWithId  setObject:arrayMustBeSort forKey:[allCategory objectAtIndex:i]];

    }
    
    
    allCategories = [dictWithId mutableCopy];
    

    
}


-(NSMutableArray *)sortByALphabets:(NSMutableArray *)dataArray{
    
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"subCatName" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    NSArray *sortedArray = [[dataArray mutableCopy] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *sortedMutableArray = [sortedArray mutableCopy];
    return sortedMutableArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%lu",(unsigned long)allCategories.count);
 return allCategories.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 if (selectedCell==section) {
//   return subCategories.count;
//     NSLog(@"%lu",(unsigned long)[[allCategories valueForKey:[allCategory objectAtIndex:section]] count]);
     NSMutableArray *dataArray2= [allCategories valueForKey:[allCategory objectAtIndex:section]];

     return [dataArray2 count];

 }else{
  return 0;
 }

}


-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
 if (cell==nil) {
  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
  
 }
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
 cell.textLabel.text = [[[allCategories valueForKey:[allCategory objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] valueForKey:@"subCatName"];
 cell.textLabel.textColor = [UIColor darkGrayColor];
     cell.textLabel.font = [UIFont systemFontOfSize:19.0f];
    
 return  cell;
}





-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
 view.backgroundColor = [UIColor whiteColor];
 view.tag = section;
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 17.5, tableView.frame.size.width, 25)];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
 label.textColor = [UIColor blackColor];
 NSString *string =allCategory[section];
 [label setText:string];
 UILabel *separator = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, tableView.frame.size.width, 1)];
 separator.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1.0];
 [view addSubview:label];
  [view addSubview:separator];
 UIImageView *imageView=  [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-30, label.frame.origin.y+label.frame.size.height/2, 15, 10)];
 if (selectedCell==section) {
  imageView.image = [UIImage imageNamed:@"imgArrow1"];
 }
 else{
 imageView.image = [UIImage imageNamed:@"imgArrowDown"];
 }
 [view addSubview:imageView];
 
 UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
 [view addGestureRecognizer:gesRecognizer];
 return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 return 60.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",[[allCategories valueForKey:[allCategory objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);
    
 ArivalsViewController *arival = [self.storyboard instantiateViewControllerWithIdentifier:@"ArivalsViewController"];
    arival.deptId=[[allCategories valueForKey:[allCategory objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
 arival.isFromLeft=YES;
 [self.navigationController pushViewController:arival animated:YES];
}


- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer{
 
 [subCategories removeAllObjects];
 if (selectedCell ==gestureRecognizer.view.tag) {
  selectedCell = -1;
  }
 else{
  selectedCell=gestureRecognizer.view.tag;
 [subCategories addObjectsFromArray:arrSubCategories];
 }
 [self.tableView reloadData];
 }


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
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

- (IBAction)sideBarTapped:(id)sender {
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (IBAction)scanAction:(id)sender {
//    
//    CGRect priorBounds = self.tableView.bounds;
//    CGSize fittedSize = [self.tableView sizeThatFits:CGSizeMake(priorBounds.size.width, self.tableView.contentSize.height)];
//    self.tableView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
//    
//    CGRect pdfPageBounds = CGRectMake(0, 0, 612, 792); // Change this as your need
//    NSMutableData *pdfData = [[NSMutableData alloc] init];
//    
//    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
//        for (CGFloat pageOriginY = 0; pageOriginY < fittedSize.height; pageOriginY += pdfPageBounds.size.height) {
//            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
//            
//            CGContextSaveGState(UIGraphicsGetCurrentContext()); {
//                
//                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY);
//                [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
//                
//                
//            } CGContextRestoreGState(UIGraphicsGetCurrentContext());
//        }
//    } UIGraphicsEndPDFContext();
//    
//    self.tableView.bounds = priorBounds; // Reset the tableView
//    
//    
//
//    // Use the pdfData to
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//    NSString *filePathPDF = [documentsPath stringByAppendingPathComponent:@"cool.pdf"];
//    BOOL written = [pdfData writeToFile:filePathPDF atomically:YES];
//               //Add the file name
//    NSData *myData = [NSData dataWithContentsOfFile:filePathPDF];
//    
//    UIImage *image = [UIImage imageWithData:myData];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    
    
    
//    NSString *pdfPath = [documentsPath stringByAppendingPathComponent:@"test.pdf"];
//    NSData *myData = [NSData dataWithContentsOfFile:pdfPath];

    
    
//    NSData *data               = //some nsdata
//    CFDataRef myPDFData        = (CFDataRef)data;
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
//    CGPDFDocumentRef pdf       = CGPDFDocumentCreateWithProvider(provider);
   
    
    
//    [self createPDFfromUIView:pdfPageBounds saveToDocumentsWithFileName:filePathPDF];
    
//    CGRect frame = self.tableView.frame;
//    frame.size.height = self.tableView.contentSize.height;
//    self.tableView.frame = frame;
//    
//    UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, self.tableView.opaque, 0.0);
//    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    imageData = UIImagePNGRepresentation(saveImage);
//    
//    UIImage *image = [UIImage imageWithData:imageData];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    
//    
//    [self createPDFfromUIView:imageView saveToDocumentsWithFileName:filename];
//    
    
//    UIImage *image=[self captureView:self.tableView withcgrect:pdfPageBounds];
//    imageData = UIImagePNGRepresentation(image);
//    
//        UIImage *image2 = [UIImage imageWithData:imageData];
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:image2];
//
//    
//        [self createPDFfromUIView:imageView saveToDocumentsWithFileName:filename];
//
    
    
}

- (UIImage *)captureView:(UIView *)view withcgrect:(CGRect )pdfPageBounds{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(pdfPageBounds.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, pdfPageBounds);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (IBAction)save:(id)sender {
    // save all table
    CGRect frame = self.tableView.frame;
    frame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = frame;
    
    UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, self.tableView.opaque, 0.0);
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    imageData = UIImagePNGRepresentation(saveImage);
    
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    
    [self createPDFfromUIView:imageView saveToDocumentsWithFileName:filename];
}

- (NSMutableData*)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return pdfData;
}



-(IBAction)email:(id)sender{
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    
    NSMutableData *pdfData = [self createPDFfromUIView:imageView saveToDocumentsWithFileName:filename];
    // Attach an image to the email
    [mc addAttachmentData:pdfData mimeType:@"application/pdf" fileName:filename];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
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
//



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
            detail.productDetail = tempDict;
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


@end
