//
//  moviesTypeController.m
//  Grocery App
//
//  Created by eweba1-pc-80 on 9/30/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "moviesTypeController.h"
#import "searchResultView.h"
#import "ArivalsViewController.h"
#import "Server.h"
static BOOL notLoaded;
static  NSMutableArray *AllMovies;

@interface moviesTypeController ()
{
    NSMutableDictionary *moviesDict;
//    NSMutableArray *AllMovies;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation moviesTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [_searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([searchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:129.0/255.0 green:45.0/255.0 blue:33.0/255.0 alpha:0.5];
        [searchField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search Movies" attributes:@{NSForegroundColorAttributeName: color}]];
    }

    
    
    if (!_isFromLeft) {
        backButton.selected=YES;
    }
    else{
        backButton.selected=NO;
        
    }
    
        [self getMovies];

   
}


-(void)getMovies{
   
    
    if (!notLoaded) {
   
    [[Server sharedManager]showHUDInView:self.view hudMessage:@"Loading"];
    
//    http://webservices.com.kcimart.com/kcindia_app/webservices/getMovies
      [[Server sharedManager] FetchingData:Base_URL@"getMovies" WithParameter:nil Success:^(NSMutableDictionary *Dic) {
          NSLog(@"%@ ",Dic);
          if ([[Dic valueForKey:@"code"] isEqualToString:@"200"]) {
              [UtilityText showAlertWithAlert:self Alert:@"Alert" message:[Dic valueForKey:@"message"] cancelTitle:@"Ok"];
          }
          else{
              NSLog(@"%@",[[Dic valueForKey:@"data"] valueForKey:@"Language"]);
              AllMovies =[[NSMutableArray alloc] init];
               AllMovies=[[Dic valueForKey:@"data"] mutableCopy];
              
              NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[[AllMovies valueForKey:@"Language"] mutableCopy]];
              NSArray *languageArray = [orderedSet array];
              
//              NSMutableArray *languageArray=[[[Dic valueForKey:@"data"] valueForKey:@"Language"] mutableCopy];
              notLoaded = YES;
              
              moviesDict=[[NSMutableDictionary alloc] init];
              for (int i=0;i< [languageArray count]; i++)
              {
                  NSMutableArray *langData= [[NSMutableArray alloc] init];
                  for (int j=0; j<[AllMovies count]; j++) {
                      if ([[[AllMovies objectAtIndex:j]valueForKey:@"Language"] isEqualToString:[languageArray objectAtIndex:i]]) {
                          [langData addObject:[[AllMovies objectAtIndex:j]mutableCopy]];
                      }
                  }
                  [moviesDict setObject:langData forKey:[languageArray objectAtIndex:i]];
                  
              }
              NSLog(@"%@",moviesDict);

              
          }
          
          NSLog(@"m %lu",[[moviesDict valueForKey:@"TELUGU"] count]);
          
          [[Server sharedManager]hideHUD];

      } Error:^(NSError *error) {
          NSLog(@"%@",[error localizedDescription]);

      } InternetConnected:^(NSError *error) {
          [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"Internet Not Connected" cancelTitle:@"Ok"];

      }];
    }else{
        
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[[AllMovies valueForKey:@"Language"] mutableCopy]];
        NSArray *languageArray = [orderedSet array];
        
        //              NSMutableArray *languageArray=[[[Dic valueForKey:@"data"] valueForKey:@"Language"] mutableCopy];
        
        
        moviesDict=[[NSMutableDictionary alloc] init];
        for (int i=0;i< [languageArray count]; i++)
        {
            NSMutableArray *langData= [[NSMutableArray alloc] init];
            for (int j=0; j<[AllMovies count]; j++) {
                if ([[[AllMovies objectAtIndex:j]valueForKey:@"Language"] isEqualToString:[languageArray objectAtIndex:i]]) {
                    [langData addObject:[[AllMovies objectAtIndex:j]mutableCopy]];
                }
            }
            [moviesDict setObject:langData forKey:[languageArray objectAtIndex:i]];
            
        }
        NSLog(@"%@",moviesDict);
        
        
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftBtnPressed:(id)sender {
    // MMDrawer *drawer = (MMDrawer *)[[self parentViewController] parentViewController];
    // [drawer toggleDrawerSide: MMDrawerSideLeft animated:YES completion:^(BOOL finished) { }];
    if (!_isFromLeft) {
        [appDelegate.window.rootViewController removeFromParentViewController];
        [appDelegate homeRootTabControler];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    resultScreen.isMovie =YES;
    resultScreen.moviesArray = [AllMovies  mutableCopy];
    [self.navigationController pushViewController:resultScreen animated:YES];
    return  NO;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    searchResultView *resultScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"searchResultView"];
    resultScreen.searchText = searchBar.text;
    resultScreen.isMovie =YES;
    resultScreen.moviesArray = [AllMovies  mutableCopy];    
    [self.navigationController pushViewController:resultScreen animated:YES];
    
    
}
- (IBAction)buttonAction:(id)sender {
    NSLog(@"sender %ld",(long)[sender tag]);
   
    ArivalsViewController *newArivalVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArivalsViewController"];
    newArivalVc.isFromLeft=YES;
  
    if ([sender tag] == 101) {
        NSLog(@"sender %ld",(long)[sender tag]);
        if ([moviesDict valueForKey:@"TELUGU"] == nil) {
            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"There is no TELGU Movie right now" cancelTitle:@"ok"];
        }
        else{
            newArivalVc.moviesData = [[moviesDict valueForKey:@"TELUGU"] mutableCopy];
            [self.navigationController pushViewController:newArivalVc animated:YES];
        }
        
    }
    else  if ([sender tag] == 102) {
        NSLog(@"sender %ld",(long)[sender tag]);
        if ([moviesDict valueForKey:@"HINDI"] == nil) {
            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"There is no HINDI Movie right now" cancelTitle:@"ok"];
        }
        else{
            newArivalVc.moviesData = [[moviesDict valueForKey:@"HINDI"] mutableCopy];
            [self.navigationController pushViewController:newArivalVc animated:YES];
        }

    }
    else  if ([sender tag] == 103) {
        NSLog(@"sender %ld",(long)[sender tag]);
        if ([moviesDict valueForKey:@"ENGLISH"] == nil) {
            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"There is no other Movie right now" cancelTitle:@"ok"];
        }
        else{
            newArivalVc.moviesData = [[moviesDict valueForKey:@"ENGLISH"] mutableCopy];
            [self.navigationController pushViewController:newArivalVc animated:YES];
        }
    }
    else if ([sender tag] == 104)
    {
        NSLog(@"sender %ld",(long)[sender tag]);
        if ([moviesDict valueForKey:@"TAMIL"] == nil) {
            [UtilityText showAlertWithAlert:self Alert:@"Alert" message:@"There is no TAMIL Movie right now" cancelTitle:@"ok"];
        }
        else{
            newArivalVc.moviesData = [[moviesDict valueForKey:@"TAMIL"] mutableCopy];
            [self.navigationController pushViewController:newArivalVc animated:YES];
        }
    }
   
//      [self.navigationController pushViewController:newArivalVc animated:YES];
    
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
