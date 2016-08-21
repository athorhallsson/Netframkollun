//
//  ViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PhotoViewController.h"
#import "NetworkManager.h"
#import "SessionManager.h"
#import "NetworkManager.h"


@interface PhotoViewController ()

@property (nonatomic) NSInteger imageCounter;
@end

@implementation PhotoViewController


- (void)viewWillAppear:(BOOL)animated {
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_imageCounter) {
        _imageCounter = 0;
    }
    
    // Fetch image types, deliveries, payments and pricelist for current user
    User *currUser = [SessionManager getSignedInUser];
    
    [NetworkManager getImageTypes:currUser
                                 :self];

    [NetworkManager getPayments:currUser
                               :self];
    
    [NetworkManager getDeliveries:currUser
                                 :self];
    
    [NetworkManager getPriceList:currUser
                                :self];

    // Init datasource
    _photos = [[NSMutableArray alloc] init];
    
    // Init flowlayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(175, 175)];
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    // Init collectionView
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    // Init collectionViewCell
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Buttons

- (IBAction)addButtonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)infoButtonPressed:(UIButton *)sender {
    
    User *user = [SessionManager getSignedInUser];
    
    UIAlertController *actionSheet = [UIAlertController
                                      alertControllerWithTitle:user.name
                                      message:@"Viltu skrá þig út?"
                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* signOut = [UIAlertAction
                              actionWithTitle:@"skrá út"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  [SessionManager signOutUser];
                                  [actionSheet dismissViewControllerAnimated:YES completion:nil];
                                  [self performSegueWithIdentifier:@"signOut" sender:nil];
                             
                              }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"hætta við"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [actionSheet dismissViewControllerAnimated:YES completion:nil];
                             }];
    [actionSheet addAction:signOut];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    if ([_photos count] == 0) {
        UIAlertController * alert = [UIAlertController
                                    alertControllerWithTitle:@"Bíddu hægur"
                                    message:@"Bættu við myndum áður en þú heldur áfram"
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [self performSegueWithIdentifier:@"OrderSegue" sender:nil];
    }
    
}


// Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    _imageCounter++;
    Photo *newPhoto = [[Photo alloc] initWithImage:chosenImage
                                  andWithImageType:_defaultImageType
                                           andName:[NSString stringWithFormat:@"photo%lu.jpg", (long)_imageCounter]];
    [_photos addObject:newPhoto];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [_collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PhotoCollectionCell";
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configureWithPhoto:[_photos objectAtIndex:indexPath.row]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"PhotoDetails" sender:[_photos objectAtIndex:[indexPath row]]];
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 30, 30, 30);
}


// Segue
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PhotoDetails"]) {
        [(PhotoNavigationController *)[segue destinationViewController] setDetailPhoto:(Photo *)sender];
        [(PhotoNavigationController *)[segue destinationViewController] setSizePickerData:_imageTypes];
        [(PhotoNavigationController *)[segue destinationViewController] setPhotos:_photos];
    }
    if ([segue.identifier isEqualToString:@"OrderSegue"]) {
        [(OrderViewController*)[segue destinationViewController] setPhotos:_photos];
        [(OrderViewController*)[segue destinationViewController] setDeliveries:_deliveries];
        [(OrderViewController*)[segue destinationViewController] setImageTypes:_imageTypes];
        [(OrderViewController*)[segue destinationViewController] setPayments:_payments];
        [(OrderViewController*)[segue destinationViewController] setMinCost:_minCost];
    }
}

@end
