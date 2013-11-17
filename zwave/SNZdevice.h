//
//  SNZdevice.h
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

#import <Foundation/Foundation.h>

#define RAZNULL     @"null"     // OK resposnes from Razberry
#define TIMEOUT     5.0         // How long we are prepared to wait for the Razberry to respond

@interface SNZdevice : NSObject

@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *portString;
@property (assign) NSTimeInterval lastCallTime;

- (id) initWithURL:(NSString *)urlStr port:(NSString*)portStr;
- (NSDictionary *) sendRazberryCommand:(NSString *)command;

@end

