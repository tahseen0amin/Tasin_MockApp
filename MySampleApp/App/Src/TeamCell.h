//
//  TeamCell.h
//  TasinMockApp
//
//  Created by Taseen Amin on 31/10/2015.
//  Copyright © 2015 Amazon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *teamProfilePic;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *teamName;

@end
