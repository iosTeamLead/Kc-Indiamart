//
//  Server.h
//  CustomKeyboard
//
//  Created by VibrantAppz on 21/11/14.
//  Copyright (c) 2014 Jason Pilarinos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GCNetworkConnected.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "UtilityText.h"
#import "DetailListViewController.h"
#import "UIImageView+WebCache.h"

#import "groceryProductData.h"


//Managing User Defaults

#define KSYNCH [[NSUserDefaults standardUserDefaults] synchronize]

#define kGetBoolValueForKey(key)    [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define kSetBoolValueForKey(key, bool) [[NSUserDefaults standardUserDefaults]   setBool:bool \
forKey:key]; \
KSYNCH
#define kGetValueForKey(key)  [[NSUserDefaults standardUserDefaults] valueForKey:key]
#define kRemoveObjectForKey(key)   [[NSUserDefaults standardUserDefaults]removeObjectForKey:key] 
#define kSetValueForKey(key, value) [[NSUserDefaults standardUserDefaults]  setValue:value \
forKey:key]; \
KSYNCH
#define isSwitchOn @"isSwitchOn"
#define KMGUserId @"userid"
#define USER_DATA @"USER_DATA"
#define Is_Login @"Is_Login"
#define listName @"listName"
#define notesText @"notesText"
#define IsListCreated @"IsListCreated"


#define Base_URL @"http://kcimartc.wwwls19.a2hosted.com/kcindia_app/webservices/"
#define Image_URL @"http://kcimartc.wwwls19.a2hosted.com/kcindia_app/"

//#define Base_URL @"http://webservices.com.kcimart.com/kcindia_app/webservices/"
//#define Image_URL @"http://webservices.com.kcimart.com/kcindia_app/"

typedef void (^AuthenticationBlocks)(NSError *error);
typedef void (^DictionaryBlocks)(NSMutableDictionary *Dic);
typedef void (^ResponseBlocks)(NSString *Dic);

@interface Server : NSObject<MBProgressHUDDelegate>

@property (nonatomic, copy) ResponseBlocks didSuccessBlock;
@property (nonatomic, copy) AuthenticationBlocks didfailBlock;
@property (strong, nonatomic) MBProgressHUD *HUD;

+ (Server *)sharedManager;

-(void)PostDataWithURL:(NSString *)url WithParameter:(NSDictionary *) parameters Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors ;

-(void)PostWithImageActionWithWRL:(NSString *)url WithParameter:(NSDictionary *) parameters image:(NSData *)imageData ImageKeyName:(NSString *)key Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors;

-(void) FetchingData: (NSString *) url  WithParameter:(NSDictionary *)parameters Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors InternetConnected: (AuthenticationBlocks) network;
-(void)hideHUD;
-(void)showHUDInView:(UIView*)view hudMessage:(NSString *)hudMessage;

-(void)showToastInView:(UIViewController *)viewController toastMessage:(NSString *)toastMessage withDelay:(int)delay;



-(BOOL) validateEmail:(NSString *) email;

- (NSString *)URLDecodeWithString:(NSString *)str;


@end
