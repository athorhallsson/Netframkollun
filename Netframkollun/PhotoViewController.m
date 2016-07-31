//
//  ViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PhotoViewController.h"


@interface PhotoViewController ()
@property (strong, nonatomic) ImageType *defaultImageType;
@end

@implementation PhotoViewController


- (void)viewWillAppear:(BOOL)animated {
    [_collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fetch image types
    [self getImageTypes];
    [self getPayments];
    [self getDeliveries];
    [self getPriceList];

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


// Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    Photo *newPhoto = [[Photo alloc] initWithImage:chosenImage andWithImageType:_defaultImageType];
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

// Networking

- (void)getImageTypes {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getImageTypes</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getImageTypes xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getImageTypes></s:Body></s:Envelope>", [Properties restService], _currUser.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      //NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      //NSLog(@"Response: %@", newStr);
                                      ImageTypeParser *itp = [[ImageTypeParser alloc] initWithXMLData:data];
                                      _imageTypes = [itp imageTypes];
                                      _defaultImageType = [[itp imageTypes] objectForKey:@"2"];
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];

}

- (void)getDeliveries {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getDeliveries</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getDeliveries xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getDeliveries></s:Body></s:Envelope>", [Properties restService], _currUser.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response: %@", newStr);
                                      DeliveryParser *pd = [[DeliveryParser alloc] initWithXMLData:data];
                                      _deliveries = pd.deliveries;
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
    
}

- (void)getPayments {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getPayments</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getPayments xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getPayments></s:Body></s:Envelope>", [Properties restService], _currUser.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response: %@", newStr);
                                      PaymentParser *pp = [[PaymentParser alloc] initWithXMLData:data];
                                      _payments = pp.payments;
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
    
}

- (void)getPriceList {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getPricelist</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getPricelist xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getPricelist></s:Body></s:Envelope>", [Properties restService], _currUser.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response: %@", newStr);
                                      PriceList *pl = [[PriceList alloc] initWithXMLData:data];
                                      _minCost = [NSNumber numberWithInteger:[pl.minCost integerValue]];
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
    
}

// Segue
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PhotoDetails"]) {
        [(PhotoDetailsViewController *)[segue destinationViewController] setDetailPhoto:(Photo *)sender];
        [(PhotoDetailsViewController *)[segue destinationViewController] setSizePickerData:self.imageTypes];
    }
    if ([segue.identifier isEqualToString:@"OrderSegue"]) {
        [(OrderViewController*)[segue destinationViewController] setPhotos:_photos];
        [(OrderViewController*)[segue destinationViewController] setDeliveries:_deliveries];
        [(OrderViewController*)[segue destinationViewController] setImageTypes:_imageTypes];
    }
}

@end
