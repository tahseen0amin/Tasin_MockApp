//
//  AddTeamViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 29/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "AddTeamViewController.h"
#import "TeamProfileCollectionViewController.h"
#import "ApiHelper.h"

@interface AddTeamViewController (){
    BOOL imageTaken, nameChoosen;
}

@property (nonatomic, strong) UIImage *teamImage;
@property (nonatomic, strong) NSString *teamName;


@end

@implementation AddTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.TeamNameTF.hidden = YES;
    [self TakeSelfie:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)nextButtonEnabled {
    if (imageTaken && nameChoosen) {
        return YES;
    } else {
        return NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        nameChoosen = YES;
        self.teamName = textField.text;
        [self segueToAnotherController];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)TakeSelfie:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Label for Error")
                                                                                 message:NSLocalizedString(@"Device has no camera.", @"No Camera Message")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Label")
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil];
        [alertController addAction:doneAction];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:^{
                         }];
    } else {
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }

    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        self.teamImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else if ([info objectForKey:UIImagePickerControllerOriginalImage]){
        self.teamImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    imageTaken = YES;
    self.TeamNameTF.hidden = NO;
    [self.TeamNameTF becomeFirstResponder];
}

- (void)addTeamToServer {
    NSString *data = [NSString stringWithFormat:@"%@/%@",self.teamName, [[NSUserDefaults standardUserDefaults] objectForKey:@"MemberID"] ];
    NSString *url = [NSString stringWithFormat:@"registerTeam/%@",data];
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
                                 [defaults setObject:teamID  forKey:@"TeamID"];
                                 [defaults setObject:self.teamName  forKey:@"TeamName"];
                                 [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"registered"];
                                 [defaults synchronize];
                                 [self.presentingViewController dismissViewControllerAnimated:YES
                                                                                   completion:nil];
                             }
                         }
                         failure:^(NSData *data, NSError *connectionError) {
                             [self showErrorDialog:@"Error" withMessage:@"couldn't connect"];
                         }];
}

- (void)segueToAnotherController {
    if ([self nextButtonEnabled]) {
        
        [self addTeamToServer];
        // segue to different controller
         TeamProfileCollectionViewController *nextCo = [[TeamProfileCollectionViewController alloc] initWithNibName:@"TeamProfileCollectionViewController" bundle:nil];
        UINavigationController *cont = [[UINavigationController alloc] initWithRootViewController:nextCo];
        [self presentViewController:cont animated:YES completion:nil];
        
    }
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

@end
