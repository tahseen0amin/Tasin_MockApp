//
//  AWSTask+CheckExceptions.h
//
//
// Copyright 2015 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//

#import <AWSCore/AWSTask.h>

@interface AWSTask (CheckExceptions)

- (void)continueWithExceptionCheckingBlock:(void (^)(id result, NSError *error))completionBlock;

@end
