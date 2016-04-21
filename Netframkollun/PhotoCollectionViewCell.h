//
//  PhotoCollectionViewCell.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (id)initWithFrame:(CGRect)frame;
- (void) configureWithPhoto:(Photo *)myPhoto;

@end
