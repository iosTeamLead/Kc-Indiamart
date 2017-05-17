//
//  groceryProductData.h
//  Grocery App
//
//  Created by eweba1-pc-80 on 9/26/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface groceryProductData : NSObject



@property(nonatomic,strong) NSMutableArray *groceryProductList;
+ (id)sharedManager;
- (void)groceryProductData;
-(NSMutableArray *)mySavedList;
-(NSString *) getListName;
-(void)fetchSavedListAndProductId;
- (void) hitAgainForSearch;


-(NSMutableArray *)getOrganicProducts;
-(NSMutableArray *)getSpecial;
-(NSMutableArray *)getNewArrials;
-(NSMutableArray *)getProductBydeptId:(NSString *)detptId;
-(NSMutableDictionary *)fetchPerticularProduct:(NSString *)itemNum;


-(NSMutableArray *)checkForsavedOrNotWithProducts:(NSMutableArray *)listOfProducts;
-(void)saveMyProduct :(NSMutableDictionary *)_productDetail quantity :(NSString *)quantity mylistName:(NSString *)mylistName notes:(NSString *)notes;
-(void)updateAllProduct :(NSMutableDictionary *)_productDetail quantity :(NSString *)quantity mylistName:(NSString *)mylistName notes:(NSString *)notes;
-(void)deleteClubsEntity:(NSString *)selectedProductID;
-(void)updateQuantity:(NSString *)selectedProductID withQuantity:(NSString *)quantity;
@end
