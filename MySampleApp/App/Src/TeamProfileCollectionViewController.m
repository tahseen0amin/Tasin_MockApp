//
//  TeamProfileCollectionViewController.m
//  TasinMockApp
//
//  Created by Taseen Amin on 30/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import "TeamProfileCollectionViewController.h"
#import "TeamMemberCellView.h"
#import "TeamNameReusuableView.h"
@import AddressBookUI;
@import MessageUI;


@interface TeamProfileCollectionViewController ()<ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation TeamProfileCollectionViewController

static NSString * const reuseIdentifier = @"MemberCell";
static NSString * const reuseIdentifierForHeader = @"HeaderCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[TeamMemberCellView class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TeamMemberCollectionCellView" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TeamNameReusuableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierForHeader];
    
    // Do any additional setup after loading the view.
    
    // add a navigation bar button for addNew Team mate
    UIBarButtonItem *addMate = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTeamMateClicked:)];
    self.navigationItem.rightBarButtonItem = addMate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (TeamMemberCellView *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TeamMemberCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

- (TeamNameReusuableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TeamNameReusuableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierForHeader forIndexPath:indexPath];
        headerView.TeamNameLabel.text = @"TEAM NAME IS HERE";
        
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}
#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Add New TeamMate

- (void)addTeamMateClicked:(id)sender{
    ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef multi = ABRecordCopyValue(person, property);
    NSArray *theArray = (__bridge id)ABMultiValueCopyArrayOfAllValues(multi);
    // Figure out which values we want and store the index.
    const NSUInteger theIndex = ABMultiValueGetIndexForIdentifier(multi, identifier);
    id value = [theArray objectAtIndex:theIndex];
    if (property == kABPersonPhoneProperty) {
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            [self sendSMStoNumber:value];
        }];
        NSLog(@"Phone was selected");
    } else if(property == kABPersonEmailProperty){
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            [self sendEmailToAddress:value];
        }];
        NSLog(@"Email was selected");
    }
}

- (void)sendSMStoNumber:(NSString *)number {
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]){
        controller.body = @"SMS message here";
        controller.recipients = [NSArray arrayWithObjects:number, nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)sendEmailToAddress:(NSString *)address {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"yo!"];
        [mailCont setToRecipients:[NSArray arrayWithObject:address]];
        [mailCont setMessageBody:@"Don't ever want to give you up" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end