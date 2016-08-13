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
    UIPickerView * sizePickerView = [UIPickerView new];
    UIPickerView * countPickerView = [UIPickerView new];
    
    _sizeTextField.inputView = sizePickerView;
    [sizePickerView setTag:1];
    [sizePickerView setDelegate:self];
    [sizePickerView setDataSource:self];
    
    _countTextField.inputView = countPickerView;
    [countPickerView setTag:2];
    [countPickerView setDelegate:self];
    [countPickerView setDataSource:self];

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
    [[self view] endEditing:YES];
}

// Buttons

- (IBAction)saveButtonPressed:(UIButton *)sender {
    [_detailPhoto setImageType:_selectedImageType];
    [_detailPhoto setCount:[NSNumber numberWithInteger:[[_countTextField text] integerValue]]];
    // try to save
    [_detailPhoto setImage:_imageView.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)imagePressed:(UITapGestureRecognizer *)recognizer {
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
   // self.detailPhoto.image = croppedImage;
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
    
    
    if (width > height) {
        maskSize = CGSizeMake(350, 350 * ratio);
    }
    else {
        maskSize = CGSizeMake(350 * ratio , 350);

    }
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
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
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:point1];
    [triangle addLineToPoint:point2];
    [triangle addLineToPoint:point3];
    [triangle addLineToPoint:point4];
    [triangle closePath];
    
    return triangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller {
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}

@end
