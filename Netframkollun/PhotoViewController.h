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
#import "PhotoCollectionViewCell.h"
#import "PhotoDetailsViewController.h"
#import "OrderViewController.h"
#import "PaymentParser.h"
#import "DeliveryParser.h"
#import "ImageTypeParser.h"

@interface PhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) User *currUser;

@property (strong, nonatomic) NSArray *payments;
@property (strong, nonatomic) NSArray *deliveries;
@property (strong, nonatomic) NSArray *imageTypes;

- (IBAction)addButtonPressed:(id)sender;
    
@end

