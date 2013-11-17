//
//  SNAppDelegate.m
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

#import "SNAppDelegate.h"
#import "SNZdevice.h"

@interface SNAppDelegate ()
@property (strong, nonatomic,readonly) SNZdevice *device;
@property (weak) IBOutlet NSTextField *URLString;
@property (weak) IBOutlet NSTextField *portString;
@property (weak) IBOutlet NSTextField *commandString;
@property (weak) IBOutlet NSTextField *timer;
@property (unsafe_unretained) IBOutlet NSTextView *respWindow;
@end

@implementation SNAppDelegate
@synthesize URLString;
@synthesize portString;
@synthesize respWindow;
@synthesize commandString;
@synthesize timer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

}

/** ****************************************************************************************************************************
 *
 * Method name: getAllData
 * Description: Simplest of commands to test your setup and get loads of data from the Razberry. Called by the 'Send' button
 *              next to the 'Retrieve all data from Razberry' textfield. Note: The field is delibaretably disabled.
 * Parameters:  n/a
 * Return:      n/a
 *
 */
- (IBAction)getAllData:(NSButton *)sender {
    SNZdevice *device = self.device;

    NSDictionary *resp = [device sendRazberryCommand:@"data/0"];            // Send command asking for all data
    self.timer.doubleValue = device.lastCallTime;                           // Display how many seconds it took to get
    [self.respWindow setString:[resp description]];                         // Dump the response in the window
}

/** ****************************************************************************************************************************
 *
 * Method name: sendCommand
 * Description: If the above (getAllData) command worked then you can start constructing your own commands and start sending
 *              them to the device. This method is called by the 'Send' button next to the 'Execute command' textfield.
 * Parameters:  n/a
 * Return:      n/a
 *
 */
- (IBAction)sendCommand:(NSButton *)sender {
    SNZdevice *device = self.device;

    NSString *command = self.commandString.stringValue;                     // Get the command from input field
    NSDictionary *resp = [device sendRazberryCommand:command];              // Send the command
    self.timer.doubleValue = device.lastCallTime;                           // Display how many seconds it took to get
    [self.respWindow setString:[resp description]];                         // Dump the response in the window
}

/** ****************************************************************************************************************************
 *
 * Method name: device
 * Description: PRIVATE function to construct a device
 * Parameters:  self.URLString and self.portString
 * Return:      the device reverence
 *
 */
- (SNZdevice *)device {
    return [[SNZdevice alloc] initWithURL:self.URLString.stringValue port:self.portString.stringValue];
}


@end
