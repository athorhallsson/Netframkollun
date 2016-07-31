//
//  ImageTypeParser.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageType.h"

@interface ImageTypeParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableDictionary *imageTypes;

- (id)initWithXMLData:(NSData*)data;

@end
