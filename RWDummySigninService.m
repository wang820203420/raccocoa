//
//  RWDummySigninService.m
//  raccocoa
//
//  Created by zhisu on 15/6/8.
//  Copyright (c) 2015年 wangqian. All rights reserved.
//

#import "RWDummySigninService.h"

@implementation RWDummySigninService

-(void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock
{
    
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds *NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^void {
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];

        completeBlock(success);

        
    });
    
    
    
    
    
    
}




@end
