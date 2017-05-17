//
//  New_Class.m
//  Bybata
//
//  Created by eweba1-pc-69 on 8/26/16.
//  Copyright © 2016 A1 professionals. All rights reserved.
//

#import "New_Class.h"

@implementation New_Class


- (instancetype)initWithDictionary:(NSDictionary *)dataDic{
    self=[super init];
    if (self) {
        
        self.UserProfilePic=[dataDic objectForKey:@"profile_image"];
        self.UserName=[dataDic objectForKey:@"name"];
        self.UserID=[dataDic objectForKey:@"opp_id"];
        
        self.Chat_UserProfilePic=[dataDic objectForKey:@"profile_image"];
        self.Chat_UserName=[dataDic objectForKey:@"name"];
        self.Chat_UserID=[dataDic objectForKey:@"opp_id"];
        self.Chat_UserMessage=[dataDic objectForKey:@"message"];
        self.Chat_UserStatus=[dataDic objectForKey:@"status"];
        
    }
    return self;
}
@end
