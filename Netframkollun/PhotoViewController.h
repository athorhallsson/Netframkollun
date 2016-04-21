//
//  ViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *photos;


- (IBAction)addButtonPressed:(id)sender;
    
@end

