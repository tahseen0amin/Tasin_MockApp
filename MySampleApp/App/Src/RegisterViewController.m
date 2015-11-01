//
//  RegisterViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 01/11/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "RegisterViewController.h"
#import "ApiHelper.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpClicked:(id)sender {
    if ([self checkForEmpty:self.fullNameTF] && [self checkForEmpty:self.emailTF] && [self checkForEmpty:self.passwordTF]) {
        NSString *data = [NSString stringWithFormat:@"%@/%@/%@",self.fullNameTF.text,self.emailTF.text,self.passwordTF.text];
        NSString *url = [NSString stringWithFormat:@"register/%@",data];
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [ApiHelper connectionWithUrl:url PostString:nil
                          HttpMethod:@"GET"
                             success:^(NSData *data, NSURLResponse *response) {
                                 NSError *error;
                                 NSDictionary *APIResponseDictionary = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error]:nil;
                                 if(error){
                                     [self showErrorDialog:nil withMessage:@"wrong response"];
                                 } else {
                                     
                                     // check for success key
                                     NSLog(@"%@", APIResponseDictionary);
                                     NSString *teamID = [APIResponseDictionary objectForKey:@"lastID"];
                                     
                                     
                                     //
                                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                     [defaults setObject:teamID  forKey:@"MemberID"];
                                     [defaults setObject:self.fullNameTF.text  forKey:@"MemberName"];
                                     [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"registered"];
                                     [defaults synchronize];
                                     [self.presentingViewController dismissViewControllerAnimated:YES
                                                                                   completion:nil];
                                 }
                             }
                             failure:^(NSData *data, NSError *connectionError) {
                                 [self showErrorDialog:@"Error" withMessage:@"couldn't connect"];
                             }];
    } else {
        [self showErrorDialog:@"Incomplete Form" withMessage:@"Please fill out entire form"];
    }
}

- (IBAction)cancelClicked:(id)sender {
   
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)checkForEmpty:(UITextField *)tf {
    if (tf.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)showErrorDialog:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, @"Sign-in error for sign-in failure.")
                                                                             message:NSLocalizedString(message, @"Sign-in message structure for sign-in failure.")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Label to cancel sign-in failure.")
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
    [alertController addAction:doneAction];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
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
