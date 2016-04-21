//
//  Properties.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "Properties.h"

@implementation Properties

+ (NSArray *)imageSizes
{
    static NSArray *_sizes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sizes = @[@"10x15",
                    @"13x18",
                    @"15x20",
                    @"18x24",
                    @"20x25",
                    @"21x30",
                    @"30x45",
                    @"30x60",
                    @"40x60"];
    });
    return _sizes;
}

+ (NSArray *)quantities
{
    static NSArray *_quantities;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _quantities = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20];
    });
    return _quantities;
}

@end
