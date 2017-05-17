//
//  groceryProductData.m
//  Grocery App
//
//  Created by eweba1-pc-80 on 9/26/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "groceryProductData.h"
#import "Server.h"
#import "HomePageViewController.h"

@implementation groceryProductData
{
    NSMutableArray *devices,*mySavedList;
//    NSManagedObject *device;

    
}

+ (id)sharedManager {
    static groceryProductData *getCalendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getCalendar = [[self alloc] init];
    });
    return getCalendar;
}

- (id)init {
    if (self = [super init]) {
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getContact:) name:@"updateCalendars" object:nil];
        
        NSLog(@"init called");
        
    }
    return self;
}
- (void) groceryProductData{
    
//    _groceryProductList = [[NSMutableArray alloc] initWithObjects:@"Apple",@"banana",@"Mango",@"GUAVA",@"LITCHI",@"PIPINEAPPKLe",@"red",@"green",@"blue",@"yellow",@"grey",@"voilet", nil];
    
//    http://webservices.com.kcimart.com/kcindia_app/webservices/Products/getProductData
    
    if (_groceryProductList.count<=0) {
//    [[Server sharedManager] showHUDInView:str.view hudMessage:@"Fetching Data"];
    
    NSString *url=@"http://kcimartc.wwwls19.a2hosted.com/kcindia_app/webservices/Products/getProductData";
    
    
        [[Server sharedManager]FetchingData:url WithParameter:nil Success:^(NSMutableDictionary *Dic) {
//            NSLog(@"%@",Dic);
            _groceryProductList = [[Dic valueForKey:@"data"] mutableCopy];
            
            NSLog(@"Server Products Count %lu",[[Dic valueForKey:@"data"] count]);
            
            
            [self fetchSavedListAndProductId];
            
//            [[Server sharedManager] hideHUD];
//
        } Error:^(NSError *error) {
            NSLog(@"%@", error);
            
            if ([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."]) {
                UIAlertView *Alert  = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Internet is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
                [[Server sharedManager] hideHUD];
            }
           

            
        } InternetConnected:^(NSError *error) {
            NSLog(@"Error %@",error.localizedDescription);
            UIAlertView *Alert  = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Internet is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            [[Server sharedManager] hideHUD];

        }];
    
    }
    else{
        [[Server sharedManager] hideHUD];

    }
  
}

- (void) hitAgainForSearch{
    
    //    _groceryProductList = [[NSMutableArray alloc] initWithObjects:@"Apple",@"banana",@"Mango",@"GUAVA",@"LITCHI",@"PIPINEAPPKLe",@"red",@"green",@"blue",@"yellow",@"grey",@"voilet", nil];
    
    //    http://webservices.com.kcimart.com/kcindia_app/webservices/Products/getProductData
    
//    if (_groceryProductList.count<=0) {
        //    [[Server sharedManager] showHUDInView:str.view hudMessage:@"Fetching Data"];
        
        NSString *url=@"http://kcimartc.wwwls19.a2hosted.com/kcindia_app/webservices/Products/getProductData";
        
        
        [[Server sharedManager]FetchingData:url WithParameter:nil Success:^(NSMutableDictionary *Dic) {
            //            NSLog(@"%@",Dic);
            _groceryProductList = [[Dic valueForKey:@"data"] mutableCopy];
            
            NSLog(@"Server Products Count %lu",[[Dic valueForKey:@"data"] count]);
            
            
            [self fetchSavedListAndProductId];
            
            //            [[Server sharedManager] hideHUD];
            //
        } Error:^(NSError *error) {
            NSLog(@"%@", error);
            
            if ([[error localizedDescription] isEqualToString:@"The Internet connection appears to be offline."]) {
                UIAlertView *Alert  = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Internet is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [Alert show];
                [[Server sharedManager] hideHUD];
            }
            
            
            
        } InternetConnected:^(NSError *error) {
            NSLog(@"Error %@",error.localizedDescription);
            UIAlertView *Alert  = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Internet is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            [[Server sharedManager] hideHUD];
            
        }];
        
//    }
//    else{
//        [[Server sharedManager] hideHUD];
//        
//    }
    
}





-(NSMutableArray *) groupsWithDuplicatesRemoved:(NSArray *)  groups {
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

-(NSMutableArray *)getProductBydeptId:(NSString *)detptId{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[_groceryProductList count];i++)
        if ([[[_groceryProductList objectAtIndex:i] valueForKey:@"DepId"] isEqualToString:detptId]) {
            [dataArray addObject:[_groceryProductList objectAtIndex:i]];
        }
    dataArray = [self groupsWithDuplicatesRemoved:[dataArray mutableCopy]];
    
    return  dataArray;
}




-(NSMutableArray *)getNewArrials{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[_groceryProductList count];i++)
        if (![[[_groceryProductList objectAtIndex:i] valueForKey:@"New_Arrival"] isEqualToString:@"0"]) {
            [dataArray addObject:[_groceryProductList objectAtIndex:i]];
        }
    dataArray = [self groupsWithDuplicatesRemoved:[dataArray mutableCopy]];

    return  dataArray;
}



