//
//  ColorThemeSettings.h
//
//
// Copyright 2015 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//

#define UIColorFromARGB(argbValue) [UIColor colorWithRed:((float)((argbValue & 0x00FF0000) >> 16))/ 255.0 \
                                                   green:((float)((argbValue & 0x0000FF00) >> 8 ))/ 255.0 \
                                                    blue:((float)((argbValue & 0x000000FF) >> 0 ))/ 255.0 \
                                                   alpha:((float)((argbValue & 0xFF000000) >> 24))/ 255.0];

@interface Theme : NSObject

@property (nonatomic, readonly) int titleTextColor;
@property (nonatomic, readonly) int titleBarColor;
@property (nonatomic, readonly) int backgroundColor;

- (instancetype)initWithTitleTextColor:(int)titleTextColor
                     withTitleBarColor:(int)titleBarColor
                   withBackgroundColor:(int)backgroundColor;

@end

@interface ColorThemeSettings : NSObject

@property (strong, nonatomic) Theme *theme;

+ (instancetype)sharedInstance;

- (void)loadSettings:(void (^)(ColorThemeSettings *, NSError *))completionBlock;

- (void)saveSettings:(void (^)(ColorThemeSettings *, NSError *))completionBlock;

- (void)wipe;

@end