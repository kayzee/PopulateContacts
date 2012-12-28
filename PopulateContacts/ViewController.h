//
//  ViewController.h
//  PopulateContacts
//
//  Created by Kevin Zych on 12-12-27.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface ViewController : UIViewController <UIActionSheetDelegate> {
    NSArray *names;
    NSArray *companyNames;
}

- (IBAction)PopulateContacts:(id)sender;

@end
