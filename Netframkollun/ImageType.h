//
//  ImageType.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageType : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSString *imageTypeDescription;
@property (nonatomic, strong) NSString *dicountGroupID;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *imageTypeId;
@property (nonatomic, strong) NSString *price;

@end
