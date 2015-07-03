//
//  RWDummySigninService.h
//  raccocoa
//
//  Created by zhisu on 15/6/8.
//  Copyright (c) 2015年 wangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);

@interface RWDummySigninService : NSObject


-(void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end
