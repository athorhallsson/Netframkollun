//
//  ViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PhotoViewController.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoDetailsViewController.h"
#import "OrderViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController


- (void)viewWillAppear:(BOOL)animated {
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Init datasource
    _photos = [[NSMutableArray alloc] init];
    
    // Init collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(175, 175)];
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
        
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

// Buttons

- (IBAction)addButtonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}


// Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    Photo *newPhoto = [[Photo alloc] initWithImage:chosenImage];
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
        [(PhotoDetailsViewController *)[segue destinationViewController] setDetailPhoto:(Photo *)sender];
    }
    if ([segue.identifier isEqualToString:@"sendSegue"]) {
        [(OrderViewController*)[segue destinationViewController] setPhotos:_photos];
    }
}

@end
