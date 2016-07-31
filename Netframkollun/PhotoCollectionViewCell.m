//
//  PhotoCollectionViewCell.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

-(void) configureWithPhoto:(Photo *)myPhoto {
    [_sizeLabel setText:myPhoto.imageType.imageTypeDescription];
    [_countLabel setText:[NSString stringWithFormat:@"%@", myPhoto.count]];
    [_imageView setImage:myPhoto.image];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        //[_imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        //[_imageView.layer setBorderWidth: 1.0];
        //_imageView.layer.cornerRadius = 2.0;
        self.layer.cornerRadius = 4.0;
        
        
    }
    
    return self;
    
}

@end
