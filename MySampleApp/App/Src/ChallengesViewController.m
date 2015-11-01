//
//  ChallengesViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 31/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "ChallengesViewController.h"
#import "DraggableViewBackground.h"

@interface ChallengesViewController ()<DraggableViewBackgroundDelegate>
@end

@implementation ChallengesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    draggableBackground.delegate = self;
    [self.view addSubview:draggableBackground];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cardWasSwapedRight {
    // challenge the other team
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"Challenge sent to the team"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Label")
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
    [alertController addAction:doneAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0];
    }];
}

-(void)cardWasSwapedLeft {
    
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
