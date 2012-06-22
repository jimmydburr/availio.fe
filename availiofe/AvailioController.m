//
//  AvailioController.m
//  availiofe
//
//  Created by Jimmy Burrell on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// define a constant for a background queue
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
// define a constant for the avail.io URL
#define kAvailioApiURL [NSURL URLWithString: @"http://api.avail.io/"]

#import "AvailioController.h"

@implementation AvailioController
@synthesize domainSearchResults;
@synthesize domainSearchTerm;

- (IBAction)findDomain:(NSButton *)sender {
    //NSLog(@"Got %@ as a domainSearchTerm.", domainSearchTerm.stringValue);
    domainSearchResults.string = [NSString stringWithFormat:@"Querying for available domains based on %@.\n", domainSearchTerm.stringValue];
    // make the call to avail.io to get the JSON
    dispatch_async(kBgQueue, ^{ 
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString:domainSearchTerm.stringValue relativeToURL: kAvailioApiURL]];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });

}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSString* availability;
    NSError* error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData                         
                                                         options:kNilOptions 
                                                           error:&error];
    
    // make sure we got something, otherwise error out
    if (!json) {
        domainSearchResults.string = @"%@: Error retrieving results: %@", [self class], [error localizedDescription];
        return;
    }
    
    // ok, should be safe to proceed with parsing
    NSArray* jsonReturned = [json objectForKey:@"response"];
    //NSLog(@"JSON returned: %@", jsonReturned);
    
    // loop through the JSON results
    for (NSDictionary* mostRecentDomain in jsonReturned) {
        
        // get the mostRecentDomain availablility
        NSNumber* available = [mostRecentDomain objectForKey:@"available"];
        
        // test availability and display results accordingly
        if ([available integerValue] == 1){
            availability = @"YES";
        } else {
            availability = @"NO";
        }
        // append this domain and availability to the text view
        domainSearchResults.string = [NSString stringWithFormat:@"%@\n%@\t\tavailable = %@", domainSearchResults.string,[mostRecentDomain objectForKey:@"domain"], availability];
    }// end for-in loop through jsonReturned
}

@end
