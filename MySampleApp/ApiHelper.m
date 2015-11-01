//
//  ApiHelper.m
//  HouseWife
//
//  Created by Taseen Amin on 19/01/2014.
//  Copyright (c) 2014 Taazuh. All rights reserved.
//

#import "ApiHelper.h"
#import "MBProgressHUD.h"

@implementation ApiHelper

+(void) connectionWithUrl:(NSString *)urlString
               PostString:(NSString *)postString
               HttpMethod:(NSString *)httpMethod
                  success:(void(^)(NSData *data, NSURLResponse *response))successBlock_
                  failure:(void(^)(NSData *data, NSError *connectionError))failureBlock_
{
    NSString *ApiUrlString = [NSString stringWithFormat:@"%@%@",Api_Base_Url,urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:ApiUrlString]
                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                    timeoutInterval:10];
    [request setHTTPMethod:httpMethod];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError)
                               {
                                   failureBlock_(data, connectionError);
                                
                                                                      
                                   
                               }
                               else
                               {
                                   successBlock_(data, response);
                                   
                               }
                               
                           }];
    
}

@end
