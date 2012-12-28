//
//  ViewController.m
//  PopulateContacts
//
//  Created by Kevin Zych on 12-12-27.
//  Copyright (c) 2012 DevBBQ Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initializeStringArrays];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)PopulateContacts:(id)sender {
    int records = [names count];
    sheetType = ActionSheet_AddContacts;
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Add %d records to Contacts app?", records] delegate:self cancelButtonTitle:@"No way" destructiveButtonTitle:nil otherButtonTitles:@"Yes please", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:self.view];
}

- (IBAction)DeleteAllContacts:(id)sender {
    sheetType = ActionSheet_DeleteContacts;
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Remove ALL Contacts?" delegate:self cancelButtonTitle:@"No way" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (sheetType) {
        case ActionSheet_AddContacts:
            if (buttonIndex == 0) {
                NSLog(@"OK");
                int records = [self createNewContactRecord];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contacts Populated"
                                                                message:[NSString stringWithFormat:@"%d records were added.", records]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {
                NSLog(@"Cancel Button Clicked");
            }
            break;
        case ActionSheet_DeleteContacts:
            [self deleteAllContactsInAddressBook];
            break;
        default:
            break;
    }
    
    sheetType = -1;
}


- (int)createNewContactRecord {
    int recordsCreated = 0;

    for (int i=0; i<[names count]; i++) {
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
        ABRecordRef newPerson = ABPersonCreate();
        
        NSString *name = [names objectAtIndex:i];
        NSLog(@"i: %d; Name: %@", i, name);
        NSString *firstName = [self getFirstNameFromFullName:name];
        NSString *lastName = [self getLastNameFromFullName:name];
        NSString *company = [self getRandomCompany];
        
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, CFBridgingRetain(firstName), nil);
        
        ABRecordSetValue(newPerson, kABPersonLastNameProperty, CFBridgingRetain(lastName), nil);
        ABRecordSetValue(newPerson, kABPersonOrganizationProperty, CFBridgingRetain(company), nil);
        
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, CFBridgingRetain([self getRandomPhoneNumber]), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
        CFRelease(multiPhone);
        
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSString *email = [self getEmailForFirstName:firstName lastName:lastName company:company];
        ABMultiValueAddValueAndLabel(multiEmail, CFBridgingRetain(email), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, nil);
        CFRelease(multiEmail);
        
        ABAddressBookAddRecord(iPhoneAddressBook, newPerson, nil);
        ABAddressBookSave(iPhoneAddressBook, nil);
        
        CFRelease(newPerson);
        CFRelease(iPhoneAddressBook);
        
        recordsCreated++;
    }
    
    return recordsCreated;
}


- (void)deleteAllContactsInAddressBook {
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(iPhoneAddressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(iPhoneAddressBook);
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        ABAddressBookRemoveRecord(iPhoneAddressBook, ref, nil);
    }
    ABAddressBookSave(iPhoneAddressBook, nil);
}


- (NSString *)getFirstNameFromFullName:(NSString *)fullName {
    return [[fullName componentsSeparatedByString:@" "] objectAtIndex:0];
}
- (NSString *)getLastNameFromFullName:(NSString *)fullName {
    return [[fullName componentsSeparatedByString:@" "] objectAtIndex:1];
}

- (NSString *)getRandomPhoneNumber {
    return [NSString stringWithFormat:@"%d%d%d-%d%d%d-%d%d%d%d",
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10,
            arc4random() % 10];
}

- (NSString *)getEmailForFirstName:(NSString *)firstName lastName:(NSString *)lastName company:(NSString *)company {
    return [NSString stringWithFormat:@"%@.%@@%@", [firstName lowercaseString], [lastName lowercaseString], [self getDomainForCompany:company]];
}

