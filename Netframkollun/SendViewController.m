//
//  SendViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "SendViewController.h"
#import "Properties.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_activityIndicator startAnimating];
    [self createOrder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
    


- (void)createOrder {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/createOrder</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><createOrder xmlns=\"http://imageuploader.digit.is\"><storeID>%@</storeID><userid>%@</userid><paymentid>%@</paymentid><deliveryid>%@</deliveryid><order xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/Digit.ImageUploader.WebService\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">", Properties.restService, Properties.storeId, _currUser.userId, _payment.paymentId, _delivery.deliveryId];
    
    for (Photo *photo in _photos) {
        soapBody = [soapBody stringByAppendingString:[self createImageItemFromPhoto:photo]];
    }
    
    soapBody = [soapBody stringByAppendingString: @"</order><comments>Athugasemdin</comments><card>uA3i6jSzw38gxYQe8k1SiA==</card><exp>/</exp></createOrder></s:Body></s:Envelope>"];
    
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
                                      NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response: %@", newStr);
                                      CreateOrderResponseParser *rp = [[CreateOrderResponseParser alloc] initWithXMLData:data];
                                      _orderId = rp.orderId;
                                      
                                      if (error) {
                                          NSLog(@"Error: %@", error);
                                      } else {
                                          [self uploadPhotos];
                                      }
                                  }];
    [task resume];
    // netframkollun.pedromyndir.is/digit.imageuploader.webservice/OrderServiceJS.svc
    // ad28e5a9-2244-40af-8c3c-05da9eb13efe
    //2838
    // payment 5
    // delivery 4
}

- (NSString *)createImageItemFromPhoto:(Photo *)photo {
    return [NSString stringWithFormat:@"<d4p1:OrderImage><d4p1:Count>%@</d4p1:Count><d4p1:ErrorCode>0</d4p1:ErrorCode><d4p1:FileName>%@</d4p1:FileName><d4p1:ImageID>%@</d4p1:ImageID><d4p1:ImageItemID>%@</d4p1:ImageItemID><d4p1:Price>%@</d4p1:Price><d4p1:Uploaded>false</d4p1:Uploaded></d4p1:OrderImage>", photo.count, @"name", photo.imageId, photo.imageItemId, photo.imageType.price];
    // 777560a9-b11f-4add-9307-6ec8ed5d6602
}

- (void)uploadPhotos {
    for (Photo *photo in _photos) {
        [self uploadPhoto:photo];
    }
    [self finalizeOrder];
}

- (void)uploadPhoto:(Photo*)photo {
    NSString *host = [Properties restService];
    
    NSData *data = UIImageJPEGRepresentation(photo.image, 1.0);
    
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><uploadImage xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://digit.is/ImageUploader\"><iID>%@</iID><image>%@</image></uploadImage></s:Body></s:Envelope>", photo.imageId, data];
    
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
                                      NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response: %@", newStr);
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}

- (void)finalizeOrder {
    NSString *host = [Properties restService];
    NSString *soapBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/finalizeOrder</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><finalizeOrder xmlns=\"http://imageuploader.digit.is\"><id>%@</id></finalizeOrder></s:Body></s:Envelope>", Properties.restService, _orderId];
    
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
                                      NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response: %@", newStr);
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}

/*
 
 http://netframkollun.pedromyndir.is/digit.imageuploader.webservice/UploadFile.asmx
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
