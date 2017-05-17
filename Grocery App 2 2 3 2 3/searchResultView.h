//
//  searchResultView.h
//  Grocery App
//
//  Created by eweba1-pc-80 on 9/24/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchResultView : UIViewController
{
    __weak IBOutlet UITableView *searchResultTableView;
    
}
@property (nonatomic,strong)NSString *searchText;
@property (nonatomic,strong) NSMutableArray *moviesArray;
@property (nonatomic)bool isMovie;
@end
