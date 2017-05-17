//
//  Server.m
//  CustomKeyboard
//
//  Created by VibrantAppz on 21/11/14.
//  Copyright (c) 2014 Jason Pilarinos. All rights reserved.
//

#import "Server.h"
#import "AFNetworking.h"
#import "GCNetworkConnected.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"


static Server *_sharedManager = nil;

@implementation Server

+ (Server *)sharedManager
{
    @synchronized([Server class])
    {
        if (!_sharedManager)
            _sharedManager = [[self alloc] init];
        
        return _sharedManager;
    }
    
    return nil;
}
+(id)alloc
{
    @synchronized([Server class])
    {
        NSAssert(_sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedManager = [[super alloc] init];
        return _sharedManager;
    }
    
    return nil;
}

-(id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark -
#pragma mark -HUD Method
-(void)hideHUD{
    [self.HUD hide:YES];
}
-(void)showHUDInView:(UIView *)view hudMessage:(NSString *)hudMessage{
        if(view == nil)
        {
            self.HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window.rootViewController.view animated:YES];
            self.HUD.delegate=self;
            self.HUD.labelText = hudMessage;

        }
    
        else{
            self.HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
            self.HUD.delegate=self;
            self.HUD.labelText = hudMessage;
        }
    
   
}
-(void)showToastInView:(UIViewController *)viewController toastMessage:(NSString *)toastMessage withDelay:(int)delay{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = toastMessage;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];

}




#pragma mark -
#pragma mark -Request Method

-(void)PostDataWithURL:(NSString *)url WithParameter:(NSDictionary *)parameters Success:(DictionaryBlocks)completion Error:(AuthenticationBlocks)errors {
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
//            NSLog(@"Success: %@", operation.responseString);
            NSError* error;
      
            NSMutableDictionary* json = [NSJSONSerialization
                                         JSONObjectWithData:operation.responseData
                                         
                                         options:kNilOptions
                                         error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //Callback
                completion(json);
                
                });
  
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@ ....%@", operation.responseString, error,operation.responseObject);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                errors(error);
            });
        }];
    });
}

-(void)PostWithImageActionWithWRL:(NSString *)url WithParameter:(NSDictionary *) parameters image:(NSData *)imageData ImageKeyName:(NSString *)key Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors {
    
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        NSString *PicName=[NSString stringWithFormat:@"%d.jpg",arc4random()%1000000000];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
        
        [manager.requestSerializer setValue:[parameters valueForKey:@"username"] forHTTPHeaderField:@"username"];
        [manager.requestSerializer setValue:[parameters valueForKey:@"password"] forHTTPHeaderField:@"password"];
        
        NSMutableDictionary *dic =[NSMutableDictionary new];
        [dic setValue:[parameters valueForKey:@"request"] forKey:@"request"];
        
        
        AFHTTPRequestOperation *op = [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:PicName mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            NSError* error;
            NSMutableDictionary* json = [NSJSONSerialization
                                         JSONObjectWithData:operation.responseData
                                         
                                         options:kNilOptions
                                         error:&error];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                completion(json);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@ ....%@", operation.responseString, error,operation.responseObject);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                
                errors(error);
            });
        }];
        [op start];
        
    });
}


-(void) FetchingData: (NSString *) url  WithParameter:(NSDictionary *)parameters Success: (DictionaryBlocks) completion Error: (AuthenticationBlocks) errors InternetConnected: (AuthenticationBlocks) network{
    NSLog(@"%@",url);
    
    
    //  }-fno-objc-arc
    
    dispatch_queue_t ParseQueue = dispatch_queue_create("ParseQueue", NULL);
    dispatch_async(ParseQueue, ^{
        
        NSString *newString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *Url = [NSURL URLWithString:newString];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        
        //        NSMutableDictionary *dicStr =[NSMutableDictionary new];
        //        [dicStr setValue:kGetValueForKey(@"username") forKey:@"username"];
        //        [dicStr setValue:kGetValueForKey(@"password") forKey:@"password"];
        
        
        
        manager.responseSerializer = serializer;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        [manager.requestSerializer setValue:[parameters valueForKey:@"username"] forHTTPHeaderField:@"username"];
        [manager.requestSerializer setValue:[parameters valueForKey:@"password"] forHTTPHeaderField:@"password"];
        
        NSString *path = [NSString stringWithFormat:@"%@",Url];
        
        [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            NSError* error;
            //  NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSMutableDictionary* json = [NSJSONSerialization
                                         JSONObjectWithData:operation.responseData
                                         
                                         options:kNilOptions
                                         error:&error];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                completion(json);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@ ....%@", operation.responseString, error,operation.responseObject);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Callback
                errors(error);
            });
        }];
        
    });
}



#pragma mark -
#pragma mark - Custom Method

-(BOOL) validateEmail:(NSString *) email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

- (NSString *)URLDecodeWithString:(NSString *)str
{
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


@end
