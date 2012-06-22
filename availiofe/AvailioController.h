//
//  AvailioController.h
//  availiofe
//
//  Created by Jimmy Burrell on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface AvailioController : NSObject {

    __unsafe_unretained NSTextView *domainSearchResults;
    __weak NSTextField *domainSearchTerm;
}

- (IBAction)findDomain:(NSButton *)sender;

@property (weak) IBOutlet NSTextField *domainSearchTerm;
@property (unsafe_unretained) IBOutlet NSTextView *domainSearchResults;
@end
