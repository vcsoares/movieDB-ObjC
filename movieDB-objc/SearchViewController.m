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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}

- (void)fetchFailedWithError:(nonnull NSError *)error {
    NSLog(@"-XXX- FETCH FAILED");
    NSLog(@"%@", error.localizedDescription);
}

- (void)receivedMovieDetails:(nonnull NSData *)json for:(nonnull Movie *)movie {
    NSLog(@"-!-!- MOVIE DETAILS SUCCESS");
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

@end
