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
    [_countTextField setText:[NSString stringWithFormat:@"%@", _detailPhoto.count]];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
