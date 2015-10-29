//
//  AddTeamViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 29/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "AddTeamViewController.h"

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
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)TakeSelfie:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
         
        
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
}

- (void)segueToAnotherController {
    if ([self nextButtonEnabled]) {
        // segue to different controller
    }
}

@end
