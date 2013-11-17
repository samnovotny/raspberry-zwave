//
//  SNAppDelegate.h
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

#import <Cocoa/Cocoa.h>

@interface SNAppDelegate : NSObject <NSApplicationDelegate> {
    __weak NSTextField *URLString;
    __weak NSTextField *portString;
    __unsafe_unretained NSTextView *respWindow;
    __weak NSTextField *commandString;
    __weak NSTextField *timer;
}

@property (assign) IBOutlet NSWindow *window;

@end

