//
//  JRTableViewController.m
//  JackrabbitRefresh
//
//  Created by Anthony Blatner on 2/18/14.
//  Copyright (c) 2014 Jackrabbit Mobile. All rights reserved.
//

#import "JRTableViewController.h"
#import "JRRefreshControl.h"

@interface JRTableViewController ()

@end

@implementation JRTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupRefreshControl
{
    // TODO: Programmatically inserting a UIRefreshControl
    self.refreshControl = [[JRRefreshControl alloc] initWithTableView:self.tableView];
    
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the refresh control
    [self setupRefreshControl];
}


- (void)refresh:(id)sender{
    DLog(@"");
    
    // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
    // This is where you'll make requests to an API, reload data, or process information
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        DLog(@"DONE");
        
        // When done requesting/reloading/processing invoke endRefreshing, to close the control
        [self.refreshControl endRefreshing];
    });
    // -- FINISHED SOMETHING AWESOME, WOO! --
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [((JRRefreshControl *)self.refreshControl) scrollViewDidScroll:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Row %i",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexPath: %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
