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

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imageView setImage:[_detailPhoto image]];
    [_sizeTextField setText:[_detailPhoto imageSize]];
    [_countTextField setText:[NSString stringWithFormat:@"%lu", [_detailPhoto count]]];
    
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
    
    _countPickerData = [Properties quantities];
    _sizePickerData = [Properties imageSizes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        return [_sizePickerData count];
    }
    else {
        return [_countPickerData count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        return [_sizePickerData objectAtIndex:row];
    }
    else {
        return [NSString stringWithFormat:@"%ld", (long)[(NSNumber *)[_countPickerData objectAtIndex:row] integerValue]];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView tag] == 1) {
        [_sizeTextField setText:[_sizePickerData objectAtIndex:row]];
    }
    else {
        [_countTextField setText:[NSString stringWithFormat:@"%ld", (long)[(NSNumber *)[_countPickerData objectAtIndex:row] integerValue]]];
    }
    [[self view] endEditing:YES];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    [_detailPhoto setImageSize:[_sizeTextField text]];
    [_detailPhoto setCount:[[_countTextField text] integerValue]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
