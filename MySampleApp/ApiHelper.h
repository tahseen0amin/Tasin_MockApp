//
//  ApiHelper.h
//  HouseWife
//
//  Created by Taseen Amin on 19/01/2014.
//  Copyright (c) 2014 Taazuh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Api_Base_Url @"http://taazuh.co.uk/Mdafs/index.php/"

@interface ApiHelper : NSObject

+(void) connectionWithUrl:(NSString *)urlString
               PostString:(NSString *)postString
               HttpMethod:(NSString *)httpMethod
                  success:(void(^)(NSData *data, NSURLResponse *response))successBlock_
                  failure:(void(^)(NSData *data, NSError *connectionError))failureBlock_;

@end