- (NSString *)getDomainForCompany:(NSString *)company {
    // get random company and remove any spaces in name
    return [NSString stringWithFormat:@"%@.com", [[company stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]];
}

- (NSString *)getRandomCompany {
    NSUInteger randomIndex = arc4random() % [companyNames count];
    return [companyNames objectAtIndex:randomIndex];
}

- (void)initializeStringArrays {
    names = [NSArray arrayWithObjects:
             @"Abdul Sponaugle",
             @"Abe Sandquist",
             @"Adolfo Cuccia",
             @"Alyson Lalor",
             @"Anthony Oberg",
             @"Arlette Clonts",
             @"Autumn Solley",
             @"Azucena Jun",
             @"Basil Landreneau",
             @"Bennett Mancha",
             @"Benny Crater",
             @"Bethel Membreno",
             @"Blair Beers",
             @"Brianna Genna",
             @"Carlo Conder",
             @"Cedric Meunier",
             @"Cesar Gagliano",
             @"Chang Benjamin",
             @"Chelsey Minaya",
             @"Cindie Sahr",
             @"Clayton Paton",
             @"Clint Brosnahan",
             @"Daisy Alfano",
             @"Daren Jankowski",
             @"Darlene Forbus",
             @"Deanne Charles",
             @"Donny Gabriel",
             @"Dusty Omeara",
             @"Edgar Mouzon",
             @"Emogene Cardinale",
             @"Esteban Linden",
             @"Felecia Cron",
             @"Felton Mcgeehan",
             @"Floyd Gebhardt",
             @"Forest Sowders",
             @"Frank Wohlford",
             @"Garret Rape",
             @"Georgianna Vittetoe",
             @"Gigi Kellett",
             @"Giovanni Plants",
             @"Gonzalo Huard",
             @"Harlan Canton",
             @"Heath Huie",
             @"Hilma Holen",
             @"Hue Knutsen",
             @"Imelda Crossen",
             @"Issac Congdon",
             @"Jesusita Matranga",
             @"Jinny Depp",
             @"Joey Iadarola",
             @"Joie Padula",
             @"Joline Vaughn",
             @"Kacy Drouin",
             @"Kevin Zych",             
             @"Kina Rockwood",
             @"Lachelle Patti",
             @"Landon Rickey",
             @"Li Mccarron",
             @"Lincoln Wetherell",
             @"Lisabeth Cespedes",
             @"Logan Eslinger",
             @"Luciana Victorine",
             @"Lura Throneberry",
             @"Magen Nye",
             @"Malia Schmelzer",
             @"Malisa Nygren",
             @"Marcel Pitcock",
             @"Margarito Steigerwald",
             @"Marhta Mayers",
             @"Mark Mosely",
             @"Melinda Ziemer",
             @"Mohammed Valenta",
             @"Myrta Stump",
             @"Nickolas Brien",
             @"Nona Maris",
             @"Ozie Tapper",
             @"Pearlene Kish",
             @"Racheal Metellus",
             @"Refugio Murden",
             @"Reinaldo Delrosario",
             @"Reva Scharf",
             @"Rosanne Schillinger",
             @"Rosenda Fabela",
             @"Royce Theis",
             @"Seth Vu",
             @"Shad Riggins",
             @"Shameka Mahn",
             @"Sharan Gartner",
             @"Stacia Hotaling",
             @"Tamika Ohlsen",
             @"Tereasa Villatoro",
             @"Terence Hild",
             @"Terry Poplin",
             @"Tod Pineda",
             @"Valene Real",
             @"Vivian Shipman",
             @"Wes Zhu",
             @"Wilbur Jandreau",
             @"Willian Quandt",
             @"Yolanda Strait",
             nil];
        
    companyNames = [NSArray arrayWithObjects:
                    @"DevBBQ",
                    @"KayZee Solutions",
                    @"Apple",
                    @"Google",
                    @"Yahoo",
                    @"Amazon",
                    @"Microsoft",
                    @"Square",
                    @"LinkedIn",
                    @"Dropbox",
                    @"Eventbrite",
                    @"Zynga",
                    @"Twitter",                    
                    @"Facebook",
                    @"Toshiba",
                    @"JawBone",
                    @"Sony",
                    @"Oracle",
                    @"Nintendo",
                    @"NVIDEA",
                    @"Accenture",
                    @"Intuit",
                    @"Groupon",
                    @"Intel",
                    @"Adobe",
                    @"Nissan",
                    @"General Motors",
                    @"Toyota",
                    @"Honda",
                    @"Acura",
                    @"BMW",
                    nil];
}


@end