-(NSMutableArray *)getOrganicProducts{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[_groceryProductList count];i++)
        if ([[[_groceryProductList objectAtIndex:i] valueForKey:@"Theme"] isEqualToString:@"Organic"]) {
            [dataArray addObject:[_groceryProductList objectAtIndex:i]];
        }

    
    dataArray = [self groupsWithDuplicatesRemoved:[dataArray mutableCopy]];
    
    return dataArray;
}

-(NSMutableArray *)getSpecial{
    NSMutableArray *dataArray=[[NSMutableArray alloc] init];
    for(int i=0;i<[_groceryProductList count];i++)
        if (![[[_groceryProductList objectAtIndex:i] valueForKey:@"Theme"] isEqualToString:@"Organic"] && ![[[_groceryProductList objectAtIndex:i] valueForKey:@"Theme"] isEqualToString:@"None"]) {
            [dataArray addObject:[_groceryProductList objectAtIndex:i]];
        }
    dataArray = [self groupsWithDuplicatesRemoved:[dataArray mutableCopy]];

    return dataArray;
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSString *) getListName{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProductList"];
    NSLog(@"%@",[[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy] valueForKey:@"listName"]);
    NSString *listNameString = [[[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy] valueForKey:@"listName"] lastObject];
    return listNameString;
}

    
    

