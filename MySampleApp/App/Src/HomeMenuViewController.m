//
//  HomeMenuViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 31/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "HomeMenuViewController.h"
#import "TeamProfileCollectionViewController.h"

@interface HomeMenuViewController ()

@end

@implementation HomeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *team = [[UIBarButtonItem alloc]initWithTitle:@"Your Team" style:UIBarButtonItemStylePlain target:self action:@selector(teamButtonClicked)];
    self.navigationItem.rightBarButtonItem = team;
}

- (void)teamButtonClicked{
    TeamProfileCollectionViewController *nextCo = [[TeamProfileCollectionViewController alloc] initWithNibName:@"TeamProfileCollectionViewController" bundle:nil];
    [self.navigationController pushViewController:nextCo animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
