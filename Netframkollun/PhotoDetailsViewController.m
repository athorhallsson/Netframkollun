//
//  PhotoDetailsViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 20/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "Properties.h"

@interface PhotoDetailsViewController ()
@property (strong, nonatomic) ImageType *selectedImageType;
@property (strong) UIPickerView *sizePickerView;
@property (strong) UIPickerView *countPickerView;
@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sortedArray = [[_sizePickerData allValues] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ImageType*)a imageTypeDescription];
        NSString *second = [(ImageType*)b imageTypeDescription];
        return [first compare:second];
    }];
    
    _sizePickerArray = sortedArray;
    _countPickerData = [[NSMutableArray alloc] init];
    
    // Init Fields
    [_imageView setImage:[_detailPhoto image]];
    [_sizeTextField setText:[[_detailPhoto imageType] imageTypeDescription]];
    _selectedImageType = _detailPhoto.imageType;
    [_countTextField setText:[_detailPhoto.count stringValue]];
    
    // Init PickerViews
    _sizePickerView = [UIPickerView new];
    _countPickerView = [UIPickerView new];
    
    UIToolbar *toolBar1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    toolBar1.translucent = true;
    
    UIToolbar *toolBar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    toolBar2.translucent = true;
    
    UIBarButtonItem *barButtonDone1 = [[UIBarButtonItem alloc] initWithTitle:@"Velja"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(donePressedOnPickerViewSize)];
    UIBarButtonItem *barButtonDone2 = [[UIBarButtonItem alloc] initWithTitle:@"Velja"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(donePressedOnPickerViewCount)];
    toolBar1.items = @[barButtonDone1];
    toolBar2.items = @[barButtonDone2];
    
    _sizeTextField.inputAccessoryView = toolBar1;
    _countTextField.inputAccessoryView = toolBar2;
    
    _sizeTextField.inputView = _sizePickerView;
    _sizeTextField.tintColor = [UIColor clearColor];
    [_sizePickerView setTag:1];
    [_sizePickerView setDelegate:self];
    [_sizePickerView setDataSource:self];
    
    _countTextField.inputView = _countPickerView;
    _countTextField.tintColor = [UIColor clearColor];
    [_countPickerView setTag:2];
    [_countPickerView setDelegate:self];
    [_countPickerView setDataSource:self];
    

    for (NSInteger i = 1; i <= 100; i++) {
        [_countPickerData addObject:[NSNumber numberWithInteger:i]];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        return [_sizePickerArray count];
    }
    else {
        return [_countPickerData count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        return [(ImageType *)[_sizePickerArray objectAtIndex:row] imageTypeDescription];
    }
    else {
        return [[_countPickerData objectAtIndex:row] stringValue];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        [_sizeTextField setText:[[_sizePickerArray objectAtIndex:row] imageTypeDescription]];
        _selectedImageType = [_sizePickerArray objectAtIndex:row];
    }
    else {
        [_countTextField setText:[[_countPickerData objectAtIndex:row] stringValue]];
    }
}

- (void)donePressedOnPickerViewCount {
    NSInteger row = [_countPickerView selectedRowInComponent:0];
    [_countTextField setText:[[_countPickerData objectAtIndex:row] stringValue]];
    [_countTextField resignFirstResponder];
}

- (void)donePressedOnPickerViewSize {
     NSInteger row = [_sizePickerView selectedRowInComponent:0];
    [_sizeTextField setText:[[_sizePickerArray objectAtIndex:row] imageTypeDescription]];
    _selectedImageType = [_sizePickerArray objectAtIndex:row];
    [_sizeTextField resignFirstResponder];
    [self showCropper];
}



// Buttons

- (IBAction)saveButtonPressed:(UIButton *)sender {
    [_detailPhoto setImageType:_selectedImageType];
    [_detailPhoto setCount:[NSNumber numberWithInteger:[[_countTextField text] integerValue]]];
    [_detailPhoto setImage:_imageView.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Fínasta mynd..."
                                 message:@"ertu viss um að þú viljir eyða myndinni?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"jebb"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [_photos removeObject:_detailPhoto];
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"hætta við"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)imagePressed:(UITapGestureRecognizer *)recognizer {
    [self showCropper];
}


- (void)showCropper {
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:_detailPhoto.originalImage];
    [imageCropVC.chooseButton setTitle:@"Staðfesta" forState:UIControlStateNormal];
    [imageCropVC.cancelButton setTitle:@"Hætta við" forState:UIControlStateNormal];
    [imageCropVC.moveAndScaleLabel setText:@"Stilltu myndina af"];
    imageCropVC.cropMode = RSKImageCropModeCustom;
    imageCropVC.avoidEmptySpaceAroundImage = true;
    imageCropVC.applyMaskToCroppedImage = true;
    imageCropVC.delegate = self;
    imageCropVC.dataSource = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect {
    self.imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle {
    self.imageView.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage {
    // Use when `applyMaskToCroppedImage` set to YES.
}

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {
    CGSize maskSize;
    CGFloat height = controller.originalImage.size.height;
    CGFloat width = controller.originalImage.size.width;
    float cropWidth = [_selectedImageType.width floatValue];
    float cropHeight = [_selectedImageType.height floatValue];
    float ratio;
    if (cropWidth > cropHeight) {
        ratio = cropHeight/cropWidth;
    }
    else {
        ratio = cropWidth/cropHeight;
    }
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGFloat size = viewWidth;
    
    if (width > height) {
        maskSize = CGSizeMake(size, size * ratio);
    }
    else {
        maskSize = CGSizeMake(size * ratio , size);
        
    }
  
    // centered
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5,
                                 (viewHeight - maskSize.height) * 0.5,
                                 maskSize.width,
                                 maskSize.height);
    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *rectangle = [UIBezierPath bezierPath];
    [rectangle moveToPoint:point1];
    [rectangle addLineToPoint:point2];
    [rectangle addLineToPoint:point3];
    [rectangle addLineToPoint:point4];
    [rectangle closePath];
    
    return rectangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller {
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}

@end
