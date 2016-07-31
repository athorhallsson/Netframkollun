//
//  PhotoDetailsViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 20/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "ImageType.h"

@interface PhotoDetailsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Photo *detailPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *sizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) NSDictionary *sizePickerData;
@property (strong, nonatomic) NSArray *sizePickerArray;
@property (strong, nonatomic) NSMutableArray *countPickerData;

- (IBAction)saveButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
