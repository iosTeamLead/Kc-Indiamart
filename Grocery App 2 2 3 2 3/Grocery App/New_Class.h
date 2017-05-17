//
//  New_Class.h
//  Bybata
//
//  Created by eweba1-pc-69 on 8/26/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface New_Class : NSObject

@property (nonatomic,strong) NSString *UserID;
@property (nonatomic,strong) NSString *UserName;
@property (nonatomic,strong) NSString *UserProfilePic;

@property (nonatomic,strong) NSString *Chat_UserID;
@property (nonatomic,strong) NSString *Chat_UserMessage;
@property (nonatomic,strong) NSString *Chat_UserName;
@property (nonatomic,strong) NSString *Chat_UserStatus;
@property (nonatomic,strong) NSString *Chat_UserProfilePic;



- (New_Class *)initWithDictionary:(NSDictionary *)dataDic;
@end
