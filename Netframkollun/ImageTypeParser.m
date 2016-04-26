//
//  ImageTypeParser.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "ImageTypeParser.h"

@interface ImageTypeParser ()

@property (strong, nonatomic) NSString *parseString;
@property (strong, nonatomic) ImageType *currImageType;

@end

@implementation ImageTypeParser

- (id)initWithXMLData:(NSData*)data {
    self = [super init];
    
    _imageTypes = [[NSMutableArray alloc] init];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    return self;
}

// XML parser

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _parseString = @"";
    if ([elementName isEqualToString:@"b:ImageTypeItem"]) {
        _currImageType = [[ImageType alloc] init];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    _parseString = [_parseString stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"b:Description"]) {
        [_currImageType setImageTypeDescription:_parseString];
    }
    else if ([elementName isEqualToString:@"b:DicountGroupID"]) {
        [_currImageType setDicountGroupID:_parseString];
    }
    else if ([elementName isEqualToString:@"b:Height"]) {
        [_currImageType setHeight:_parseString];
    }
    else if ([elementName isEqualToString:@"b:Price"]) {
        [_currImageType setPrice:_parseString];
    }
    else if ([elementName isEqualToString:@"b:Width"]) {
        [_currImageType setWidth:_parseString];
        // Last element, add to array
        [_imageTypes addObject:_currImageType];
    }
}


@end
