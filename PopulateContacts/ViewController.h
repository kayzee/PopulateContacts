//
//  ViewController.h
//  PopulateContacts
//
//  Created by Kevin Zych on 12-12-27.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

enum eActionSheet {
    ActionSheet_AddContacts = 1,
    ActionSheet_DeleteContacts = 2
};

@interface ViewController : UIViewController <UIActionSheetDelegate> {
    NSArray *names;
    NSArray *companyNames;
    
    enum eActionSheet sheetType;
}

- (IBAction)PopulateContacts:(id)sender;
- (IBAction)DeleteAllContacts:(id)sender;

@end
