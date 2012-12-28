//
//  ViewController.m
//  PopulateContacts
//
//  Created by Kevin Zych on 12-12-27.
//  Copyright (c) 2012 XYZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PopulateContacts:(id)sender {

    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    
    // add infos
    NSString *firstName = [self getRandomFirstName];
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, CFBridgingRetain(firstName), nil);
    NSString *lastName = [self getRandomLastName];
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, CFBridgingRetain(lastName), nil);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, CFBridgingRetain([self getRandomCompany]), nil);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    ABMultiValueAddValueAndLabel(multiPhone, CFBridgingRetain([self getRandomPhoneNumber]), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
    CFRelease(multiPhone);
    
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSString *email = [self getRandomEmailForFirstName:firstName andLastName:lastName];
    ABMultiValueAddValueAndLabel(multiEmail, CFBridgingRetain(email), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, nil);
    
    CFRelease(multiEmail);
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, nil);
    ABAddressBookSave(iPhoneAddressBook, nil);
    
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
}

- (NSString *)getRandomFirstName {
    return @"Kevin";
}
- (NSString *)getRandomLastName {
    return @"Zych";
}

- (NSString *)getRandomPhoneNumber {
    return @"905-555-5555";
}

- (NSString *)getRandomEmailForFirstName:(NSString *)firstName andLastName:(NSString *)lastName {
    return [NSString stringWithFormat:@"%@.%@@%@", [firstName lowercaseString], [lastName lowercaseString], [self getRandomDomain]];
}
- (NSString *)getRandomDomain {
    return [NSString stringWithFormat:@"%@.com", [[self getRandomCompany] lowercaseString]];
}
- (NSString *)getRandomCompany {
    return @"DevBBQ";
}


@end
