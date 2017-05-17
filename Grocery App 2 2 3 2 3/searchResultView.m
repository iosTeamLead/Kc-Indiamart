//
//  searchResultView.m
//  Grocery App
//
//  Created by eweba1-pc-80 on 9/24/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "searchResultView.h"
#import "searchResultCellClass.h"
#import "groceryProductData.h"
#import "DetailListViewController.h"
@interface searchResultView ()
{
    NSMutableArray *productListArray,*filterArray;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation searchResultView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [[groceryProductData sharedManager] hitAgainForSearch];

    
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    [_searchBar setBarTintColor:[UIColor clearColor]];
    for (UIView *subview in [[_searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        
        if (_isMovie) {
            [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Movies" attributes:@{NSForegroundColorAttributeName: color}]];
        }
        else{
            [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Products" attributes:@{NSForegroundColorAttributeName: color}]];

        }
    }


    if (_isMovie) {
        productListArray = [_moviesArray mutableCopy];
        filterArray = [[NSMutableArray alloc] init];
                _searchBar.text= _searchText;
        
        for(NSMutableDictionary *curString in productListArray) {
            if ([[curString valueForKey:@"Movie_Name"] rangeOfString:[_searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] options:NSCaseInsensitiveSearch].location != NSNotFound) {
                           [filterArray addObject:curString];
                
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Movie_Name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        NSArray *sortedArray = [[filterArray mutableCopy] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        filterArray =  [sortedArray mutableCopy];

    }
    else{
        NSMutableArray *dataArray = [[groceryProductData sharedManager] groceryProductList];
        
        productListArray = [[groceryProductData sharedManager] checkForsavedOrNotWithProducts:[dataArray mutableCopy]];
        
        filterArray = [[NSMutableArray alloc] init];
        
        //    NSString *trimmed = [_searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        _searchBar.text= _searchText;
        //        NSString* newText = [self.searchBar.text stringByReplacingCharactersInRange:range withString:text];
        
        for(NSMutableDictionary *curString in productListArray) {
            //NSRange substringRange = [curString rangeOfString:substring];
            
            if ([[curString valueForKey:@"Item_Name"] rangeOfString:[_searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] options:NSCaseInsensitiveSearch].location != NSNotFound) {
//                NSLog(@"curString %@",curString);
                [filterArray addObject:curString];
                
                
            }
        }
        //        if(arrCategories.count<=0 && newText.length==0){
        //            arrCategories = [allCategories mutableCopy];
        //        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Item_Name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        NSArray *sortedArray = [[filterArray mutableCopy] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        filterArray =  [sortedArray mutableCopy];

    }
    
    
//    NSArray *sorted = [[filterArray valueForKey:@"Item_Name"]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    filterArray = [sorted  mutableCopy];
//
    [_searchBar becomeFirstResponder];
    
        [searchResultTableView reloadData];
    

    
    
    
    
    
    
    
    
    
}
- (IBAction)leftBtnPressed:(id)sender {
//    [self.searchBar resignFirstResponder];
//    MMDrawer *drawer = (MMDrawer *)[[self parentViewController] parentViewController];
//    [drawer toggleDrawerSide: MMDrawerSideLeft animated:YES completion:^(BOOL finished) { }];
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma -mark searchfield delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTxt {
    
    
}
- (IBAction)tapAction:(id)sender {
    if (_searchBar.text.length<=0) {
        [self.view endEditing: YES];

    }
    
    

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
//    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
//    [self.navigationController pushViewController:resultScreen animated:YES];
    
    
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
[filterArray removeAllObjects];
    NSString* newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    
    
    if (_isMovie) {
        for(NSMutableDictionary *curString in productListArray) {
            //NSRange substringRange = [curString rangeOfString:substring];
            
            if ([[curString valueForKey:@"Movie_Name"] rangeOfString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] options:NSCaseInsensitiveSearch].location != NSNotFound) {
//                NSLog(@"curString %@",curString);
                [filterArray addObject:curString];
                
                
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Movie_Name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        NSArray *sortedArray = [[filterArray mutableCopy] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        filterArray =  [sortedArray mutableCopy];

        filterArray  = [[self groupsWithDuplicatesMovie_NameRemoved:[filterArray mutableCopy]] mutableCopy];
        
        
    }
    else{

    
    
    for(NSMutableDictionary *curString in productListArray) {
        //NSRange substringRange = [curString rangeOfString:substring];
        
        if ([[curString valueForKey:@"Item_Name"] rangeOfString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            NSLog(@"curString %@",curString);
            [filterArray addObject:curString];
            
            
        }
    }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Item_Name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        NSArray *sortedArray = [[filterArray mutableCopy] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        filterArray =  [sortedArray mutableCopy];
        filterArray  = [[self groupsWithDuplicatesItemNumRemoved:[filterArray mutableCopy]] mutableCopy];

    }
//    if(filterArray.count<=0 && newText.length==0){
//        filterArray = [productListArray mutableCopy];
//    }
    
//    NSArray *sorted = [[filterArray mutableCopy] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    filterArray = [sorted  mutableCopy];

    [searchResultTableView reloadData];
    return  YES;


    
}



-(NSMutableArray *) groupsWithDuplicatesItemNumRemoved:(NSArray *)  groups {
    NSMutableArray * groupsFiltered = [[NSMutableArray alloc] init];    //This will be the array of groups you need
    NSMutableArray * groupNamesEncountered = [[NSMutableArray alloc] init]; //This is an array of group names seen so far
    
    NSString * name;        //Preallocation of group name
    for (NSDictionary * group in groups) {  //Iterate through all groups
        name =[group objectForKey:@"ItemNum"]; //Get the group name
        if ([groupNamesEncountered indexOfObject: name]==NSNotFound) {  //Check if this group name hasn't been encountered before
            [groupNamesEncountered addObject:name]; //Now you've encountered it, so add it to the list of encountered names
            [groupsFiltered addObject:group];   //And add the group to the list, as this is the first time it's encountered
        }
    }
    return groupsFiltered;
}
-(NSMutableArray *) groupsWithDuplicatesMovie_NameRemoved:(NSArray *)  groups {
    NSMutableArray * groupsFiltered = [[NSMutableArray alloc] init];    //This will be the array of groups you need
    NSMutableArray * groupNamesEncountered = [[NSMutableArray alloc] init]; //This is an array of group names seen so far
    
    NSString * name;        //Preallocation of group name
    for (NSDictionary * group in groups) {  //Iterate through all groups
        name =[group objectForKey:@"Movie_Name"]; //Get the group name
        if ([groupNamesEncountered indexOfObject: name]==NSNotFound) {  //Check if this group name hasn't been encountered before
            [groupNamesEncountered addObject:name]; //Now you've encountered it, so add it to the list of encountered names
            [groupsFiltered addObject:group];   //And add the group to the list, as this is the first time it's encountered
        }
    }
    return groupsFiltered;
}










- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    searchResultCellClass *cell = (searchResultCellClass *)[tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[searchResultCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    

    
    
    
    if (_isMovie) {
//       
//        CGSize constrainedSize = CGSizeMake( cell.resultProductName.frame.size.width  , 9999);
//        
//        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              [UIFont systemFontOfSize:13.0], NSFontAttributeName,
//                                              nil];
//        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[[filterArray objectAtIndex:indexPath.row] valueForKey:@"Movie_Name"] attributes:attributesDictionary];
//        
//        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        
//        if (requiredHeight.size.width >  cell.resultProductName.frame.size.width) {
//            requiredHeight = CGRectMake(0,0,  cell.resultProductName.frame.size.width, requiredHeight.size.height);
//        }
//        CGRect newFrame =  cell.resultProductName.frame;
//        newFrame.size.height = requiredHeight.size.height;
//         cell.resultProductName.frame = newFrame;
        
        cell.resultProductName.text = [[filterArray objectAtIndex:indexPath.row] valueForKey:@"Movie_Name"];

    }
    else{
        
//        CGSize constrainedSize = CGSizeMake( cell.resultProductName.frame.size.width  , 9999);
//        
//        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              [UIFont systemFontOfSize:13.0], NSFontAttributeName,
//                                              nil];
//        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[[filterArray objectAtIndex:indexPath.row] valueForKey:@"Item_Name"] attributes:attributesDictionary];
//        
//        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        
//        if (requiredHeight.size.width >  cell.resultProductName.frame.size.width) {
//            requiredHeight = CGRectMake(0,0,  cell.resultProductName.frame.size.width, requiredHeight.size.height);
//        }
//        CGRect newFrame = cell.resultProductName.frame;
//        newFrame.size.height = requiredHeight.size.height;
//        cell.resultProductName.frame = newFrame;
        
        cell.resultProductName.text = [[filterArray objectAtIndex:indexPath.row] valueForKey:@"Item_Name"];

    }
    
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailListViewController *detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailListViewController"];
    
    NSMutableDictionary  *tempDict= (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(NULL, CFBridgingRetain([[filterArray objectAtIndex:indexPath.row]  mutableCopy]), kCFPropertyListMutableContainersAndLeaves));
    

    detailVc.productDetail = tempDict;
    [self.navigationController pushViewController:detailVc animated:YES];
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

@end
