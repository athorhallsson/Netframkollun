//
//  ViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Properties.h"
#import "Photo.h"
#import "PriceList.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoDetailsViewController.h"
#import "PhotoNavigationController.h"
#import "OrderViewController.h"

@interface PhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) ImageType *defaultImageType;

@property (strong, nonatomic) User *currUser;

@property (strong, nonatomic) NSDictionary *payments;
@property (strong, nonatomic) NSDictionary *deliveries;
@property (strong, nonatomic) NSDictionary *imageTypes;
@property (strong, nonatomic) NSNumber *minCost;

- (IBAction)addButtonPressed:(id)sender;
    
@end

