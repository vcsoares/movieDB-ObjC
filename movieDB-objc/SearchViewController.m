//
//  SearchViewController.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 26/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "SearchViewController.h"
#import "Communicator.h"
#import "CommunicatorDelegate.h"
#import "Parser.h"
#import "Movie.h"
#import "DetailsViewController.h"
#import "MovieTableViewCell.h"

@interface SearchViewController ()
<CommunicatorDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;

@property NSArray* searchResults;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.communicator = [[Communicator alloc] init];
    self.communicator.delegate = self;
    
    self.moviesTableView.dataSource = self;
    self.moviesTableView.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController* detailsVC = [segue destinationViewController];
    
    if (detailsVC != nil && [sender isKindOfClass:[Movie class]]) {
        [detailsVC loadViewIfNeeded];
        [detailsVC setMovie:sender];
    }
}

#pragma mark - Communicator Delegate
- (void)fetchFailedWithError:(nonnull NSError *)error {
    NSLog(@"-XXX- FETCH FAILED");
    NSLog(@"%@", error.localizedDescription);
}

- (void)receivedMovieDetails:(nonnull NSData *)json for:(nonnull Movie *)movie {
    NSError* error = nil;
    
    [Parser detailsForMovie:movie from:json error:&error];
    
    if (error != nil) {
        NSLog(@"-XXX- FETCH DETAILS ERROR");
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"ShowMovie" sender:movie];
    });
}

- (void)receivedMovieList:(nonnull NSData *)json from:(FetchOption)option {
    NSLog(@"%@", json.description);
    
    NSError* error = nil;
    NSArray* movies = [Parser movieListFromJSON:json error:&error];
    
    if (error) {
        NSLog(@"-XXX- PARSE ERROR");
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    switch (option) {
        default:
            NSLog(@"-VVV- SEARCH SUCCESS");
            self.searchResults = movies;
            NSLog(@"%@", ((Movie*)[movies firstObject]).title);
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.moviesTableView reloadData];
    });
}

#pragma mark - Table View Data Source
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    if (cell == nil) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
     
    Movie* movie = self.searchResults[indexPath.row];
    
    if (movie != nil) {
        [cell populateCellWithMovie:movie];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Movie* movie = self.searchResults[indexPath.row];
    
    if (movie != nil) {
        [self.communicator fetchMovieDetails:movie];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}

#pragma mark - Table View Header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 22)];
    
    [label setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
    [label setText:[NSString stringWithFormat:@"Found %d movies",(int)self.searchResults.count]];
    
    [header addSubview:label];
    
    return header;
}

@end
