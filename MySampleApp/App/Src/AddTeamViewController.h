//
//  AddTeamViewController.h
//  TasinMockApp
//
//  Created by Taseen Amin on 29/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTeamViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *TeamNameTF;

@end
