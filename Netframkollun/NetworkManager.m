//
//  NetworkManager.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 20/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "NetworkManager.h"
#import "Properties.h"
#import "SessionManager.h"
#import "PaymentParser.h"
#import "DeliveryParser.h"
#import "ImageTypeParser.h"
#import "PostalCodeParser.h"

@implementation NetworkManager


+ (void)getImageTypes:(User *)user
                     :(PhotoViewController *)sender {
    NSString *host = [Properties restService];
    
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getImageTypes</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getImageTypes xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getImageTypes></s:Body></s:Envelope>", [Properties restService], user.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      ImageTypeParser *itp = [[ImageTypeParser alloc] initWithXMLData:data];
                                      sender.imageTypes = [itp imageTypes];
                                      // HARD CODED 10x15
                                      sender.defaultImageType = [[itp imageTypes] objectForKey:@"2"];
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
    
}

+ (void)getDeliveries:(User *)user
                     :(PhotoViewController *)sender {
    NSString *host = [Properties restService];
    
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getDeliveries</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getDeliveries xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getDeliveries></s:Body></s:Envelope>", [Properties restService], user.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      DeliveryParser *pd = [[DeliveryParser alloc] initWithXMLData:data];
                                      sender.deliveries = pd.deliveries;
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
    
}

+ (void)getPayments:(User *)user
                   :(PhotoViewController *)sender {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getPayments</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getPayments xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getPayments></s:Body></s:Envelope>", [Properties restService], user.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      PaymentParser *pp = [[PaymentParser alloc] initWithXMLData:data];
                                      sender.payments = pp.payments;
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
    
}

+ (void)getPriceList:(User *)user
                    :(PhotoViewController *)sender {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/getPricelist</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><getPricelist xmlns=\"http://imageuploader.digit.is\"><userid>%@</userid></getPricelist></s:Body></s:Envelope>", [Properties restService], user.userId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      PriceList *pl = [[PriceList alloc] initWithXMLData:data];
                                      sender.minCost = [NSNumber numberWithInteger:[pl.minCost integerValue]];
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
    
}

+ (void)sendLogin:(NSString*)email
     withPassword:(NSString*)password
       withSender:(id)sender {
    NSString *loginSOAPBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/login</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><login xmlns=\"http://imageuploader.digit.is\"><email>%@</email><password>%@</password><storeID>%@</storeID></login></s:Body></s:Envelope>", [Properties restService], email, password, [Properties storeId]];
    
    NSString *url = [Properties restService];
    NSURL *sRequestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[loginSOAPBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue:[Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: [Properties host] forHTTPHeaderField:@"Origin"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [loginSOAPBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      User *currUser = [[User alloc] initWithXMLData:data];
                                      // Success
                                      if ([responseString containsString:@"<b:ErrorCode>0</b:ErrorCode>"]) {
                                          [SessionManager signInUser:currUser];
                                          [sender performSelectorOnMainThread:@selector(login:)
                                                                 withObject:nil
                                                              waitUntilDone:NO];
                                      }
                                      else {
                                          // Alert User
                                          [sender performSelectorOnMainThread:@selector(loginError:)
                                                                 withObject:nil
                                                              waitUntilDone:NO];
                                      }
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}


+ (void)createUser:(User*)user
      withLocation:(NSString*)location
        withSender:(RegisterViewController*)sender {
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/createUser</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><createUser xmlns=\"http://imageuploader.digit.is\"><user xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/Digit.ImageUploader.WebService\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"><d4p1:ErrorCode>0</d4p1:ErrorCode><d4p1:address>%@</d4p1:address><d4p1:city>%@</d4p1:city><d4p1:email>%@</d4p1:email><d4p1:id>0</d4p1:id><d4p1:name>%@</d4p1:name><d4p1:password>%@</d4p1:password><d4p1:pcode>%@</d4p1:pcode><d4p1:phone>%@</d4p1:phone><d4p1:ssid>%@</d4p1:ssid><d4p1:storeID>%@</d4p1:storeID></user></createUser></s:Body></s:Envelope>", [Properties restService], user.address, location, user.email, user.name, user.password, user.pCode, user.phone, user.ssn, [Properties storeId]];
    NSString *host = [Properties restService];
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      if ([responseString containsString:@"<createUserResult>0</createUserResult>"]) {
                                          [NetworkManager sendLogin:user.email withPassword:user.password withSender:sender];
                                      }
                                      else {
                                          NSLog(@"Register ERROR");
                                      }
                                      
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}



+ (void)createOrder:(User*)user
        withPayment:(Payment*)payment
       withDelivery:(Delivery*)delivery
         withPhotos:(NSArray*)photos
       withComment:(NSString*)comment
        withSender:(SendViewController*)sender {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/createOrder</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><createOrder xmlns=\"http://imageuploader.digit.is\"><storeID>%@</storeID><userid>%@</userid><paymentid>%@</paymentid><deliveryid>%@</deliveryid><order xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/Digit.ImageUploader.WebService\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">", [Properties restService], Properties.storeId, user.userId, payment.paymentId, delivery.deliveryId];
    
    for (Photo *photo in photos) {
        soapBody = [soapBody stringByAppendingString:[self createImageItemFromPhoto:photo]];
    }
    
    NSString *restOfSoapBody = [NSString stringWithFormat:@"</order><comments>%@</comments><card>uA3i6jSzw38gxYQe8k1SiA==</card><exp>/</exp></createOrder></s:Body></s:Envelope>", comment];
    
    soapBody = [soapBody stringByAppendingString:restOfSoapBody];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      CreateOrderResponseParser *rp = [[CreateOrderResponseParser alloc] initWithXMLData:data];
                                      sender.orderId = [NSString stringWithString:rp.orderId];
                                      
                                      if (error) {
                                          NSLog(@"Error: %@", error);
                                      } else {
                                          [self uploadPhotos:photos withSender:sender];
                                      }
                                  }];
    [task resume];
}

