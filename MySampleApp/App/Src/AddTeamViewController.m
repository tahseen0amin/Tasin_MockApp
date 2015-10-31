//
//  AddTeamViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 29/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "AddTeamViewController.h"
#import "TeamProfileCollectionViewController.h"

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
    TeamProfileCollectionViewController *nextCo = [[TeamProfileCollectionViewController alloc] initWithNibName:@"TeamProfileCollectionViewController" bundle:nil];
    UINavigationController *cont = [[UINavigationController alloc] initWithRootViewController:nextCo];
    [self presentViewController:cont animated:YES completion:nil];
    
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
                             imageTaken = YES;
                             self.TeamNameTF.hidden = NO;
                             [self.TeamNameTF becomeFirstResponder];
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

- (void)segueToAnotherController {
    if ([self nextButtonEnabled]) {
        // segue to different controller
         TeamProfileCollectionViewController *nextCo = [[TeamProfileCollectionViewController alloc] initWithNibName:@"TeamProfileCollectionViewController" bundle:nil];
        UINavigationController *cont = [[UINavigationController alloc] initWithRootViewController:nextCo];
        [self presentViewController:cont animated:YES completion:nil];
        
    }
}

@end
