//
//  SNZdevice.m
//  zwave
//
//  Created by sam on 16/11/2013.
//  Copyright (c) 2013 Sam Novotny. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "SNZdevice.h"

@implementation SNZdevice

/** ****************************************************************************************************************************
 *
 * Method name: initWithURL:port:
 * Description: Initialiser
 * Parameters:  <urlStr> - fully qualified URL to the Razberry server
 *              <port> - that the server is listening on (out of the box it is 8083)
 *
 */
- (id) initWithURL:(NSString *)urlStr port:(NSString *)portStr {
    self = [super init];
    self.urlString = urlStr;
    self.portString = portStr;
    return self;
}

/** ****************************************************************************************************************************
 *
 * Method name: sendRazberryCommand
 * Description: Send the command string to the device (just the command itself not the other bits like /ZWaveAPI...
 * Parameters:  <command> - the command itself
 *
 * NOTE:    This does a synchronous call in the interest of simplicity - your display will freeze till you get a response or
 *          the specified TIMEOUT expires. Rsaperry's usually respond subsecond.
 *
 *          Most complicated bit of this method is unscrambling a response and sending back an NSDictionary of the response
 */
- (NSDictionary *)sendRazberryCommand:(NSString *)command {

    NSURLRequest *urlRequest = [self httpRequest:command];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    self.lastCallTime = -1.0;
    NSDate *startTime = [NSDate date];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSDate *endTime = [NSDate date];

    self.lastCallTime = [endTime timeIntervalSinceDate:startTime];
    
    NSDictionary *razResp = nil;
    
    if (error == nil) {
        NSString *contentLength = [response allHeaderFields][@"Content-Length"];
        int respLength = contentLength.intValue;
        if (respLength == 4) {
            NSString *respDataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([respDataStr isEqualToString:RAZNULL]) {
                razResp = @{@"Status": @"Ok"};
            }
            else {
                razResp = @{@"Status": @"Fail"};
            }
        }
        else {
            razResp = [NSJSONSerialization JSONObjectWithData:data
                                                      options: NSJSONReadingMutableContainers
                                                        error: &error];
            if (razResp == nil) {
                razResp = @{@"Status": @"Fail", @"Info":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]};
            }
        }
        
    }
    else {
        razResp = @{@"Status": @"Fail", @"Info":[error domain]};
    }

    return razResp;
}

/** ****************************************************************************************************************************
 *
 * Method name: httpRequest
 * Description: PRIVATE method to generate a NSURLREQUEST from all the bits that make up the POST command
 * Parameters:  <command> - the last bit of the command url
 * Return:      A fully complete command url in the form of NSURLRequest
 *
 */
-(NSURLRequest *)httpRequest:(NSString *)command {
    
    NSString *rootUrl = ([self.portString isEqualToString:@""] ?
                          self.urlString :
                          [NSString stringWithFormat:@"%@:%@", self.urlString, self.portString]);
    NSString *commandStr = [NSString stringWithFormat:@"/ZWaveAPI/%@", command];
    
    NSURL *fullUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", rootUrl, commandStr]];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:fullUrl cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:TIMEOUT];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    
    return theRequest;
}


@end
