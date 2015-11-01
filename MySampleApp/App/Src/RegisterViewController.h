//
//  RegisterViewController.h
//  TasinMockApp
//
//  Created by Taseen Amin on 01/11/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fullNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end