-(void)fetchSavedListAndProductId{
    
    
    mySavedList = [[NSMutableArray alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProductList"];
    devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    NSLog(@"%@ %lu",[devices valueForKey:@"productDetails"],(unsigned long)[[devices valueForKey:@"productDetails"] count]);
    
    for (int i=0; i<[[devices valueForKey:@"productDetails"] count]; i++) {
        NSManagedObject *mydevice = [devices objectAtIndex:i];
        NSLog(@"%@ %@",[mydevice valueForKey:@"productDetails"],[mydevice valueForKey:@"listName"]);

        NSData *newdata = [NSData dataWithData:[mydevice valueForKey:@"productDetails"]];
        NSMutableDictionary  *arr =[[NSMutableDictionary  alloc ] init ];
        arr = [[NSKeyedUnarchiver unarchiveObjectWithData:newdata] mutableCopy];
        
        if ([mydevice valueForKey:@"productDetails"]!= [NSNull null] &&  [mydevice valueForKey:@"productDetails"]!= nil &&  [arr count]!=0) {
            NSMutableDictionary *data= [[NSMutableDictionary alloc] init];
            
        
           
            data = [arr mutableCopy];
            if([mydevice valueForKey:@"quantity"]==nil)
            {
                [data setObject:@"0" forKey:@"myQuantity"];
 
            }
            else{
                [data setObject:[mydevice valueForKey:@"quantity"] forKey:@"myQuantity"];
  
            }
            [data setObject:[mydevice valueForKey:@"productId"] forKey:@"productId"];

            [data setObject:[self getListName] forKey:@"listName"];
            [data setObject:[mydevice valueForKey:notesText] forKey:notesText];

            [mySavedList addObject:data];
        }
        else{
            NSLog(@"no product");
            
        }
        
    }
    
    
    if (mySavedList.count<=0) {
        kSetBoolValueForKey(IsListCreated, NO);
        
    }
    else{
        kSetBoolValueForKey(IsListCreated, YES);
        
    }
    
    
    
    [[Server sharedManager] hideHUD];

}

-(NSMutableDictionary *)fetchPerticularProduct:(NSString *)itemNum{
    NSMutableArray *dataArray = [[NSMutableArray alloc ] init];
    
    for (int i=0; i<_groceryProductList.count; i++) {
        if ([[[_groceryProductList  objectAtIndex:i] valueForKey:@"ItemNum"] isEqualToString:itemNum] || [[[_groceryProductList  objectAtIndex:i] valueForKey:@"SKU"] isEqualToString:itemNum]) {
            [dataArray addObject:[_groceryProductList  objectAtIndex:i]];
        }
    }
    dataArray = [self checkForsavedOrNotWithProducts:[dataArray  mutableCopy]];
    
    if (dataArray.count>0) {
        return  [dataArray objectAtIndex:0];

    }
    else{
        return  nil;

    }
}


-(NSMutableArray *)checkForsavedOrNotWithProducts:(NSMutableArray *)listOfProducts{
    if (mySavedList.count <=0) {
        return listOfProducts;
    }
    else{
        NSMutableArray *dataArray= [[NSMutableArray alloc] init];
        for (int i=0; i<listOfProducts.count; i++) {
           
            
            if ([[mySavedList valueForKey:@"ItemNum"] containsObject:[[listOfProducts objectAtIndex:i] valueForKey:@"ItemNum"]]) {
                       for (int j=0; j<mySavedList.count; j++) {
                
                           if ([[[listOfProducts  objectAtIndex:i] valueForKey:@"ItemNum"] isEqualToString:[[mySavedList objectAtIndex:j] valueForKey:@"ItemNum"]]) {
                               [dataArray addObject:[mySavedList objectAtIndex:j]];
                            }
               
            }
        }
        
            else{
                [dataArray addObject:[listOfProducts objectAtIndex:i]];

            }
        }
        return dataArray;
 
    }
    
    
}
-(void)saveMyProduct :(NSMutableDictionary *)_productDetail quantity :(NSString *)quantity mylistName:(NSString *)mylistName notes:(NSString *)notes{
    {
        
        NSManagedObjectContext *context = [self managedObjectContext];

            // Create a new device
            
            
            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"ProductList" inManagedObjectContext:context];
            //        [newDevice setValue:[[groceryProductData sharedManager] getListName] forKey:@"listName"];
            
            if (_productDetail == nil) {
                NSMutableDictionary *data= [[NSMutableDictionary alloc] init];
                NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:[data mutableCopy]];
                [newDevice setValue:arrayData forKey:@"productDetails"];
                [newDevice setValue:@"" forKey:@"productId"];

            }
            else{
                NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:[_productDetail mutableCopy]];
                [newDevice setValue:arrayData forKey:@"productDetails"];
                [newDevice setValue:[_productDetail valueForKey:@"ItemNum"] forKey:@"productId"];

                
            }
            if (quantity == nil) {
                [newDevice setValue:@"0" forKey:@"quantity"];

            }
            else{
                [newDevice setValue:quantity forKey:@"quantity"];

            }
          
                [newDevice setValue:mylistName forKey:@"listName"];
                kSetBoolValueForKey(IsListCreated, YES);

            if (notes == nil) {
                [newDevice setValue:@"" forKey:notesText];

            }
            else{
                [newDevice setValue:notes forKey:notesText];
                kSetValueForKey(notesText, notes);
            }
        
            NSLog(@"%@",newDevice);
//        }
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else{
            [[groceryProductData sharedManager] fetchSavedListAndProductId];
        }
    }
    
}
-(void)updateAllProduct :(NSMutableDictionary *)_productDetail quantity :(NSString *)quantity mylistName:(NSString *)mylistName notes:(NSString *)notes
    {
        NSManagedObjectContext *context = [self managedObjectContext];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProductList"];
        NSMutableArray *mysaveddevices = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];

        if (_productDetail==nil && quantity == nil && mylistName == nil && notes !=nil) {
              for (int i=0; i<mysaveddevices.count; i++) {
            NSManagedObject *selectedDevice = [mysaveddevices objectAtIndex:i];
            NSLog(@"%@",selectedDevice);
            [selectedDevice setValue:notes forKey:notesText];
                  kSetValueForKey(notesText, notes);

        }
        }
        else{
            for (int i=0; i<mysaveddevices.count; i++) {
                NSManagedObject *selectedDevice = [mysaveddevices objectAtIndex:i];
                [selectedDevice setValue:quantity forKey:@"myQuantity"];
                
            }

        }
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else{
            [self fetchSavedListAndProductId];
        }
        
    
}

-(void)deleteClubsEntity:(NSString *)selectedProductID // pass the value 120
{
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    
    [fetch setEntity:[NSEntityDescription entityForName:@"ProductList" inManagedObjectContext: context]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"(productId contains[cd] %@)",selectedProductID]];
       NSArray * records = [context executeFetchRequest:fetch error:&error];
       for (NSManagedObject * record in records) {
           [context deleteObject:record];
       }
       [context save:&error];
    
    [self fetchSavedListAndProductId];





 }

-(void)updateQuantity:(NSString *)selectedProductID withQuantity:(NSString *)quantity // pass the value 120
{
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    
    [fetch setEntity:[NSEntityDescription entityForName:@"ProductList" inManagedObjectContext: context]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"(productId contains[cd] %@)",selectedProductID]];
    NSArray * records = [context executeFetchRequest:fetch error:&error];
    
    
    NSManagedObject* favoritsGrabbed = [records objectAtIndex:0];
    [favoritsGrabbed setValue:quantity forKey:@"quantity"];

    
//    NSManagedObject *selectedDevice = [mysaveddevices objectAtIndex:i];
//    NSLog(@"%@",selectedDevice);
//    [selectedDevice setValue:notes forKey:notesText];
//
//    for (NSManagedObject * record in records) {
//        [context updatedObjects:record];
//    }
    [context save:&error];
    
    [self fetchSavedListAndProductId];
    
    
    
    
    
}



-(NSMutableArray *)mySavedList{
    return mySavedList;
}



@end
