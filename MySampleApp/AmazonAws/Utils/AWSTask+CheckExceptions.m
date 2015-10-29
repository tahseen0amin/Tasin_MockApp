//
//  AWSTask+CheckExceptions.m
//
//
// Copyright 2015 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//

#import <Foundation/Foundation.h>
#import "AWSTask+CheckExceptions.h"
#import <AWSCore/AWSCore.h>

@implementation AWSTask (CheckExceptions)

- (void)continueWithExceptionCheckingBlock:(void (^)(id result, NSError *error))completionBlock {
    [self continueWithBlock:^id(AWSTask *task) {
        if (task.exception) {
            AWSLogError(@"Exception: %@", task.exception);
            @throw task.exception;
        }
        id result = task.result;
        NSError *error = task.error;

        completionBlock(result, error);
        return nil;
    }];
}

@end
