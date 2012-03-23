//
//  SAPISearchViewController.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPISearchViewController.h"

#import "SVProgressHUD.h"
#import "SAPISearch.h"
#import "SAPISearchResultTableViewController.h"

@interface SAPISearchViewController ()

@property (retain) SAPISearch * searchQuery;

@end

@implementation SAPISearchViewController

@synthesize queryField=_queryField;
@synthesize locationField=_locationField;
@synthesize errorField=_errorString;
@synthesize searchQuery=_searchQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [_queryField release];
    [_locationField release];
    
    [_errorString release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.errorField.text = @"";
    self.title = @"SAPI Search";
}

- (void)viewDidUnload
{
    [self setQueryField:nil];
    [self setLocationField:nil];
    [self setErrorField:nil];
    
    self.searchQuery = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions

- (IBAction)search:(id)sender
{
    NSString * queryString = self.queryField.text;
    NSString * locationString = self.locationField.text;
    
    if (![queryString length] && ![locationString length])
    {
        self.errorField.text = @"One of Query or Location are required";
        return;
    }
    else
    {
        self.errorField.text = @"";
    }
    
    [SVProgressHUD showWithStatus:@"Searching..." maskType:SVProgressHUDMaskTypeBlack];
    
    self.searchQuery = [[[SAPISearch alloc] init] autorelease];

    if ([queryString length])
        self.searchQuery.query = queryString;
    
    if ([locationString length])
        self.searchQuery.location = locationString;
    
    [self.searchQuery performQueryAsyncSuccess:^(SAPISearchResult *result) {
        [SVProgressHUD dismiss];
        
        SAPISearchResultTableViewController * vc = [[[SAPISearchResultTableViewController alloc] init] autorelease];
        vc.searchResult = result;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(SAPIError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription] afterDelay:4];
    }];
}

@end
