//
//  Properties.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "Properties.h"
#import "Photo.h"

@implementation Properties

+ (NSArray *)imageSizes {
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

+ (NSArray *)quantities {
    static NSArray *_quantities;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _quantities = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20];
    });
    return _quantities;
}

+ (NSNumber*)prices:(NSMutableArray*)photos {
    int totalPrice = 0;
    
    for (int i = 0; i < [photos count]; i++) {
        totalPrice += [self calculatePrice:[photos objectAtIndex:i]];
    }
    
    if (totalPrice > 490) {
        return [[NSNumber alloc] initWithInt:totalPrice];
    }
    return @490;
}


+ (int)calculatePrice:(Photo*)photo {
    if ([photo.imageSize isEqualToString:@"10x15"]) {
        if (photo.count < 50) {
            return 49 * (int)photo.count;
        }
        else if (photo.count < 100) {
            return 45 * (int)photo.count;
        }
        else if (photo.count < 500) {
            return 40 * (int)photo.count;
        }
        else if (photo.count < 1000) {
            return 37 * (int)photo.count;
        }
        else {
            return 33 * (int)photo.count;
        }
    }
    else if ([photo.imageSize isEqualToString:@"13x18"]) {
        return 355 * (int)photo.count;
    }
    else if ([photo.imageSize isEqualToString:@"15x20"]) {
        return 395 * (int)photo.count;
    }
    else if ([photo.imageSize isEqualToString:@"18x24"]) {
        return 595 * (int)photo.count;
    }
    else if ([photo.imageSize isEqualToString:@"20x25"]) {
        return 695 * (int)photo.count;
    }
    else if ([photo.imageSize isEqualToString:@"21x30"]) {
        return 895 * (int)photo.count;
    }
     
    return 0;
}
         
@end
