//
//  HomeMenuViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 31/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "HomeMenuViewController.h"
#import "TeamProfileCollectionViewController.h"
#import "AWSIdentityManager.h"
#import "ColorThemeSettings.h"

@interface HomeMenuViewController ()

@property (nonatomic, strong) id didSignInObserver;
@property (nonatomic, strong) id didSignOutObserver;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HomeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *team = [[UIBarButtonItem alloc]initWithTitle:@"Your Team" style:UIBarButtonItemStylePlain target:self action:@selector(teamButtonClicked)];
    self.navigationItem.leftBarButtonItem = team;
    
    [self updateTheme];
    __weak HomeMenuViewController *weakSelf = self;
    self.didSignInObserver =[[NSNotificationCenter defaultCenter] addObserverForName:AWSIdentityManagerDidSignInNotification
                                                                              object:[AWSIdentityManager sharedInstance]
                                                                               queue:[NSOperationQueue mainQueue]
                                                                          usingBlock:^(NSNotification * _Nonnull note) {
                                                                              [weakSelf setupRightBarButtonItem];
                                                                              // You need to call `- updateTheme` here in case the sign-in happens after `- viewWillAppear:` is called.
                                                                              [weakSelf updateTheme];
                                                                          }];
    self.didSignOutObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AWSIdentityManagerDidSignOutNotification
                                                                                object:[AWSIdentityManager sharedInstance]
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification * _Nonnull note) {
                                                                                [weakSelf setupRightBarButtonItem];
                                                                                [weakSelf updateTheme];
                                                                            }];
    
    [self setupRightBarButtonItem];
    
    // CLLocationManager
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        // set up geo fence
        [self setUpGeoFence];
    }
    [self.locationManager startUpdatingLocation];

    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.didSignInObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.didSignOutObserver];
}

- (void)setupRightBarButtonItem {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:nil];
        self.navigationItem.rightBarButtonItem = loginButton;
    });
    
    if ([[AWSIdentityManager sharedInstance] isLoggedIn]) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Sign-Out", @"Label for the logout button.");
        self.navigationItem.rightBarButtonItem.action = @selector(handleLogout);
    }
}


- (void)teamButtonClicked{
    TeamProfileCollectionViewController *nextCo = [[TeamProfileCollectionViewController alloc] initWithNibName:@"TeamProfileCollectionViewController" bundle:nil];
    [self.navigationController pushViewController:nextCo animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)handleLogout {
    if ([[AWSIdentityManager sharedInstance] isLoggedIn]) {
        [[ColorThemeSettings sharedInstance] wipe];
        [[AWSIdentityManager sharedInstance] logoutWithCompletionHandler:^(id result, NSError *error) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self setupRightBarButtonItem];
            [self presentSignInViewController];
        }];
        //NSLog(@"%@: %@ Logout Successful", LOG_TAG, [signInProvider getDisplayName]);
    } else {
        assert(false);
    }
}

#pragma mark - GEO LOCATION CODE
// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Location ::::::::   %@", [locations lastObject]);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.358381,
                                                               -71.066669);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:200 identifier:@"BeaconHill"];
    CLLocation *lastLocation = [locations lastObject];
    if ([region containsCoordinate:lastLocation.coordinate]) {
        NSLog(@"User IS IN BEACON HILL ::: Location UPdater");
        [self showAlertWithTitle:nil AndMessage:@"Hey! While you are in Beacon Hill, check out some of these bars"];
    } else {
        NSLog(@"User IS NOT IN BEACON HILL :::: Location Updater");
    }
    
    [self.locationManager stopUpdatingLocation];
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            [self setUpGeoFence];
            return;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self showSorryAlert];
            return;
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return;
    }
}

- (void)setUpGeoFence{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.358381,
                                                               -71.066669);
    CLRegion *bridge = [[CLCircularRegion alloc]initWithCenter:center
                                                        radius:200.0
                                                    identifier:@"BeaconHill"];
    
    [self.locationManager startMonitoringForRegion:bridge];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Region ::: %@", region.description);
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location Manager Error :: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"USER Entered IN THE BEACON HILL ");
    [self showAlertWithTitle:nil AndMessage:@"Hey! While you are in Beacon Hill, check out some of these bars"];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"USER LEFT THE BEACON HILL ");
}

- (void)showSorryAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Permission Denied" message:@"Sorry we won't be able to let you know correctly as you have disabled the location for this app. You can change it back in Settings" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil];
    [alertController addAction:done];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title AndMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil];
    [alertController addAction:done];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -

- (void)updateTheme {
    ColorThemeSettings *settings = [ColorThemeSettings sharedInstance];
    [settings loadSettings:^(ColorThemeSettings *themeSettings, NSError *error) {
        if (error) {
            NSLog(@"Failed to load the color theme settings. %@", error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIColor *titleTextColor = UIColorFromARGB(themeSettings.theme.titleTextColor);
            self.navigationController.navigationBar.barTintColor = UIColorFromARGB(themeSettings.theme.titleBarColor)
            self.view.backgroundColor = UIColorFromARGB(themeSettings.theme.backgroundColor);
            self.navigationController.navigationBar.tintColor = titleTextColor;
            [self.navigationController.navigationBar setTitleTextAttributes: @{ NSForegroundColorAttributeName : titleTextColor }];
        });
    }];
}
- (void)presentSignInViewController {
    if (![AWSIdentityManager sharedInstance].isLoggedIn) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SignIn"];
        [self presentViewController:viewController
                           animated:YES
                         completion:nil];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