+ (NSString *)createImageItemFromPhoto:(Photo *)photo {
    return [NSString stringWithFormat:@"<d4p1:OrderImage><d4p1:Count>%@</d4p1:Count><d4p1:ErrorCode>0</d4p1:ErrorCode><d4p1:FileName>%@</d4p1:FileName><d4p1:ImageID>%@</d4p1:ImageID><d4p1:ImageItemID>%@</d4p1:ImageItemID><d4p1:Price>%@</d4p1:Price><d4p1:Uploaded>false</d4p1:Uploaded></d4p1:OrderImage>", photo.count, photo.imageName, photo.imageId, photo.imageType.imageTypeId, photo.imageType.price];
}

+ (void)uploadPhotos:(NSArray *)photos
          withSender:(SendViewController *)sender {
    for (Photo *photo in photos) {
        [self uploadPhoto:photo withSender:sender];
    }
}

+ (void)uploadPhoto:(Photo*)photo
         withSender:(SendViewController*)sender {

    NSString *host = [Properties uploadService];
    // NSData *data = UIImagePNGRepresentation(photo.image);
    // Save JPEG image with 90% quality
    NSData *data = UIImageJPEGRepresentation(photo.image, 0.9);
    NSString *stringImage = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><uploadImage xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://digit.is/ImageUploader\"><iID>%@</iID><image>%@</image></uploadImage></s:Body></s:Envelope>", photo.imageId, stringImage];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      [sender performSelectorOnMainThread:@selector(updateProgress)
                                                             withObject:nil
                                                          waitUntilDone:NO];
                                      
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}

+ (void)finalizeOrderwithSender:(SendViewController*)sender {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/finalizeOrder</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><finalizeOrder xmlns=\"http://imageuploader.digit.is\"><id>%@</id></finalizeOrder></s:Body></s:Envelope>", Properties.restService, sender.orderId];
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *length = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: [Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: length forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      CreateOrderResponseParser *rp = [[CreateOrderResponseParser alloc] initWithXMLData:data];
                                      NSString *msg = [NSString stringWithString:rp.orderId];
                                      // Get first sentence
                                      NSArray *substrings = [msg componentsSeparatedByString:@"."];
                                      
                                      [sender performSelectorOnMainThread:@selector(displaySuccess:)
                                                             withObject:[substrings objectAtIndex:0]
                                                          waitUntilDone:NO];
                                      if (error) {
                                          NSLog(@"Error %@", error);
                                      }
                                  }];
    [task resume];
}

+ (void)getPostalCodeswithSender:(RegisterViewController*)sender {
    NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><getPostalCodes xmlns=\"http://imageuploader.digit.is\" /></soap:Body></soap:Envelope>";
    NSString *host = [Properties webService];
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: @"http://imageuploader.digit.is/getPostalCodes" forHTTPHeaderField:@"SOAPAction"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      PostalCodeParser *pcp = [[PostalCodeParser alloc] initWithXMLData:data];
                                      sender.locations = pcp.locations;
                                      sender.pCodes = pcp.locations;
                                      
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}



@end


