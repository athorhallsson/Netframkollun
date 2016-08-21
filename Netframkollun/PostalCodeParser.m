//
//  PostalCodeParser.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PostalCodeParser.h"

@interface PostalCodeParser()
@property (strong, nonatomic) NSString *parseString;
@property (nonatomic) BOOL inPostCode;
@property (nonatomic) BOOL inLocation;
@end

@implementation PostalCodeParser

- (id)initWithXMLData:(NSData*)data {
    self = [super init];
    
    _locations = [[NSMutableArray alloc] init];
    _pCodes = [[NSMutableArray alloc] init];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    _parseString = @"";
    [xmlParser parse];
    
    return self;
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"Pcode"]) {
        _inPostCode = YES;
    }
    else if ([elementName isEqualToString:@"Location"]) {
        _inLocation = YES;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_inPostCode) {
        [_pCodes addObject:string];
    }
    else if (_inLocation) {
        _parseString = [_parseString stringByAppendingString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Pcode"]) {
        _inPostCode = NO;
    }
    else if ([elementName isEqualToString:@"Location"]) {
        [_locations addObject:[NSString stringWithString:_parseString]];
        _parseString = @"";
        _inLocation = NO;
    }
}

@end
